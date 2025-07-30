import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../domain/values_object/failure.dart';
import '../core/api_constants.dart';
import '../core/dio_error_handler.dart';
import '../model/purchased_ticket_model.dart';

abstract class PurchasedTicketRemoteDataSource {
  Future<List<PurchasedTicketModel>> getPurchasedTicketsByShowId(int showId);
  Future<PurchasedTicketModel> getPurchasedTicketById(int id);
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
      debugPrint('🌐 API Call: ${ApiConstants.baseUrl}${ApiConstants.shows}/$showId/purchases');
      final response = await dio.get('${ApiConstants.shows}/$showId/purchases');

      if (response.statusCode == 200) {
        debugPrint('✅ API Response: ${response.data}');
        final List<dynamic> jsonList = response.data;
        final result = jsonList.map((json) => PurchasedTicketModel.fromJson(json)).toList();
        debugPrint('✅ Parsed ${result.length} purchased tickets');
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
      debugPrint('🌐 API Call: ${ApiConstants.baseUrl}${ApiConstants.purchases}/$id');
      final response = await dio.get('${ApiConstants.purchases}/$id');

      if (response.statusCode == 200) {
        debugPrint('✅ API Response: ${response.data}');
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
}