import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/phase_entity.dart';
import '../../domain/values_object/failure.dart';
import '../../domain/repositories/phase_repository.dart';
import '../data_source/phase_remote_data_source.dart';
import '../core/dio_error_handler.dart';

class PhaseRepositoryImpl implements PhaseRepository {
  final PhaseRemoteDataSource remoteDataSource;

  PhaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PhaseEntity>> createPhase({
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  }) async {
    try {
      final phaseModel = await remoteDataSource.createPhase(
        name: name,
        description: description,
        startDate: startDate,
        endDate: endDate,
        active: active,
      );
      return Right(phaseModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, List<PhaseEntity>>> getAllPhases() async {
    try {
      final phaseModels = await remoteDataSource.getAllPhases();
      final entities = phaseModels.map((model) => model.toEntity()).toList();
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
  Future<Either<Failure, PhaseEntity>> getPhaseById(int id) async {
    try {
      final phaseModel = await remoteDataSource.getPhaseById(id);
      return Right(phaseModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, PhaseEntity>> updatePhase({
    required int id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  }) async {
    try {
      final phaseModel = await remoteDataSource.updatePhase(
        id: id,
        name: name,
        description: description,
        startDate: startDate,
        endDate: endDate,
        active: active,
      );
      return Right(phaseModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePhase(int id) async {
    try {
      await remoteDataSource.deletePhase(id);
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }
}