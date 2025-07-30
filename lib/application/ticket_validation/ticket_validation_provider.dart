import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ticket_validation_entity.dart';
import '../../domain/repositories/ticket_validation_repository.dart';
import '../../infrastructure/repositories_impl/ticket_validation_repository_impl.dart';
import '../../infrastructure/data_source/ticket_validation_remote_data_source.dart';
import '../core/async_state.dart';
import 'ticket_validation_notifier.dart';

// Data source provider
final ticketValidationRemoteDataSourceProvider = Provider<TicketValidationRemoteDataSource>((ref) {
  return TicketValidationRemoteDataSourceImpl();
});

// Repository provider
final ticketValidationRepositoryProvider = Provider<TicketValidationRepository>((ref) {
  return TicketValidationRepositoryImpl(
    remoteDataSource: ref.read(ticketValidationRemoteDataSourceProvider),
  );
});

// Ticket validation notifier provider
final ticketValidationProvider = StateNotifierProvider<TicketValidationNotifier, AsyncState<TicketValidationEntity?>>((ref) {
  return TicketValidationNotifier(ref.read(ticketValidationRepositoryProvider));
});