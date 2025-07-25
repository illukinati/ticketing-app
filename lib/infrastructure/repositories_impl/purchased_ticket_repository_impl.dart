import 'package:fpdart/fpdart.dart';
import '../../domain/entities/purchased_ticket_entity.dart';
import '../../domain/repositories/purchased_ticket_repository.dart';
import '../../domain/values_object/failure.dart';
import '../data_source/purchased_ticket_remote_data_source.dart';

class PurchasedTicketRepositoryImpl implements PurchasedTicketRepository {
  final PurchasedTicketRemoteDataSource remoteDataSource;

  const PurchasedTicketRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<PurchasedTicketEntity>>> getAllPurchasedTickets() async {
    try {
      final models = await remoteDataSource.getAllPurchasedTickets();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PurchasedTicketEntity>>> getPurchasedTicketsByShowId(int showId) async {
    try {
      final models = await remoteDataSource.getPurchasedTicketsByShowId(showId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}