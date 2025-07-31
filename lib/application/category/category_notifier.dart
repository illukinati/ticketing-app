import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/values_object/failure.dart';
import '../../domain/repositories/category_repository.dart';
import '../core/async_state.dart';

class CategoryNotifier extends StateNotifier<AsyncState<List<CategoryEntity>>> {
  final CategoryRepository _repository;

  CategoryNotifier(this._repository) : super(const AsyncState.initial());

  Future<void> loadCategories() async {
    state = const AsyncState.loading();

    final result = await _repository.getAllCategories();

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (categories) => AsyncState.data(categories),
    );
  }

  Future<Either<Failure, CategoryEntity>> createCategory({
    required String name,
    required String description,
    required int sortOrder,
  }) async {
    if (name.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Category name cannot be empty'),
      );
    }

    if (description.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Category description cannot be empty'),
      );
    }

    if (sortOrder < 0) {
      return const Left(
        ValidationFailure(message: 'Sort order must be a positive number'),
      );
    }

    final result = await _repository.createCategory(
      name: name.trim(),
      description: description.trim(),
      sortOrder: sortOrder,
    );

    // Refresh the list if creation was successful
    result.fold((_) => null, (_) => loadCategories());

    return result;
  }

  Future<Either<Failure, CategoryEntity>> updateCategory({
    required int id,
    required String name,
    required String description,
    required int sortOrder,
  }) async {
    if (name.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Category name cannot be empty'),
      );
    }

    if (description.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Category description cannot be empty'),
      );
    }

    if (sortOrder < 0) {
      return const Left(
        ValidationFailure(message: 'Sort order must be a positive number'),
      );
    }

    final result = await _repository.updateCategory(
      id: id,
      name: name.trim(),
      description: description.trim(),
      sortOrder: sortOrder,
    );

    // Refresh the list if update was successful
    result.fold((_) => null, (_) => loadCategories());

    return result;
  }

  Future<Either<Failure, Unit>> deleteCategory(int id) async {
    final result = await _repository.deleteCategory(id);

    // Refresh the list if deletion was successful
    result.fold((_) => null, (_) => loadCategories());

    return result;
  }

  void refresh() {
    loadCategories();
  }
}

// Separate notifier for single category detail if needed
class CategoryDetailNotifier extends StateNotifier<AsyncState<CategoryEntity>> {
  final CategoryRepository _repository;

  CategoryDetailNotifier(this._repository) : super(const AsyncState.initial());

  Future<void> loadCategory(int id) async {
    state = const AsyncState.loading();

    final result = await _repository.getCategoryById(id);

    state = result.fold(
      (failure) => AsyncState.error(failure),
      (category) => AsyncState.data(category),
    );
  }
}