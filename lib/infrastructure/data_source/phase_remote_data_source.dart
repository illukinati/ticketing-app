import 'package:dio/dio.dart';
import '../../domain/values_object/failure.dart';
import '../core/api_constants.dart';
import '../core/dio_error_handler.dart';
import '../model/phase_model.dart';

abstract class PhaseRemoteDataSource {
  Future<List<PhaseModel>> getAllPhases();
  Future<PhaseModel> getPhaseById(int id);
  Future<PhaseModel> createPhase({
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  });
  Future<PhaseModel> updatePhase({
    required int id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  });
  Future<void> deletePhase(int id);
}

class PhaseRemoteDataSourceImpl implements PhaseRemoteDataSource {
  final Dio dio;

  PhaseRemoteDataSourceImpl({Dio? dio})
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
  Future<List<PhaseModel>> getAllPhases() async {
    try {
      final response = await dio.get(ApiConstants.phases);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => PhaseModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          message: 'Failed to load phases',
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
  Future<PhaseModel> getPhaseById(int id) async {
    try {
      final response = await dio.get('${ApiConstants.phases}/$id');

      if (response.statusCode == 200) {
        return PhaseModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to load phase',
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
  Future<PhaseModel> createPhase({
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'active': active,
      };

      final response = await dio.post(ApiConstants.phases, data: data);

      if (response.statusCode == 201) {
        return PhaseModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to create phase',
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
  Future<PhaseModel> updatePhase({
    required int id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool active,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'active': active,
      };

      final response = await dio.patch('${ApiConstants.phases}/$id', data: data);

      if (response.statusCode == 200) {
        return PhaseModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          message: 'Failed to update phase',
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
  Future<void> deletePhase(int id) async {
    try {
      final response = await dio.delete('${ApiConstants.phases}/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerFailure(
          message: 'Failed to delete phase',
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