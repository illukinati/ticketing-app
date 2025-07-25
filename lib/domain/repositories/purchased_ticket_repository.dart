import 'package:fpdart/fpdart.dart';
import '../entities/purchased_ticket_entity.dart';
import '../values_object/failure.dart';

abstract class PurchasedTicketRepository {
  // Get all purchased tickets
  Future<Either<Failure, List<PurchasedTicketEntity>>> getAllPurchasedTickets();

  // Get purchased tickets by show ID
  Future<Either<Failure, List<PurchasedTicketEntity>>> getPurchasedTicketsByShowId(int showId);
}