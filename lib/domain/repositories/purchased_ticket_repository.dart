import 'package:fpdart/fpdart.dart';
import '../entities/purchased_ticket_entity.dart';
import '../values_object/failure.dart';

abstract class PurchasedTicketRepository {
  // Get purchased tickets by show ID
  Future<Either<Failure, List<PurchasedTicketEntity>>> getPurchasedTicketsByShowId(int showId);

  // Get single purchased ticket by ID
  Future<Either<Failure, PurchasedTicketEntity>> getPurchasedTicketById(int id);
}