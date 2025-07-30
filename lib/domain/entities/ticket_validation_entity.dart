enum ValidationStatus {
  valid('valid'),
  alreadyUsed('already_used'),
  invalid('invalid');

  final String value;
  const ValidationStatus(this.value);

  static ValidationStatus fromString(String value) {
    return ValidationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ValidationStatus.invalid,
    );
  }
}

class ValidatedTicketEntity {
  final int ticketId;
  final int ticketNumber;
  final int purchaseId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String event;
  final String category;
  final String phase;
  final DateTime phaseStartDate;
  final bool used;
  final DateTime? usedAt;

  const ValidatedTicketEntity({
    required this.ticketId,
    required this.ticketNumber,
    required this.purchaseId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.event,
    required this.category,
    required this.phase,
    required this.phaseStartDate,
    required this.used,
    this.usedAt,
  });

  factory ValidatedTicketEntity.fromJson(Map<String, dynamic> json) {
    return ValidatedTicketEntity(
      ticketId: json['ticket_id'] as int,
      ticketNumber: json['ticket_number'] as int,
      purchaseId: json['purchase_id'] as int,
      customerName: json['customer_name'] as String,
      customerEmail: json['customer_email'] as String,
      customerPhone: json['customer_phone'] as String,
      event: json['event'] as String,
      category: json['category'] as String,
      phase: json['phase'] as String,
      phaseStartDate: DateTime.parse(json['phase_start_date'] as String),
      used: json['used'] as bool,
      usedAt: json['used_at'] != null 
          ? DateTime.parse(json['used_at'] as String)
          : null,
    );
  }
}

class TicketValidationEntity {
  final ValidationStatus status;
  final String message;
  final ValidatedTicketEntity? ticket;

  const TicketValidationEntity({
    required this.status,
    required this.message,
    this.ticket,
  });

  factory TicketValidationEntity.fromJson(Map<String, dynamic> json) {
    return TicketValidationEntity(
      status: ValidationStatus.fromString(json['status'] as String),
      message: json['message'] as String,
      ticket: json['ticket'] != null 
          ? ValidatedTicketEntity.fromJson(json['ticket'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.value,
      'message': message,
      'ticket': ticket,
    };
  }

  bool get isValid => status == ValidationStatus.valid;
  bool get isAlreadyUsed => status == ValidationStatus.alreadyUsed;
  bool get isInvalid => status == ValidationStatus.invalid;

  TicketValidationEntity copyWith({
    ValidationStatus? status,
    String? message,
    ValidatedTicketEntity? ticket,
  }) {
    return TicketValidationEntity(
      status: status ?? this.status,
      message: message ?? this.message,
      ticket: ticket ?? this.ticket,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TicketValidationEntity && 
           other.status == status && 
           other.message == message &&
           other.ticket == ticket;
  }

  @override
  int get hashCode => Object.hash(status, message, ticket);

  @override
  String toString() {
    return 'TicketValidationEntity(status: $status, message: $message, ticket: $ticket)';
  }
}