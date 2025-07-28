import 'package:dio/dio.dart';
import '../../domain/values_object/failure.dart';
import '../core/api_constants.dart';
import '../core/dio_error_handler.dart';
import '../model/event_ticket_model.dart';

abstract class EventTicketRemoteDataSource {
  Future<List<EventTicketModel>> getEventTicketsByCategoryId(int categoryId);
  Future<List<EventTicketModel>> getEventTicketsByShowId(int showId);
  Future<EventTicketModel> createEventTicket({
    required int qty,
    required double price,
    required int showId,
    required int phaseId,
    required int categoryId,
    required String status,
    required int originalQty,
    int movedQty = 0,
  });
  Future<EventTicketModel> updateEventTicket({
    required int id,
    required int qty,
    required double price,
    required int showId,
    required int phaseId,
    required int categoryId,
    required String status,
    required int originalQty,
    int movedQty = 0,
  });
  Future<void> deleteEventTicket(int showId, int ticketId);
  Future<EventTicketModel> updateEventTicketStatus({
    required int id,
    required String status,
  });
}

class EventTicketRemoteDataSourceImpl implements EventTicketRemoteDataSource {
  final Dio dio;

  EventTicketRemoteDataSourceImpl({Dio? dio})
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
  Future<List<EventTicketModel>> getEventTicketsByCategoryId(int categoryId) async {
    try {
      final response = await dio.get('${ApiConstants.categories}/$categoryId${ApiConstants.eventTickets}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => EventTicketModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          message: 'Failed to load event tickets by category',
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
  Future<List<EventTicketModel>> getEventTicketsByShowId(int showId) async {
    try {
      final response = await dio.get('${ApiConstants.shows}/$showId${ApiConstants.eventTickets}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => EventTicketModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          message: 'Failed to load event tickets by show',
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
  Future<EventTicketModel> createEventTicket({
    required int qty,
    required double price,
    required int showId,
    required int phaseId,
    required int categoryId,
    required String status,
    required int originalQty,
    int movedQty = 0,
  }) async {
    try {
      final data = {
        'qty': qty,
        'price': price,
        'show_id': showId,
        'phase_id': phaseId,
        'category_id': categoryId,
        'status': status,
        'original_qty': originalQty,
        'moved_qty': movedQty,
      };


      final response = await dio.post(ApiConstants.eventTickets, data: data);

      if (response.statusCode == 201) {
        return EventTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to create event ticket',
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
  Future<EventTicketModel> updateEventTicket({
    required int id,
    required int qty,
    required double price,
    required int showId,
    required int phaseId,
    required int categoryId,
    required String status,
    required int originalQty,
    int movedQty = 0,
  }) async {
    try {
      final data = {
        'qty': qty,
        'price': price,
        'show_id': showId,
        'phase_id': phaseId,
        'category_id': categoryId,
        'status': status,
        'original_qty': originalQty,
        'moved_qty': movedQty,
      };


      final response = await dio.patch('${ApiConstants.eventTickets}/$id', data: data);

      if (response.statusCode == 200) {
        return EventTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to update event ticket',
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
  Future<void> deleteEventTicket(int showId, int ticketId) async {
    try {
      final response = await dio.delete('${ApiConstants.shows}/$showId${ApiConstants.eventTickets}/$ticketId');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerFailure(
          message: 'Failed to delete event ticket',
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
  Future<EventTicketModel> updateEventTicketStatus({
    required int id,
    required String status,
  }) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.eventTickets}/$id',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        return EventTicketModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to update event ticket status',
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