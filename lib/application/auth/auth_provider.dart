import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../infrastructure/repositories_impl/auth_repository_impl.dart';
import '../../infrastructure/data_source/auth_remote_data_source.dart';
import '../../infrastructure/data_source/auth_local_data_source.dart';
import '../core/async_state.dart';
import 'auth_notifier.dart';

// Data source providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl();
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});

// Auth notifier provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncState<UserEntity?>>((ref) {
      return AuthNotifier(ref.read(authRepositoryProvider));
    });

// Convenience providers for common auth operations
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(
    authNotifierProvider.select(
      (state) =>
          state.maybeWhen(data: (user) => user != null, orElse: () => false),
    ),
  );
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(
    authNotifierProvider.select(
      (state) => state.maybeWhen(data: (user) => user, orElse: () => null),
    ),
  );
});
