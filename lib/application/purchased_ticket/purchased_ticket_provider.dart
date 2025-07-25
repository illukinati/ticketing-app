import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/purchased_ticket_entity.dart';
import '../../domain/repositories/purchased_ticket_repository.dart';
import '../../infrastructure/data_source/purchased_ticket_remote_data_source.dart';
import '../../infrastructure/repositories_impl/purchased_ticket_repository_impl.dart';
import '../core/async_state.dart';
import 'purchased_ticket_notifier.dart';

// Base Providers
final purchasedTicketRemoteDataSourceProvider = Provider<PurchasedTicketRemoteDataSource>((ref) {
  return PurchasedTicketRemoteDataSourceImpl();
});

final purchasedTicketRepositoryProvider = Provider<PurchasedTicketRepository>((ref) {
  final remoteDataSource = ref.watch(purchasedTicketRemoteDataSourceProvider);
  return PurchasedTicketRepositoryImpl(remoteDataSource: remoteDataSource);
});

// State Notifier Providers
final purchasedTicketListNotifierProvider = StateNotifierProvider<PurchasedTicketNotifier, AsyncState<List<PurchasedTicketEntity>>>((ref) {
  final repository = ref.watch(purchasedTicketRepositoryProvider);
  return PurchasedTicketNotifier(repository);
});

final purchasedTicketByShowNotifierProvider = StateNotifierProvider<PurchasedTicketByShowNotifier, AsyncState<List<PurchasedTicketEntity>>>((ref) {
  final repository = ref.watch(purchasedTicketRepositoryProvider);
  return PurchasedTicketByShowNotifier(repository);
});

// Selected IDs Providers (for filtering)
final selectedPurchasedTicketIdProvider = StateProvider<int?>((ref) => null);