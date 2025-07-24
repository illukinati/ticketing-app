import 'package:fpdart/fpdart.dart';
import '../../domain/entities/phase_entity.dart';
import '../../domain/values_object/failure.dart';
import '../../domain/repositories/phase_repository.dart';
import '../data_source/phase_remote_data_source.dart';

class PhaseRepositoryImpl implements PhaseRepository {
  final PhaseRemoteDataSource remoteDataSource;

  PhaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PhaseEntity>>> getAllPhases() async {
    try {
      final phases = await remoteDataSource.getAllPhases();
      return Right(phases.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PhaseEntity>> getPhaseById(int id) async {
    try {
      final phase = await remoteDataSource.getPhaseById(id);
      return Right(phase.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PhaseEntity>> createPhase({
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Phase name cannot be empty'),
        );
      }
      if (description.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Phase description cannot be empty'),
        );
      }
      if (startDate.isAfter(endDate)) {
        return const Left(
          ValidationFailure(message: 'Start date must be before end date'),
        );
      }

      final phase = await remoteDataSource.createPhase(
        name: name.trim(),
        description: description.trim(),
        startDate: startDate,
        endDate: endDate,
        active: active,
      );
      return Right(phase.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
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
      if (name.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Phase name cannot be empty'),
        );
      }
      if (description.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Phase description cannot be empty'),
        );
      }
      if (startDate.isAfter(endDate)) {
        return const Left(
          ValidationFailure(message: 'Start date must be before end date'),
        );
      }

      final phase = await remoteDataSource.updatePhase(
        id: id,
        name: name.trim(),
        description: description.trim(),
        startDate: startDate,
        endDate: endDate,
        active: active,
      );
      return Right(phase.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePhase(int id) async {
    try {
      await remoteDataSource.deletePhase(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
