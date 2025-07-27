import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/event_ticket_entity.dart';
import '../../domain/values_object/failure.dart';
import '../../domain/repositories/event_ticket_repository.dart';
import '../core/async_state.dart';

class EventTicketNotifier
    extends StateNotifier<AsyncState<List<EventTicketEntity>>> {
  final EventTicketRepository _repository;

  EventTicketNotifier(this._repository) : super(const AsyncState.initial());

  Future<void> loadEventTicketsByShow(int showId) async {
    state = const AsyncState.loading();

    final result = await _repository.getEventTicketsByShowId(showId);

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (tickets) => AsyncState.data(tickets),
    );
  }

  Future<Either<Failure, EventTicketEntity>> createEventTicket({
    required int qty,
    required double price,
    required int showId,
    required int phaseId,
    required int categoryId,
    required TicketStatus status,
    required int originalQty,
    int movedQty = 0,
  }) async {
    // Validation
    if (qty < 0) {
      return const Left(
        ValidationFailure(message: 'Quantity must be a positive number'),
      );
    }

    if (price <= 0) {
      return const Left(
        ValidationFailure(message: 'Price must be greater than zero'),
      );
    }

    if (originalQty < 0) {
      return const Left(
        ValidationFailure(
          message: 'Original quantity must be a positive number',
        ),
      );
    }

    if (qty > originalQty) {
      return const Left(
        ValidationFailure(message: 'Quantity cannot exceed original quantity'),
      );
    }

    if (movedQty < 0) {
      return const Left(
        ValidationFailure(message: 'Moved quantity must be a positive number'),
      );
    }

    final result = await _repository.createEventTicket(
      qty: qty,
      price: price,
      showId: showId,
      phaseId: phaseId,
      categoryId: categoryId,
      status: status,
      originalQty: originalQty,
      movedQty: movedQty,
    );

    // Refresh the list if creation was successful
    result.fold((_) => null, (_) => loadEventTicketsByShow(showId));

    return result;
  }

  Future<Either<Failure, EventTicketEntity>> updateEventTicket({
    required int id,
    required int qty,
    required double price,
    required int showId,
    required int phaseId,
    required int categoryId,
    required TicketStatus status,
    required int originalQty,
    int movedQty = 0,
  }) async {
    // Validation
    if (qty < 0) {
      return const Left(
        ValidationFailure(message: 'Quantity must be a positive number'),
      );
    }

    if (price <= 0) {
      return const Left(
        ValidationFailure(message: 'Price must be greater than zero'),
      );
    }

    if (originalQty < 0) {
      return const Left(
        ValidationFailure(
          message: 'Original quantity must be a positive number',
        ),
      );
    }

    if (qty > originalQty) {
      return const Left(
        ValidationFailure(message: 'Quantity cannot exceed original quantity'),
      );
    }

    if (movedQty < 0) {
      return const Left(
        ValidationFailure(message: 'Moved quantity must be a positive number'),
      );
    }

    final result = await _repository.updateEventTicket(
      id: id,
      qty: qty,
      price: price,
      showId: showId,
      phaseId: phaseId,
      categoryId: categoryId,
      status: status,
      originalQty: originalQty,
      movedQty: movedQty,
    );

    // Refresh the list if update was successful
    result.fold((_) => null, (_) => loadEventTicketsByShow(showId));

    return result;
  }

  Future<Either<Failure, Unit>> deleteEventTicket(int id, int showId) async {
    final result = await _repository.deleteEventTicket(id);

    // Refresh the list if deletion was successful
    result.fold((_) => null, (_) => loadEventTicketsByShow(showId));

    return result;
  }

  Future<Either<Failure, EventTicketEntity>> updateEventTicketStatus({
    required int id,
    required TicketStatus status,
    required int showId,
  }) async {
    final result = await _repository.updateTicketStatus(id: id, status: status);

    // Refresh the list if status update was successful
    result.fold((_) => null, (_) => loadEventTicketsByShow(showId));

    return result;
  }

  void refresh(int showId) {
    loadEventTicketsByShow(showId);
  }
}

// Separate notifier for category-specific tickets
class EventTicketByCategoryNotifier
    extends StateNotifier<AsyncState<List<EventTicketEntity>>> {
  final EventTicketRepository _repository;

  EventTicketByCategoryNotifier(this._repository)
    : super(const AsyncState.initial());

  Future<void> loadEventTicketsByCategory(int categoryId) async {
    state = const AsyncState.loading();

    final result = await _repository.getEventTicketsByCategoryId(categoryId);

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (tickets) => AsyncState.data(tickets),
    );
  }

  void refresh(int categoryId) {
    loadEventTicketsByCategory(categoryId);
  }
}

// Separate notifier for show-specific tickets
class EventTicketByShowNotifier
    extends StateNotifier<AsyncState<List<EventTicketEntity>>> {
  final EventTicketRepository _repository;

  EventTicketByShowNotifier(this._repository)
    : super(const AsyncState.initial());

  Future<void> loadEventTicketsByShow(int showId) async {
    state = const AsyncState.loading();

    final result = await _repository.getEventTicketsByShowId(showId);

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (tickets) => AsyncState.data(tickets),
    );
  }

  void refresh(int showId) {
    loadEventTicketsByShow(showId);
  }
}
