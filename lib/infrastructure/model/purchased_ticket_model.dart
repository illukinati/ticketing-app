import '../../domain/entities/purchased_ticket_entity.dart';
import '../../domain/entities/individual_ticket_entity.dart';
import 'individual_ticket_model.dart';

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
  });

  factory PurchasedTicketModel.fromJson(Map<String, dynamic> json) {
    return PurchasedTicketModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      quantity: json['quantity'] as int,
      paymentStatus: PaymentStatus.fromString(json['payment_status'] as String),
      paidAt: json['paid_at'] != null 
          ? DateTime.parse(json['paid_at'] as String)
          : null,
      individualTickets: (json['individual_tickets'] as List<dynamic>)
          .map((ticket) => IndividualTicketModel.fromJson(ticket as Map<String, dynamic>))
          .toList(),
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
    );
  }
}