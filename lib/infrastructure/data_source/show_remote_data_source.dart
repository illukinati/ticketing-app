import 'package:dio/dio.dart';
import '../../domain/values_object/failure.dart';
import '../core/api_constants.dart';
import '../core/dio_error_handler.dart';
import '../model/show_model.dart';

abstract class ShowRemoteDataSource {
  Future<List<ShowModel>> getAllShows();
  Future<ShowModel> getShowById(int id);
  Future<ShowModel> createShow(String name);
  Future<ShowModel> updateShow(int id, String name);
  Future<void> deleteShow(int id);
}

class ShowRemoteDataSourceImpl implements ShowRemoteDataSource {
  final Dio dio;

  ShowRemoteDataSourceImpl({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              headers: ApiConstants.headers,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

  @override
  Future<List<ShowModel>> getAllShows() async {
    try {
      final response = await dio.get(ApiConstants.shows);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => ShowModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          message: 'Failed to load shows',
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
  Future<ShowModel> getShowById(int id) async {
    try {
      final response = await dio.get('${ApiConstants.shows}/$id');

      if (response.statusCode == 200) {
        return ShowModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to load show',
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
  Future<ShowModel> createShow(String name) async {
    try {
      final response = await dio.post(ApiConstants.shows, data: {'name': name});

      if (response.statusCode == 201) {
        return ShowModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to create show',
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
  Future<ShowModel> updateShow(int id, String name) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.shows}/$id',
        data: {'name': name},
      );

      if (response.statusCode == 200) {
        return ShowModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to update show',
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
  Future<void> deleteShow(int id) async {
    try {
      final response = await dio.delete('${ApiConstants.shows}/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerFailure(
          message: 'Failed to delete show',
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
