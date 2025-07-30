import '../../domain/entities/individual_ticket_entity.dart';
import '../../domain/entities/ticket_validation_entity.dart';
import 'individual_ticket_model.dart';

class TicketValidationModel extends TicketValidationEntity {
  const TicketValidationModel({
    required super.valid,
    super.ticket,
  });

  factory TicketValidationModel.fromJson(Map<String, dynamic> json) {
    return TicketValidationModel(
      valid: json['valid'] as bool? ?? false,
      ticket: json['ticket'] != null 
          ? IndividualTicketModel.fromJson(json['ticket'] as Map<String, dynamic>)
          : null,
    );
  }

  factory TicketValidationModel.fromEntity(TicketValidationEntity entity) {
    return TicketValidationModel(
      valid: entity.valid,
      ticket: entity.ticket != null 
          ? IndividualTicketModel.fromEntity(entity.ticket!)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
      'ticket': ticket != null && ticket is IndividualTicketModel
          ? (ticket as IndividualTicketModel).toJson()
          : ticket?.toJson(),
    };
  }

  TicketValidationEntity toEntity() {
    return TicketValidationEntity(
      valid: valid,
      ticket: ticket != null && ticket is IndividualTicketModel
          ? (ticket as IndividualTicketModel).toEntity()
          : ticket,
    );
  }

  @override
  TicketValidationModel copyWith({
    bool? valid,
    IndividualTicketEntity? ticket,
  }) {
    return TicketValidationModel(
      valid: valid ?? this.valid,
      ticket: ticket != null 
          ? (ticket is IndividualTicketModel ? ticket : IndividualTicketModel.fromEntity(ticket))
          : this.ticket,
    );
  }
}