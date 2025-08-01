import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/purchased_ticket_entity.dart';
import '../../domain/repositories/purchased_ticket_repository.dart';
import '../../domain/values_object/failure.dart';
import '../core/async_state.dart';

// Notifier for show-specific purchased tickets
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

  Future<Either<Failure, void>> resendEmail(int purchaseId) async {
    return await _repository.resendEmail(purchaseId);
  }
}
