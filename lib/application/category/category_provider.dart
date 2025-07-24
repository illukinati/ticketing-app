import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../../infrastructure/data_source/category_remote_data_source.dart';
import '../../infrastructure/repositories_impl/category_repository_impl.dart';
import '../core/async_state.dart';
import 'category_notifier.dart';

// Base Providers
final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSourceImpl();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remoteDataSource = ref.watch(categoryRemoteDataSourceProvider);
  return CategoryRepositoryImpl(remoteDataSource: remoteDataSource);
});

// State Notifier Providers
final categoryListNotifierProvider = StateNotifierProvider<CategoryNotifier, AsyncState<List<CategoryEntity>>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryNotifier(repository);
});

final categoryDetailNotifierProvider = StateNotifierProvider<CategoryDetailNotifier, AsyncState<CategoryEntity>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryDetailNotifier(repository);
});

// Selected Category Provider (for detail view)
final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);