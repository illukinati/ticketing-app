import 'package:fpdart/fpdart.dart';
import '../entities/event_ticket_entity.dart';
import '../values_object/failure.dart';

abstract class EventTicketRepository {
  // Get event tickets by category ID
  Future<Either<Failure, List<EventTicketEntity>>> getEventTicketsByCategoryId(int categoryId);

  // Get event tickets by show ID
  Future<Either<Failure, List<EventTicketEntity>>> getEventTicketsByShowId(int showId);

  // Create a new event ticket
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
  });

  // Update an event ticket
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
  });

  // Delete an event ticket
  Future<Either<Failure, Unit>> deleteEventTicket(int id);

  // Update ticket status
  Future<Either<Failure, EventTicketEntity>> updateTicketStatus({
    required int id,
    required TicketStatus status,
  });
}