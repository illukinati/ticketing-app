import 'package:fpdart/fpdart.dart';
import '../../domain/entities/ticket_validation_entity.dart';
import '../../domain/repositories/ticket_validation_repository.dart';
import '../../domain/values_object/failure.dart';
import '../data_source/ticket_validation_remote_data_source.dart';

class TicketValidationRepositoryImpl implements TicketValidationRepository {
  final TicketValidationRemoteDataSource remoteDataSource;

  TicketValidationRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, TicketValidationEntity>> validateTicket({
    required String token,
  }) async {
    try {
      final validationModel = await remoteDataSource.validateTicket(token: token);
      return Right(validationModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }
}