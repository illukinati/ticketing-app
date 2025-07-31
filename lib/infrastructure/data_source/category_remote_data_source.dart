import 'package:dio/dio.dart';
import '../../domain/values_object/failure.dart';
import '../core/api_constants.dart';
import '../core/dio_error_handler.dart';
import '../model/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(int id);
  Future<CategoryModel> createCategory({
    required String name,
    required String description,
    required int sortOrder,
  });
  Future<CategoryModel> updateCategory({
    required int id,
    required String name,
    required String description,
    required int sortOrder,
  });
  Future<void> deleteCategory(int id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                headers: ApiConstants.headers,
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
              ),
            );

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await dio.get(ApiConstants.categories);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          message: 'Failed to load categories',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(int id) async {
    try {
      final response = await dio.get('${ApiConstants.categories}/$id');

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to load category',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }

  @override
  Future<CategoryModel> createCategory({
    required String name,
    required String description,
    required int sortOrder,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'sort_order': sortOrder,
      };

      final response = await dio.post(ApiConstants.categories, data: data);

      if (response.statusCode == 201) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to create category',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }

  @override
  Future<CategoryModel> updateCategory({
    required int id,
    required String name,
    required String description,
    required int sortOrder,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'sort_order': sortOrder,
      };

      final response = await dio.patch('${ApiConstants.categories}/$id', data: data);

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to update category',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      final response = await dio.delete('${ApiConstants.categories}/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerFailure(
          message: 'Failed to delete category',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e);
    } catch (e) {
      throw UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi');
    }
  }
}