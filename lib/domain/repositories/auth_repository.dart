import 'package:fpdart/fpdart.dart';
import '../entities/user_entity.dart';
import '../values_object/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, String?>> getToken();

  Future<Either<Failure, Unit>> saveToken(String token);

  Future<Either<Failure, Unit>> removeToken();
}