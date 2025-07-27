import '../../domain/entities/show_entity.dart';
import '../../domain/values_object/date.dart';

class ShowModel {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final String? showTime;

  ShowModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.showTime,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      showTime: json['show_time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (showTime != null) 'show_time': showTime,
    };
  }

  ShowEntity toEntity() {
    return ShowEntity(
      id: id,
      name: name,
      createdAt: Date.fromString(createdAt),
      updatedAt: Date.fromString(updatedAt),
      showTime: showTime != null ? DateTime.parse(showTime!) : null,
    );
  }

  factory ShowModel.fromEntity(ShowEntity entity) {
    return ShowModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      showTime: entity.showTime?.toIso8601String(),
    );
  }
}