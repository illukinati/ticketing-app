class IndividualTicketEntity {
  final int ticketId;
  final int ticketNumber;
  final bool used;
  final DateTime? usedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const IndividualTicketEntity({
    required this.ticketId,
    required this.ticketNumber,
    required this.used,
    this.usedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IndividualTicketEntity.fromJson(Map<String, dynamic> json) {
    return IndividualTicketEntity(
      ticketId: json['ticket_id'] as int,
      ticketNumber: json['ticket_number'] as int,
      used: json['used'] as bool,
      usedAt: json['used_at'] != null 
          ? DateTime.parse(json['used_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'ticket_number': ticketNumber,
      'used': used,
      'used_at': usedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isUsed => used;
  bool get isUnused => !used;

  IndividualTicketEntity copyWith({
    int? ticketId,
    int? ticketNumber,
    bool? used,
    DateTime? usedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IndividualTicketEntity(
      ticketId: ticketId ?? this.ticketId,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      used: used ?? this.used,
      usedAt: usedAt ?? this.usedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IndividualTicketEntity && other.ticketId == ticketId;
  }

  @override
  int get hashCode => ticketId.hashCode;

  @override
  String toString() {
    return 'IndividualTicketEntity(ticketId: $ticketId, ticketNumber: $ticketNumber, used: $used)';
  }
}