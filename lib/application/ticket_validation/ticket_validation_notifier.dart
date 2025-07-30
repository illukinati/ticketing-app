import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/ticket_validation_entity.dart';
import '../../domain/repositories/ticket_validation_repository.dart';
import '../../domain/values_object/failure.dart';
import '../core/async_state.dart';

class TicketValidationNotifier
    extends StateNotifier<AsyncState<TicketValidationEntity?>> {
  final TicketValidationRepository _repository;

  TicketValidationNotifier(this._repository)
    : super(const AsyncState.initial());

  Future<Either<Failure, TicketValidationEntity>> validateTicket({
    required String token,
  }) async {
    state = const AsyncState.loading();

    if (token.trim().isEmpty) {
      final failure = const ValidationFailure(
        message: 'Token tidak boleh kosong',
      );
      state = const AsyncState.data(null);
      return Left(failure);
    }

    final result = await _repository.validateTicket(token: token.trim());

    return result.fold(
      (failure) {
        state = const AsyncState.data(null);
        return Left(failure);
      },
      (validation) {
        state = AsyncState.data(validation);
        return Right(validation);
      },
    );
  }

  void resetState() {
    state = const AsyncState.initial();
  }

  TicketValidationEntity? get currentValidation =>
      state.maybeWhen(data: (validation) => validation, orElse: () => null);

  bool get isValidating =>
      state.maybeWhen(loading: () => true, orElse: () => false);
}
