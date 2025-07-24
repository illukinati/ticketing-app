import 'package:dio/dio.dart';
import '../../domain/values_object/failure.dart';

class DioErrorHandler {
  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(message: 'Connection timeout', code: 'TIMEOUT');
      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'No internet connection',
          code: 'NO_CONNECTION',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';
        return ServerFailure(message: message, code: statusCode?.toString());
      case DioExceptionType.cancel:
        return NetworkFailure(message: 'Request cancelled', code: 'CANCELLED');
      default:
        return UnknownFailure(
          message: error.message ?? 'Unknown error occurred',
        );
    }
  }
}