import '../../domain/entities/purchased_ticket_entity.dart';
import '../../domain/entities/individual_ticket_entity.dart';
import '../../domain/entities/purchase_event_ticket_entity.dart';
import 'individual_ticket_model.dart';
import 'purchase_event_ticket_model.dart';

class PurchasedTicketModel extends PurchasedTicketEntity {
  const PurchasedTicketModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
    required super.quantity,
    required super.paymentStatus,
    super.paidAt,
    required super.individualTickets,
    super.eventTicket,
  });

  factory PurchasedTicketModel.fromJson(Map<String, dynamic> json) {
    return PurchasedTicketModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      paymentStatus: PaymentStatus.fromString(json['payment_status'] as String? ?? 'pending'),
      paidAt: json['paid_at'] != null 
          ? DateTime.parse(json['paid_at'] as String)
          : null,
      individualTickets: (json['individual_tickets'] as List<dynamic>? ?? [])
          .map((ticket) => IndividualTicketModel.fromJson(ticket as Map<String, dynamic>))
          .toList(),
      eventTicket: json['event_ticket'] != null
          ? PurchaseEventTicketModel.fromJson(json['event_ticket'] as Map<String, dynamic>)
          : null,
    );
  }

  factory PurchasedTicketModel.fromEntity(PurchasedTicketEntity entity) {
    return PurchasedTicketModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      quantity: entity.quantity,
      paymentStatus: entity.paymentStatus,
      paidAt: entity.paidAt,
      individualTickets: entity.individualTickets
          .map((ticket) => IndividualTicketModel.fromEntity(ticket))
          .toList(),
      eventTicket: entity.eventTicket != null
          ? PurchaseEventTicketModel.fromEntity(entity.eventTicket!)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'quantity': quantity,
      'payment_status': paymentStatus.value,
      'paid_at': paidAt?.toIso8601String(),
      'individual_tickets': individualTickets
          .map((ticket) => (ticket as IndividualTicketModel).toJson())
          .toList(),
      'event_ticket': eventTicket != null
          ? (eventTicket as PurchaseEventTicketModel).toJson()
          : null,
    };
  }

  PurchasedTicketEntity toEntity() {
    return PurchasedTicketEntity(
      id: id,
      name: name,
      phone: phone,
      email: email,
      quantity: quantity,
      paymentStatus: paymentStatus,
      paidAt: paidAt,
      individualTickets: individualTickets
          .map((ticket) => (ticket as IndividualTicketModel).toEntity())
          .toList(),
      eventTicket: eventTicket != null
          ? (eventTicket as PurchaseEventTicketModel).toEntity()
          : null,
    );
  }

  @override
  PurchasedTicketModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    int? quantity,
    PaymentStatus? paymentStatus,
    DateTime? paidAt,
    List<IndividualTicketEntity>? individualTickets,
    PurchaseEventTicketEntity? eventTicket,
  }) {
    return PurchasedTicketModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      quantity: quantity ?? this.quantity,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paidAt: paidAt ?? this.paidAt,
      individualTickets: individualTickets?.map((ticket) => 
        ticket is IndividualTicketModel 
          ? ticket 
          : IndividualTicketModel.fromEntity(ticket)
      ).toList() ?? this.individualTickets.map((ticket) => 
        ticket is IndividualTicketModel 
          ? ticket 
          : IndividualTicketModel.fromEntity(ticket)
      ).toList(),
      eventTicket: eventTicket != null
          ? (eventTicket is PurchaseEventTicketModel
              ? eventTicket
              : PurchaseEventTicketModel.fromEntity(eventTicket))
          : this.eventTicket != null
              ? (this.eventTicket is PurchaseEventTicketModel
                  ? this.eventTicket
                  : PurchaseEventTicketModel.fromEntity(this.eventTicket!))
              : null,
    );
  }
}