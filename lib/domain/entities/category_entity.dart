import '../values_object/date.dart';

class CategoryEntity {
  final int id;
  final String name;
  final String description;
  final String color;
  final int sortOrder;
  final Date createdAt;
  final Date updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          sortOrder == other.sortOrder &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      color.hashCode ^
      sortOrder.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'CategoryEntity{id: $id, name: $name, description: $description, color: $color, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}