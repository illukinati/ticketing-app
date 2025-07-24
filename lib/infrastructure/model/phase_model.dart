import '../../domain/entities/phase_entity.dart';
import '../../domain/values_object/date.dart';

class PhaseModel {
  final int id;
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final bool active;
  final String createdAt;
  final String updatedAt;
  final bool processed;

  PhaseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.processed,
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      active: json['active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      processed: json['processed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'active': active,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'processed': processed,
    };
  }

  PhaseEntity toEntity() {
    return PhaseEntity(
      id: id,
      name: name,
      description: description,
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      active: active,
      createdAt: Date.fromString(createdAt),
      updatedAt: Date.fromString(updatedAt),
      processed: processed,
    );
  }

  factory PhaseModel.fromEntity(PhaseEntity entity) {
    return PhaseModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      startDate: entity.startDate.toIso8601String(),
      endDate: entity.endDate.toIso8601String(),
      active: entity.active,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      processed: entity.processed,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'active': active,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'active': active,
    };
  }
}