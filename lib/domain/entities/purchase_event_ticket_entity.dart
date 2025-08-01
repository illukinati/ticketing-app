class PurchaseEventTicketEntity {
  final int id;
  final String category;
  final String phase;
  final double price;

  const PurchaseEventTicketEntity({
    required this.id,
    required this.category,
    required this.phase,
    required this.price,
  });

  factory PurchaseEventTicketEntity.fromJson(Map<String, dynamic> json) {
    return PurchaseEventTicketEntity(
      id: json['id'] as int,
      category: json['category'] as String,
      phase: json['phase'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'phase': phase,
      'price': price,
    };
  }

  PurchaseEventTicketEntity copyWith({
    int? id,
    String? category,
    String? phase,
    double? price,
  }) {
    return PurchaseEventTicketEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      phase: phase ?? this.phase,
      price: price ?? this.price,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PurchaseEventTicketEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PurchaseEventTicketEntity(id: $id, category: $category, phase: $phase, price: $price)';
  }
}