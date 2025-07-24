import 'package:fpdart/fpdart.dart';
import '../entities/phase_entity.dart';
import '../values_object/failure.dart';

abstract class PhaseRepository {
  Future<Either<Failure, List<PhaseEntity>>> getAllPhases();
  Future<Either<Failure, PhaseEntity>> getPhaseById(int id);
  Future<Either<Failure, PhaseEntity>> createPhase({
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  });
  Future<Either<Failure, PhaseEntity>> updatePhase({
    required int id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  });
  Future<Either<Failure, Unit>> deletePhase(int id);
}
