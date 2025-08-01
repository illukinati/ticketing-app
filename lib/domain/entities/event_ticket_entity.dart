import '../values_object/date.dart';
import 'show_entity.dart';
import 'phase_entity.dart';
import 'category_entity.dart';

enum TicketStatus {
  available,
  unavailable,
  soldOut;

  static TicketStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return TicketStatus.available;
      case 'unavailable':
        return TicketStatus.unavailable;
      case 'sold_out':
        return TicketStatus.soldOut;
      default:
        return TicketStatus.available;
    }
  }

  String get value {
    switch (this) {
      case TicketStatus.available:
        return 'available';
      case TicketStatus.unavailable:
        return 'unavailable';
      case TicketStatus.soldOut:
        return 'sold_out';
    }
  }
}

class EventTicketEntity {
  final int id;
  final Date createdAt;
  final Date updatedAt;
  final int qty;
  final double price;
  final int showId;
  final int phaseId;
  final int categoryId;
  final TicketStatus status;
  final int originalQty;
  final int movedQty;
  final int availableQuantity;
  final ShowEntity show;
  final PhaseEntity phase;
  final CategoryEntity category;

  const EventTicketEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.qty,
    required this.price,
    required this.showId,
    required this.phaseId,
    required this.categoryId,
    required this.status,
    required this.originalQty,
    required this.movedQty,
    required this.availableQuantity,
    required this.show,
    required this.phase,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTicketEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          qty == other.qty &&
          price == other.price &&
          showId == other.showId &&
          phaseId == other.phaseId &&
          categoryId == other.categoryId &&
          status == other.status &&
          originalQty == other.originalQty &&
          movedQty == other.movedQty &&
          availableQuantity == other.availableQuantity &&
          show == other.show &&
          phase == other.phase &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      qty.hashCode ^
      price.hashCode ^
      showId.hashCode ^
      phaseId.hashCode ^
      categoryId.hashCode ^
      status.hashCode ^
      originalQty.hashCode ^
      movedQty.hashCode ^
      availableQuantity.hashCode ^
      show.hashCode ^
      phase.hashCode ^
      category.hashCode;

  @override
  String toString() {
    return 'EventTicketEntity{id: $id, qty: $qty, price: $price, showId: $showId, phaseId: $phaseId, categoryId: $categoryId, status: $status, originalQty: $originalQty, movedQty: $movedQty, availableQuantity: $availableQuantity, createdAt: $createdAt, updatedAt: $updatedAt, show: $show, phase: $phase, category: $category}';
  }

  // Helper methods
  bool get isAvailable => status == TicketStatus.available;
  bool get isUnavailable => status == TicketStatus.unavailable;
  bool get isSoldOut => status == TicketStatus.soldOut;
  
  // Available quantity calculation
  // Use the available_quantity field from backend which represents actual available tickets
  int get availableQty {
    return availableQuantity;
  }
  
  int get soldQty => originalQty - qty; // Tickets sold (original - remaining)
  int get reservedQty => movedQty; // Tickets moved/reserved for other purposes
  
  double get totalValue => price * originalQty;
  double get availableValue => price * availableQty;
  double get soldValue => price * soldQty;
  double get reservedValue => price * reservedQty;
  
  bool get hasMoved => movedQty > 0;
  bool get hasAvailableTickets => availableQty > 0 && isAvailable;
}