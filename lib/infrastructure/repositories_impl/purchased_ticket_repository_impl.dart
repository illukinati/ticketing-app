import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/purchased_ticket_entity.dart';
import '../../domain/repositories/purchased_ticket_repository.dart';
import '../../domain/values_object/failure.dart';
import '../data_source/purchased_ticket_remote_data_source.dart';
import '../core/dio_error_handler.dart';

class PurchasedTicketRepositoryImpl implements PurchasedTicketRepository {
  final PurchasedTicketRemoteDataSource remoteDataSource;

  const PurchasedTicketRepositoryImpl({
    required this.remoteDataSource,
  });


  @override
  Future<Either<Failure, List<PurchasedTicketEntity>>> getPurchasedTicketsByShowId(int showId) async {
    try {
      final models = await remoteDataSource.getPurchasedTicketsByShowId(showId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, PurchasedTicketEntity>> getPurchasedTicketById(int id) async {
    try {
      final model = await remoteDataSource.getPurchasedTicketById(id);
      return Right(model.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, void>> resendEmail(int purchaseId) async {
    try {
      await remoteDataSource.resendEmail(purchaseId);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }
}