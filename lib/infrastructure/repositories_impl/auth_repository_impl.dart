import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/values_object/failure.dart';
import '../data_source/auth_remote_data_source.dart';
import '../data_source/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final authResponse = await remoteDataSource.login(
        username: username,
        password: password,
      );
      
      // Save token to local storage
      await localDataSource.saveToken(authResponse.token);
      
      // Convert to UserEntity with token
      return Right(authResponse.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      // Call remote logout first
      await remoteDataSource.logout();
      
      // Remove token from local storage
      await localDataSource.removeToken();
      
      return const Right(unit);
    } on Failure catch (e) {
      // Even if remote logout fails, remove local token
      try {
        await localDataSource.removeToken();
      } catch (_) {}
      return Left(e);
    } catch (e) {
      // Even if remote logout fails, remove local token
      try {
        await localDataSource.removeToken();
      } catch (_) {}
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveToken(String token) async {
    try {
      await localDataSource.saveToken(token);
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeToken() async {
    try {
      await localDataSource.removeToken();
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }
}