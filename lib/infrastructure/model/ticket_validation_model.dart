import '../../domain/entities/ticket_validation_entity.dart';

class ValidatedTicketModel extends ValidatedTicketEntity {
  const ValidatedTicketModel({
    required super.ticketId,
    required super.ticketNumber,
    required super.purchaseId,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required super.event,
    required super.category,
    required super.phase,
    required super.phaseStartDate,
    required super.used,
    super.usedAt,
  });

  factory ValidatedTicketModel.fromJson(Map<String, dynamic> json) {
    return ValidatedTicketModel(
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

  factory ValidatedTicketModel.fromEntity(ValidatedTicketEntity entity) {
    return ValidatedTicketModel(
      ticketId: entity.ticketId,
      ticketNumber: entity.ticketNumber,
      purchaseId: entity.purchaseId,
      customerName: entity.customerName,
      customerEmail: entity.customerEmail,
      customerPhone: entity.customerPhone,
      event: entity.event,
      category: entity.category,
      phase: entity.phase,
      phaseStartDate: entity.phaseStartDate,
      used: entity.used,
      usedAt: entity.usedAt,
    );
  }
}

class TicketValidationModel extends TicketValidationEntity {
  const TicketValidationModel({
    required super.status,
    required super.message,
    super.ticket,
  });

  factory TicketValidationModel.fromJson(Map<String, dynamic> json) {
    return TicketValidationModel(
      status: ValidationStatus.fromString(json['status'] as String),
      message: json['message'] as String,
      ticket: json['ticket'] != null 
          ? ValidatedTicketModel.fromJson(json['ticket'] as Map<String, dynamic>)
          : null,
    );
  }

  factory TicketValidationModel.fromEntity(TicketValidationEntity entity) {
    return TicketValidationModel(
      status: entity.status,
      message: entity.message,
      ticket: entity.ticket != null 
          ? ValidatedTicketModel.fromEntity(entity.ticket!)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status.value,
      'message': message,
      'ticket': ticket,
    };
  }

  TicketValidationEntity toEntity() {
    return TicketValidationEntity(
      status: status,
      message: message,
      ticket: ticket,
    );
  }

  @override
  TicketValidationModel copyWith({
    ValidationStatus? status,
    String? message,
    ValidatedTicketEntity? ticket,
  }) {
    return TicketValidationModel(
      status: status ?? this.status,
      message: message ?? this.message,
      ticket: ticket != null 
          ? (ticket is ValidatedTicketModel ? ticket : ValidatedTicketModel.fromEntity(ticket))
          : this.ticket,
    );
  }
}