import '../values_object/date.dart';

class ShowEntity {
  final int id;
  final String name;
  final Date createdAt;
  final Date updatedAt;

  const ShowEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;

  @override
  String toString() {
    return 'ShowEntity{id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}