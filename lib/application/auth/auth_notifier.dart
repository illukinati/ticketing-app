import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/values_object/failure.dart';
import '../core/async_state.dart';

class AuthNotifier extends StateNotifier<AsyncState<UserEntity?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncState.initial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = const AsyncState.loading();
    
    final result = await _repository.isLoggedIn();
    result.fold(
      (failure) => state = const AsyncState.data(null),
      (isLoggedIn) async {
        if (isLoggedIn) {
          final userResult = await _repository.getCurrentUser();
          userResult.fold(
            (failure) => state = const AsyncState.data(null),
            (user) => state = AsyncState.data(user),
          );
        } else {
          state = const AsyncState.data(null);
        }
      },
    );
  }

  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncState.loading();

    if (username.trim().isEmpty) {
      final failure = const ValidationFailure(message: 'Username tidak boleh kosong');
      state = const AsyncState.data(null);
      return Left(failure);
    }

    if (password.trim().isEmpty) {
      final failure = const ValidationFailure(message: 'Password tidak boleh kosong');
      state = const AsyncState.data(null);
      return Left(failure);
    }

    final result = await _repository.login(
      username: username.trim(),
      password: password,
    );

    return result.fold(
      (failure) {
        state = const AsyncState.data(null);
        return Left(failure);
      },
      (user) {
        state = AsyncState.data(user);
        return Right(user);
      },
    );
  }

  Future<Either<Failure, Unit>> logout() async {
    final result = await _repository.logout();
    
    result.fold(
      (failure) => null, // Keep current state on failure
      (_) => state = const AsyncState.data(null),
    );

    return result;
  }

  Future<void> refreshUser() async {
    state = const AsyncState.loading();
    
    final result = await _repository.getCurrentUser();
    result.fold(
      (failure) => state = AsyncState.error(failure),
      (user) => state = AsyncState.data(user),
    );
  }

  void refresh() {
    checkAuthStatus();
  }

  bool get isLoggedIn => state.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );

  UserEntity? get currentUser => state.maybeWhen(
    data: (user) => user,
    orElse: () => null,
  );
}