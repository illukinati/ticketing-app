import 'package:dio/dio.dart';
import '../../domain/values_object/failure.dart';
import '../core/api_constants.dart';
import '../core/dio_error_handler.dart';
import '../model/auth_response_model.dart';
import '../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });

  Future<UserModel> getCurrentUser();

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                headers: ApiConstants.headers,
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
              ),
            );

  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final data = {
        'username': username,
        'password': password,
      };

      final response = await dio.post('/auth/login', data: data);

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to login',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to get current user',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await dio.post('/auth/logout');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerFailure(
          message: 'Failed to logout',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }
}