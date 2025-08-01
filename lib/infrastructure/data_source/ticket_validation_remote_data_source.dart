import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../domain/values_object/failure.dart';
import '../core/api_constants.dart';
import '../core/dio_error_handler.dart';
import '../model/ticket_validation_model.dart';

abstract class TicketValidationRemoteDataSource {
  Future<TicketValidationModel> validateTicket({required String token});
}

class TicketValidationRemoteDataSourceImpl
    implements TicketValidationRemoteDataSource {
  final Dio dio;

  TicketValidationRemoteDataSourceImpl({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              headers: ApiConstants.headers,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

  @override
  Future<TicketValidationModel> validateTicket({required String token}) async {
    try {
      final response = await dio.get('${ApiConstants.ticketsValidate}/$token');

      if (response.statusCode == 200) {
        return TicketValidationModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to validate ticket',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ValidationFailure(message: 'Tiket tidak ditemukan');
      }
      if (e.response?.statusCode == 400) {
        throw ValidationFailure(message: 'Token tidak valid');
      }
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }
}
