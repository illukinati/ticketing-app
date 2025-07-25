import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/purchased_ticket_entity.dart';
import '../../domain/repositories/purchased_ticket_repository.dart';
import '../core/async_state.dart';

class PurchasedTicketNotifier
    extends StateNotifier<AsyncState<List<PurchasedTicketEntity>>> {
  final PurchasedTicketRepository _repository;

  PurchasedTicketNotifier(this._repository) : super(const AsyncState.initial());

  Future<void> loadAllPurchasedTickets() async {
    state = const AsyncState.loading();

    final result = await _repository.getAllPurchasedTickets();

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (tickets) => AsyncState.data(tickets),
    );
  }

  Future<void> loadPurchasedTicketsByShow(int showId) async {
    state = const AsyncState.loading();

    final result = await _repository.getPurchasedTicketsByShowId(showId);

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (tickets) => AsyncState.data(tickets),
    );
  }

  void refresh() {
    // For now, we'll reload all tickets - this can be improved with state tracking
    loadAllPurchasedTickets();
  }
}

// Separate notifier for show-specific purchased tickets
class PurchasedTicketByShowNotifier
    extends StateNotifier<AsyncState<List<PurchasedTicketEntity>>> {
  final PurchasedTicketRepository _repository;

  PurchasedTicketByShowNotifier(this._repository)
    : super(const AsyncState.initial());

  Future<void> loadPurchasedTicketsByShow(int showId) async {
    state = const AsyncState.loading();

    final result = await _repository.getPurchasedTicketsByShowId(showId);

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (tickets) => AsyncState.data(tickets),
    );
  }

  void refresh(int showId) {
    loadPurchasedTicketsByShow(showId);
  }
}
