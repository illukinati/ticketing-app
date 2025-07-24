import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/show_entity.dart';
import '../../domain/repositories/show_repository.dart';
import '../../infrastructure/data_source/show_remote_data_source.dart';
import '../../infrastructure/repositories_impl/show_repository_impl.dart';
import '../core/async_state.dart';
import 'show_notifier.dart';

// Base Providers
final showRemoteDataSourceProvider = Provider<ShowRemoteDataSource>((ref) {
  return ShowRemoteDataSourceImpl();
});

final showRepositoryProvider = Provider<ShowRepository>((ref) {
  final remoteDataSource = ref.watch(showRemoteDataSourceProvider);
  return ShowRepositoryImpl(remoteDataSource: remoteDataSource);
});

// State Notifier Providers
final showListNotifierProvider = StateNotifierProvider<ShowNotifier, AsyncState<List<ShowEntity>>>((ref) {
  final repository = ref.watch(showRepositoryProvider);
  return ShowNotifier(repository);
});

final showDetailNotifierProvider = StateNotifierProvider<ShowDetailNotifier, AsyncState<ShowEntity>>((ref) {
  final repository = ref.watch(showRepositoryProvider);
  return ShowDetailNotifier(repository);
});

// Selected Show Provider (for detail view)
final selectedShowIdProvider = StateProvider<int?>((ref) => null);