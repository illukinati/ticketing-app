import 'package:yono_bakrie_app/domain/values_object/date.dart';

class PhaseEntity {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool active;
  final Date createdAt;
  final Date updatedAt;
  final bool processed;

  const PhaseEntity({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhaseEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.active == active &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.processed == processed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        active.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        processed.hashCode;
  }

  @override
  String toString() {
    return 'PhaseEntity(id: $id, name: $name, description: $description, startDate: $startDate, endDate: $endDate, active: $active, createdAt: $createdAt, updatedAt: $updatedAt, processed: $processed)';
  }
}
