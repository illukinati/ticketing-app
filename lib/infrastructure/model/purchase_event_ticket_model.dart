import '../../domain/entities/purchase_event_ticket_entity.dart';

class PurchaseEventTicketModel extends PurchaseEventTicketEntity {
  const PurchaseEventTicketModel({
    required super.id,
    required super.category,
    required super.phase,
    required super.price,
  });

  factory PurchaseEventTicketModel.fromJson(Map<String, dynamic> json) {
    return PurchaseEventTicketModel(
      id: json['id'] as int,
      category: json['category'] as String? ?? '',
      phase: json['phase'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory PurchaseEventTicketModel.fromEntity(PurchaseEventTicketEntity entity) {
    return PurchaseEventTicketModel(
      id: entity.id,
      category: entity.category,
      phase: entity.phase,
      price: entity.price,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'phase': phase,
      'price': price,
    };
  }

  PurchaseEventTicketEntity toEntity() {
    return PurchaseEventTicketEntity(
      id: id,
      category: category,
      phase: phase,
      price: price,
    );
  }

  @override
  PurchaseEventTicketModel copyWith({
    int? id,
    String? category,
    String? phase,
    double? price,
  }) {
    return PurchaseEventTicketModel(
      id: id ?? this.id,
      category: category ?? this.category,
      phase: phase ?? this.phase,
      price: price ?? this.price,
    );
  }
}