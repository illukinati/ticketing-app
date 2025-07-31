import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/values_object/failure.dart';
import '../../domain/repositories/category_repository.dart';
import '../data_source/category_remote_data_source.dart';
import '../core/dio_error_handler.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CategoryEntity>> createCategory({
    required String name,
    required String description,
    required int sortOrder,
  }) async {
    try {
      final categoryModel = await remoteDataSource.createCategory(
        name: name,
        description: description,
        sortOrder: sortOrder,
      );
      return Right(categoryModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final categoryModels = await remoteDataSource.getAllCategories();
      final entities = categoryModels.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(int id) async {
    try {
      final categoryModel = await remoteDataSource.getCategoryById(id);
      return Right(categoryModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory({
    required int id,
    required String name,
    required String description,
    required int sortOrder,
  }) async {
    try {
      final categoryModel = await remoteDataSource.updateCategory(
        id: id,
        name: name,
        description: description,
        sortOrder: sortOrder,
      );
      return Right(categoryModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(int id) async {
    try {
      await remoteDataSource.deleteCategory(id);
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }
}