import 'package:dio/dio.dart';
import '../core/api_constants.dart';
import '../model/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(int id);
  Future<CategoryModel> createCategory({
    required String name,
    required String description,
    required String color,
    required int sortOrder,
  });
  Future<CategoryModel> updateCategory({
    required int id,
    required String name,
    required String description,
    required String color,
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
        throw Exception('Failed to load categories');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(int id) async {
    try {
      final response = await dio.get('${ApiConstants.categories}/$id');

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load category');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<CategoryModel> createCategory({
    required String name,
    required String description,
    required String color,
    required int sortOrder,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'color': color,
        'sort_order': sortOrder,
      };

      final response = await dio.post(ApiConstants.categories, data: data);

      if (response.statusCode == 201) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create category');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<CategoryModel> updateCategory({
    required int id,
    required String name,
    required String description,
    required String color,
    required int sortOrder,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'color': color,
        'sort_order': sortOrder,
      };

      final response = await dio.patch('${ApiConstants.categories}/$id', data: data);

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update category');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      final response = await dio.delete('${ApiConstants.categories}/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete category');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}