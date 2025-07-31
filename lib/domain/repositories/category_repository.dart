import 'package:fpdart/fpdart.dart';
import '../entities/category_entity.dart';
import '../values_object/failure.dart';

abstract class CategoryRepository {
  // Create
  Future<Either<Failure, CategoryEntity>> createCategory({
    required String name,
    required String description,
    required int sortOrder,
  });

  // Read
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, CategoryEntity>> getCategoryById(int id);

  // Update
  Future<Either<Failure, CategoryEntity>> updateCategory({
    required int id,
    required String name,
    required String description,
    required int sortOrder,
  });

  // Delete
  Future<Either<Failure, Unit>> deleteCategory(int id);
}