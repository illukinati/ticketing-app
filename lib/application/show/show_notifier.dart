import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/show_entity.dart';
import '../../domain/failures/failure.dart';
import '../../domain/repositories/show_repository.dart';
import '../core/async_state.dart';

class ShowNotifier extends StateNotifier<AsyncState<List<ShowEntity>>> {
  final ShowRepository _repository;

  ShowNotifier(this._repository) : super(const AsyncState.initial());

  Future<void> loadShows() async {
    state = const AsyncState.loading();
    
    final result = await _repository.getAllShows();
    
    state = result.fold(
      (failure) => AsyncState.error(failure),
      (shows) => AsyncState.data(shows),
    );
  }

  Future<Either<Failure, ShowEntity>> createShow(String name) async {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Show name cannot be empty'));
    }

    final result = await _repository.createShow(name.trim());
    
    // Refresh the list if creation was successful
    result.fold(
      (_) => null,
      (_) => loadShows(),
    );
    
    return result;
  }

  Future<Either<Failure, ShowEntity>> updateShow(int id, String name) async {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Show name cannot be empty'));
    }

    final result = await _repository.updateShow(id, name.trim());
    
    // Refresh the list if update was successful
    result.fold(
      (_) => null,
      (_) => loadShows(),
    );
    
    return result;
  }

  Future<Either<Failure, Unit>> deleteShow(int id) async {
    final result = await _repository.deleteShow(id);
    
    // Refresh the list if deletion was successful
    result.fold(
      (_) => null,
      (_) => loadShows(),
    );
    
    return result;
  }

  void refresh() {
    loadShows();
  }
}

// Separate notifier for single show detail if needed
class ShowDetailNotifier extends StateNotifier<AsyncState<ShowEntity>> {
  final ShowRepository _repository;

  ShowDetailNotifier(this._repository) : super(const AsyncState.initial());

  Future<void> loadShow(int id) async {
    state = const AsyncState.loading();
    
    final result = await _repository.getShowById(id);
    
    state = result.fold(
      (failure) => AsyncState.error(failure),
      (show) => AsyncState.data(show),
    );
  }
}