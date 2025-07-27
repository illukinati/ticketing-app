import 'package:dio/dio.dart';
import '../../domain/values_object/failure.dart';
import '../core/api_constants.dart';
import '../core/dio_error_handler.dart';
import '../model/purchased_ticket_model.dart';
import '../model/individual_ticket_model.dart';

abstract class PurchasedTicketRemoteDataSource {
  Future<List<PurchasedTicketModel>> getAllPurchasedTickets();
  Future<List<PurchasedTicketModel>> getPurchasedTicketsByShowId(int showId);
  Future<List<PurchasedTicketModel>> getPurchasedTicketsByEventTicketId(int eventTicketId);
  Future<List<PurchasedTicketModel>> getPurchasedTicketsByPaymentStatus(String status);
  Future<PurchasedTicketModel> getPurchasedTicketById(int id);
  Future<PurchasedTicketModel> createPurchasedTicket({
    required String name,
    required String phone,
    required String email,
    required int quantity,
    required int eventTicketId,
    String paymentStatus = 'pending',
  });
  Future<PurchasedTicketModel> updatePaymentStatus({
    required int id,
    required String status,
    DateTime? paidAt,
  });
  Future<PurchasedTicketModel> updatePurchasedTicket({
    required int id,
    String? name,
    String? phone,
    String? email,
  });
  Future<void> deletePurchasedTicket(int id);
  Future<IndividualTicketModel> markTicketAsUsed({
    required int ticketId,
    DateTime? usedAt,
  });
  Future<IndividualTicketModel> markTicketAsUnused(int ticketId);
  Future<IndividualTicketModel> getIndividualTicketById(int ticketId);
  Future<List<IndividualTicketModel>> getIndividualTicketsByPurchasedTicketId(int purchasedTicketId);
  Future<List<PurchasedTicketModel>> searchPurchasedTickets({
    String? name,
    String? phone,
    String? email,
  });
  Future<Map<String, dynamic>> getPurchasedTicketStatistics(int showId);
}

class PurchasedTicketRemoteDataSourceImpl implements PurchasedTicketRemoteDataSource {
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
  Future<List<PurchasedTicketModel>> getAllPurchasedTickets() async {
    try {
      final response = await dio.get(ApiConstants.purchases);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => PurchasedTicketModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
            message: 'Failed to load purchased tickets',
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
  Future<List<PurchasedTicketModel>> getPurchasedTicketsByShowId(int showId) async {
    try {
      final response = await dio.get('${ApiConstants.purchases}?show_id=$showId');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => PurchasedTicketModel.fromJson(json)).toList();
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
  Future<List<PurchasedTicketModel>> getPurchasedTicketsByEventTicketId(int eventTicketId) async {
    try {
      final response = await dio.get('${ApiConstants.purchases}?event_ticket_id=$eventTicketId');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => PurchasedTicketModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
            message: 'Failed to load purchased tickets by event ticket',
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
  Future<List<PurchasedTicketModel>> getPurchasedTicketsByPaymentStatus(String status) async {
    try {
      final response = await dio.get('${ApiConstants.purchases}?payment_status=$status');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => PurchasedTicketModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
            message: 'Failed to load purchased tickets by payment status',
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
  Future<PurchasedTicketModel> createPurchasedTicket({
    required String name,
    required String phone,
    required String email,
    required int quantity,
    required int eventTicketId,
    String paymentStatus = 'pending',
  }) async {
    try {
      final data = {
        'name': name,
        'phone': phone,
        'email': email,
        'quantity': quantity,
        'event_ticket_id': eventTicketId,
        'payment_status': paymentStatus,
      };

      final response = await dio.post(ApiConstants.purchases, data: data);

      if (response.statusCode == 201) {
        return PurchasedTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
            message: 'Failed to create purchased ticket',
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
  Future<PurchasedTicketModel> updatePaymentStatus({
    required int id,
    required String status,
    DateTime? paidAt,
  }) async {
    try {
      final data = {
        'payment_status': status,
        if (paidAt != null) 'paid_at': paidAt.toIso8601String(),
      };

      final response = await dio.patch('${ApiConstants.purchases}/$id', data: data);

      if (response.statusCode == 200) {
        return PurchasedTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
            message: 'Failed to update payment status',
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
  Future<PurchasedTicketModel> updatePurchasedTicket({
    required int id,
    String? name,
    String? phone,
    String? email,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (email != null) data['email'] = email;

      final response = await dio.patch('${ApiConstants.purchases}/$id', data: data);

      if (response.statusCode == 200) {
        return PurchasedTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
            message: 'Failed to update purchased ticket',
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
  Future<void> deletePurchasedTicket(int id) async {
    try {
      final response = await dio.delete('${ApiConstants.purchases}/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerFailure(
            message: 'Failed to delete purchased ticket',
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
  Future<IndividualTicketModel> markTicketAsUsed({
    required int ticketId,
    DateTime? usedAt,
  }) async {
    try {
      final data = {
        'used': true,
        'used_at': (usedAt ?? DateTime.now()).toIso8601String(),
      };

      final response = await dio.patch('/individual_tickets/$ticketId', data: data);

      if (response.statusCode == 200) {
        return IndividualTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
            message: 'Failed to mark ticket as used',
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
  Future<IndividualTicketModel> markTicketAsUnused(int ticketId) async {
    try {
      final data = {
        'used': false,
        'used_at': null,
      };

      final response = await dio.patch('/individual_tickets/$ticketId', data: data);

      if (response.statusCode == 200) {
        return IndividualTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
            message: 'Failed to mark ticket as unused',
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
  Future<IndividualTicketModel> getIndividualTicketById(int ticketId) async {
    try {
      final response = await dio.get('/individual_tickets/$ticketId');

      if (response.statusCode == 200) {
        return IndividualTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
            message: 'Failed to load individual ticket',
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
  Future<List<IndividualTicketModel>> getIndividualTicketsByPurchasedTicketId(int purchasedTicketId) async {
    try {
      final response = await dio.get('${ApiConstants.purchases}/$purchasedTicketId/individual_tickets');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => IndividualTicketModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
            message: 'Failed to load individual tickets',
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
  Future<List<PurchasedTicketModel>> searchPurchasedTickets({
    String? name,
    String? phone,
    String? email,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (name != null) queryParams['name'] = name;
      if (phone != null) queryParams['phone'] = phone;
      if (email != null) queryParams['email'] = email;

      final response = await dio.get(
        '${ApiConstants.purchases}/search',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => PurchasedTicketModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
            message: 'Failed to search purchased tickets',
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
  Future<Map<String, dynamic>> getPurchasedTicketStatistics(int showId) async {
    try {
      final response = await dio.get('${ApiConstants.shows}/$showId/purchase_statistics');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerFailure(
            message: 'Failed to load purchase statistics',
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