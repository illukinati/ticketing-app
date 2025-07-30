import 'individual_ticket_entity.dart';

class TicketValidationEntity {
  final bool valid;
  final IndividualTicketEntity? ticket;

  const TicketValidationEntity({
    required this.valid,
    this.ticket,
  });

  factory TicketValidationEntity.fromJson(Map<String, dynamic> json) {
    return TicketValidationEntity(
      valid: json['valid'] as bool,
      ticket: json['ticket'] != null 
          ? IndividualTicketEntity.fromJson(json['ticket'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
      'ticket': ticket?.toJson(),
    };
  }

  bool get isValid => valid;
  bool get isInvalid => !valid;

  TicketValidationEntity copyWith({
    bool? valid,
    IndividualTicketEntity? ticket,
  }) {
    return TicketValidationEntity(
      valid: valid ?? this.valid,
      ticket: ticket ?? this.ticket,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TicketValidationEntity && 
           other.valid == valid && 
           other.ticket == ticket;
  }

  @override
  int get hashCode => Object.hash(valid, ticket);

  @override
  String toString() {
    return 'TicketValidationEntity(valid: $valid, ticket: $ticket)';
  }
}