import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/phase_entity.dart';
import '../../domain/values_object/failure.dart';
import '../../domain/repositories/phase_repository.dart';
import '../core/async_state.dart';

class PhaseNotifier extends StateNotifier<AsyncState<List<PhaseEntity>>> {
  final PhaseRepository _repository;

  PhaseNotifier(this._repository) : super(const AsyncState.initial());

  Future<void> loadPhases() async {
    state = const AsyncState.loading();

    final result = await _repository.getAllPhases();

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (phases) => AsyncState.data(phases),
    );
  }

  Future<Either<Failure, PhaseEntity>> createPhase({
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  }) async {
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

    final result = await _repository.createPhase(
      name: name.trim(),
      description: description.trim(),
      startDate: startDate,
      endDate: endDate,
      active: active,
    );

    // Refresh the list if creation was successful
    result.fold((_) => null, (_) => loadPhases());

    return result;
  }

  Future<Either<Failure, PhaseEntity>> updatePhase({
    required int id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  }) async {
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

    final result = await _repository.updatePhase(
      id: id,
      name: name.trim(),
      description: description.trim(),
      startDate: startDate,
      endDate: endDate,
      active: active,
    );

    // Refresh the list if update was successful
    result.fold((_) => null, (_) => loadPhases());

    return result;
  }

  Future<Either<Failure, Unit>> deletePhase(int id) async {
    final result = await _repository.deletePhase(id);

    // Refresh the list if deletion was successful
    result.fold((_) => null, (_) => loadPhases());

    return result;
  }

  void refresh() {
    loadPhases();
  }
}

// Separate notifier for single phase detail if needed
class PhaseDetailNotifier extends StateNotifier<AsyncState<PhaseEntity>> {
  final PhaseRepository _repository;

  PhaseDetailNotifier(this._repository) : super(const AsyncState.initial());

  Future<void> loadPhase(int id) async {
    state = const AsyncState.loading();

    final result = await _repository.getPhaseById(id);

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (phase) => AsyncState.data(phase),
    );
  }
}