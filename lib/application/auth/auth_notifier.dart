import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/values_object/failure.dart';
import '../core/async_state.dart';

class AuthNotifier extends StateNotifier<AsyncState<UserEntity?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncState.initial());

  Future<void> checkAuthStatus() async {
    state = const AsyncState.loading();

    final result = await _repository.isLoggedIn();
    result.fold(
      (failure) {
        state = const AsyncState.data(null);
      },
      (isLoggedIn) {
        state = AsyncState.data(
          isLoggedIn
              ? const UserEntity(id: 0, username: 'User', email: '')
              : null,
        );
      },
    );
  }

  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncState.loading();

    if (username.trim().isEmpty) {
      final failure = const ValidationFailure(
        message: 'Username tidak boleh kosong',
      );
      state = const AsyncState.data(null);
      return Left(failure);
    }

    if (password.trim().isEmpty) {
      final failure = const ValidationFailure(
        message: 'Password tidak boleh kosong',
      );
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

  bool get isLoggedIn =>
      state.maybeWhen(data: (user) => user != null, orElse: () => false);

  UserEntity? get currentUser =>
      state.maybeWhen(data: (user) => user, orElse: () => null);
}
