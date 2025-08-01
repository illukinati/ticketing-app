import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../domain/values_object/failure.dart';
import '../core/api_constants.dart';
import '../core/dio_error_handler.dart';
import '../model/purchased_ticket_model.dart';

abstract class PurchasedTicketRemoteDataSource {
  Future<List<PurchasedTicketModel>> getPurchasedTicketsByShowId(int showId);
  Future<PurchasedTicketModel> getPurchasedTicketById(int id);
  Future<void> resendEmail(int purchaseId);
}

class PurchasedTicketRemoteDataSourceImpl
    implements PurchasedTicketRemoteDataSource {
  final Dio dio;

  PurchasedTicketRemoteDataSourceImpl({Dio? dio})
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
  Future<List<PurchasedTicketModel>> getPurchasedTicketsByShowId(
    int showId,
  ) async {
    try {
      final response = await dio.get('${ApiConstants.shows}/$showId/purchases');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final result = jsonList.map((json) => PurchasedTicketModel.fromJson(json)).toList();
        return result;
      } else {
        throw ServerFailure(
          message: 'Failed to load purchased tickets by show',
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
  Future<PurchasedTicketModel> getPurchasedTicketById(int id) async {
    try {
      final response = await dio.get('${ApiConstants.purchases}/$id');

      if (response.statusCode == 200) {
        return PurchasedTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to load purchased ticket',
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
  Future<void> resendEmail(int purchaseId) async {
    try {
      debugPrint('🌐 API Call: ${ApiConstants.baseUrl}/api${ApiConstants.purchases}/$purchaseId/resend_email');
      final response = await dio.post('/api${ApiConstants.purchases}/$purchaseId/resend_email');

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Email resent successfully');
        return;
      } else {
        debugPrint('❌ Resend email failed - Status: ${response.statusCode}, Response: ${response.data}');
        throw ServerFailure(
          message: 'Failed to resend email',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ Resend email DioException - ${e.type}: ${e.message}');
      if (e.response != null) {
        debugPrint('❌ API Response - Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
      }
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      debugPrint('❌ Resend email unknown error: $e');
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }
}