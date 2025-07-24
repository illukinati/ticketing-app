import 'package:dio/dio.dart';
import '../core/api_constants.dart';
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
    int? movedFromPhaseId,
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
    int? movedFromPhaseId,
    int movedQty = 0,
  });
  Future<void> deleteEventTicket(int id);
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
        throw Exception('Failed to load event tickets by category');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
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
        throw Exception('Failed to load event tickets by show');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
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
    int? movedFromPhaseId,
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

      if (movedFromPhaseId != null) {
        data['moved_from_phase_id'] = movedFromPhaseId;
      }

      final response = await dio.post(ApiConstants.eventTickets, data: data);

      if (response.statusCode == 201) {
        return EventTicketModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create event ticket');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
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
    int? movedFromPhaseId,
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

      if (movedFromPhaseId != null) {
        data['moved_from_phase_id'] = movedFromPhaseId;
      }

      final response = await dio.patch('${ApiConstants.eventTickets}/$id', data: data);

      if (response.statusCode == 200) {
        return EventTicketModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update event ticket');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> deleteEventTicket(int id) async {
    try {
      final response = await dio.delete('${ApiConstants.eventTickets}/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete event ticket');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
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
        throw Exception('Failed to update event ticket status');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}