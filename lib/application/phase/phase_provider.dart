import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/phase_entity.dart';
import '../../domain/repositories/phase_repository.dart';
import '../../infrastructure/data_source/phase_remote_data_source.dart';
import '../../infrastructure/repositories_impl/phase_repository_impl.dart';
import '../core/async_state.dart';
import 'phase_notifier.dart';

// Base Providers
final phaseRemoteDataSourceProvider = Provider<PhaseRemoteDataSource>((ref) {
  return PhaseRemoteDataSourceImpl();
});

final phaseRepositoryProvider = Provider<PhaseRepository>((ref) {
  final remoteDataSource = ref.watch(phaseRemoteDataSourceProvider);
  return PhaseRepositoryImpl(remoteDataSource: remoteDataSource);
});

// State Notifier Providers
final phaseListNotifierProvider = StateNotifierProvider<PhaseNotifier, AsyncState<List<PhaseEntity>>>((ref) {
  final repository = ref.watch(phaseRepositoryProvider);
  return PhaseNotifier(repository);
});

final phaseDetailNotifierProvider = StateNotifierProvider<PhaseDetailNotifier, AsyncState<PhaseEntity>>((ref) {
  final repository = ref.watch(phaseRepositoryProvider);
  return PhaseDetailNotifier(repository);
});

// Selected Phase Provider (for detail view)
final selectedPhaseIdProvider = StateProvider<int?>((ref) => null);