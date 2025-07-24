import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event_ticket_entity.dart';
import '../../domain/repositories/event_ticket_repository.dart';
import '../../infrastructure/data_source/event_ticket_remote_data_source.dart';
import '../../infrastructure/repositories_impl/event_ticket_repository_impl.dart';
import '../core/async_state.dart';
import 'event_ticket_notifier.dart';

// Base Providers
final eventTicketRemoteDataSourceProvider = Provider<EventTicketRemoteDataSource>((ref) {
  return EventTicketRemoteDataSourceImpl();
});

final eventTicketRepositoryProvider = Provider<EventTicketRepository>((ref) {
  final remoteDataSource = ref.watch(eventTicketRemoteDataSourceProvider);
  return EventTicketRepositoryImpl(remoteDataSource: remoteDataSource);
});

// State Notifier Providers
final eventTicketListNotifierProvider = StateNotifierProvider<EventTicketNotifier, AsyncState<List<EventTicketEntity>>>((ref) {
  final repository = ref.watch(eventTicketRepositoryProvider);
  return EventTicketNotifier(repository);
});

final eventTicketByCategoryNotifierProvider = StateNotifierProvider<EventTicketByCategoryNotifier, AsyncState<List<EventTicketEntity>>>((ref) {
  final repository = ref.watch(eventTicketRepositoryProvider);
  return EventTicketByCategoryNotifier(repository);
});

final eventTicketByShowNotifierProvider = StateNotifierProvider<EventTicketByShowNotifier, AsyncState<List<EventTicketEntity>>>((ref) {
  final repository = ref.watch(eventTicketRepositoryProvider);
  return EventTicketByShowNotifier(repository);
});

// Selected IDs Providers (for filtering)
final selectedShowIdProvider = StateProvider<int?>((ref) => null);
final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);
final selectedEventTicketIdProvider = StateProvider<int?>((ref) => null);