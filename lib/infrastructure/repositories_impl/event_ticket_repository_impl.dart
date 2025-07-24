import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/event_ticket_entity.dart';
import '../../domain/values_object/failure.dart';
import '../../domain/repositories/event_ticket_repository.dart';
import '../data_source/event_ticket_remote_data_source.dart';
import '../core/dio_error_handler.dart';

class EventTicketRepositoryImpl implements EventTicketRepository {
  final EventTicketRemoteDataSource remoteDataSource;

  EventTicketRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EventTicketEntity>>> getEventTicketsByCategoryId(int categoryId) async {
    try {
      final ticketModels = await remoteDataSource.getEventTicketsByCategoryId(categoryId);
      final entities = ticketModels.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventTicketEntity>>> getEventTicketsByShowId(int showId) async {
    try {
      final ticketModels = await remoteDataSource.getEventTicketsByShowId(showId);
      final entities = ticketModels.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventTicketEntity>> createEventTicket({
    required int qty,
    required double price,
    required int showId,
    required int phaseId,
    required int categoryId,
    required TicketStatus status,
    required int originalQty,
    int? movedFromPhaseId,
    int movedQty = 0,
  }) async {
    try {
      final ticketModel = await remoteDataSource.createEventTicket(
        qty: qty,
        price: price,
        showId: showId,
        phaseId: phaseId,
        categoryId: categoryId,
        status: status.value,
        originalQty: originalQty,
        movedFromPhaseId: movedFromPhaseId,
        movedQty: movedQty,
      );
      return Right(ticketModel.toEntity());
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventTicketEntity>> updateEventTicket({
    required int id,
    required int qty,
    required double price,
    required int showId,
    required int phaseId,
    required int categoryId,
    required TicketStatus status,
    required int originalQty,
    int? movedFromPhaseId,
    int movedQty = 0,
  }) async {
    try {
      final ticketModel = await remoteDataSource.updateEventTicket(
        id: id,
        qty: qty,
        price: price,
        showId: showId,
        phaseId: phaseId,
        categoryId: categoryId,
        status: status.value,
        originalQty: originalQty,
        movedFromPhaseId: movedFromPhaseId,
        movedQty: movedQty,
      );
      return Right(ticketModel.toEntity());
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEventTicket(int id) async {
    try {
      await remoteDataSource.deleteEventTicket(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventTicketEntity>> updateTicketStatus({
    required int id,
    required TicketStatus status,
  }) async {
    try {
      final ticketModel = await remoteDataSource.updateEventTicketStatus(
        id: id,
        status: status.value,
      );
      return Right(ticketModel.toEntity());
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}