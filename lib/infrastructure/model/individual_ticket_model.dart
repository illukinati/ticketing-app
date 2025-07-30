import '../../domain/entities/individual_ticket_entity.dart';

class IndividualTicketModel extends IndividualTicketEntity {
  const IndividualTicketModel({
    required super.ticketId,
    required super.ticketNumber,
    super.purchaseId,
    required super.used,
    super.usedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory IndividualTicketModel.fromJson(Map<String, dynamic> json) {
    return IndividualTicketModel(
      ticketId: json['id'] as int? ?? json['ticket_id'] as int? ?? 0,
      ticketNumber: json['ticket_number'] as int? ?? 0,
      purchaseId: json['purchase_id'] as int?,
      used: json['used'] as bool? ?? false,
      usedAt: json['used_at'] != null
          ? DateTime.parse(json['used_at'] as String)
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  factory IndividualTicketModel.fromEntity(IndividualTicketEntity entity) {
    return IndividualTicketModel(
      ticketId: entity.ticketId,
      ticketNumber: entity.ticketNumber,
      purchaseId: entity.purchaseId,
      used: entity.used,
      usedAt: entity.usedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'ticket_number': ticketNumber,
      'purchase_id': purchaseId,
      'used': used,
      'used_at': usedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  IndividualTicketEntity toEntity() {
    return IndividualTicketEntity(
      ticketId: ticketId,
      ticketNumber: ticketNumber,
      purchaseId: purchaseId,
      used: used,
      usedAt: usedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  IndividualTicketModel copyWith({
    int? ticketId,
    int? ticketNumber,
    int? purchaseId,
    bool? used,
    DateTime? usedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IndividualTicketModel(
      ticketId: ticketId ?? this.ticketId,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      purchaseId: purchaseId ?? this.purchaseId,
      used: used ?? this.used,
      usedAt: usedAt ?? this.usedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
