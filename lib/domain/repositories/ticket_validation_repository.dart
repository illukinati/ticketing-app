import 'package:fpdart/fpdart.dart';
import '../entities/ticket_validation_entity.dart';
import '../values_object/failure.dart';

abstract class TicketValidationRepository {
  Future<Either<Failure, TicketValidationEntity>> validateTicket({
    required String token,
  });
}