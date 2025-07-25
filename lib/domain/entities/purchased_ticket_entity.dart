import 'individual_ticket_entity.dart';

enum PaymentStatus {
  pending('pending'),
  paid('paid'),
  failed('failed'),
  cancelled('cancelled');

  const PaymentStatus(this.value);
  final String value;

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}

class PurchasedTicketEntity {
  final int id;
  final String name;
  final String phone;
  final String email;
  final int quantity;
  final PaymentStatus paymentStatus;
  final DateTime? paidAt;
  final List<IndividualTicketEntity> individualTickets;

  const PurchasedTicketEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.quantity,
    required this.paymentStatus,
    this.paidAt,
    required this.individualTickets,
  });

  factory PurchasedTicketEntity.fromJson(Map<String, dynamic> json) {
    return PurchasedTicketEntity(
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
          .map((ticket) => IndividualTicketEntity.fromJson(ticket as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'quantity': quantity,
      'payment_status': paymentStatus.value,
      'paid_at': paidAt?.toIso8601String(),
      'individual_tickets': individualTickets.map((ticket) => ticket.toJson()).toList(),
    };
  }

  bool get isPaid => paymentStatus == PaymentStatus.paid;
  bool get isPending => paymentStatus == PaymentStatus.pending;
  bool get isFailed => paymentStatus == PaymentStatus.failed;
  bool get isCancelled => paymentStatus == PaymentStatus.cancelled;

  int get usedTicketsCount {
    return individualTickets.where((ticket) => ticket.used).length;
  }

  int get unusedTicketsCount {
    return individualTickets.where((ticket) => !ticket.used).length;
  }

  bool get hasUsedTickets => usedTicketsCount > 0;
  bool get allTicketsUsed => usedTicketsCount == quantity;

  PurchasedTicketEntity copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    int? quantity,
    PaymentStatus? paymentStatus,
    DateTime? paidAt,
    List<IndividualTicketEntity>? individualTickets,
  }) {
    return PurchasedTicketEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      quantity: quantity ?? this.quantity,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paidAt: paidAt ?? this.paidAt,
      individualTickets: individualTickets ?? this.individualTickets,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PurchasedTicketEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PurchasedTicketEntity(id: $id, name: $name, email: $email, quantity: $quantity, paymentStatus: ${paymentStatus.value})';
  }
}