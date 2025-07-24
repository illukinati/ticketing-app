import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yono_bakrie_app/infrastructure/model/phase_model.dart';

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
  final Dio _dio = Dio();
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String _apiKey = dotenv.env['API_KEY'] ?? '';

  PhaseRemoteDataSourceImpl() {
    _dio.options.headers['Authorization'] = 'Bearer $_apiKey';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  @override
  Future<List<PhaseModel>> getAllPhases() async {
    try {
      final response = await _dio.get('$_baseUrl/phases');
      final List<dynamic> data = response.data;
      return data.map((json) => PhaseModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch phases: $e');
    }
  }

  @override
  Future<PhaseModel> getPhaseById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/phases/$id');
      return PhaseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch phase: $e');
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

      final response = await _dio.post('$_baseUrl/phases', data: data);
      return PhaseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create phase: $e');
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

      final response = await _dio.put('$_baseUrl/phases/$id', data: data);
      return PhaseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update phase: $e');
    }
  }

  @override
  Future<void> deletePhase(int id) async {
    try {
      await _dio.delete('$_baseUrl/phases/$id');
    } catch (e) {
      throw Exception('Failed to delete phase: $e');
    }
  }
}
