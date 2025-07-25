import 'package:flutter/material.dart';
import '../../../domain/entities/event_ticket_entity.dart';

class TicketFilterState {
  final TicketStatus? selectedStatus;
  final String? selectedPhase;
  final String? selectedCategory;
  final RangeValues? qtyRange;
  final RangeValues? priceRange;

  const TicketFilterState({
    this.selectedStatus,
    this.selectedPhase,
    this.selectedCategory,
    this.qtyRange,
    this.priceRange,
  });

  const TicketFilterState.empty()
      : selectedStatus = null,
        selectedPhase = null,
        selectedCategory = null,
        qtyRange = null,
        priceRange = null;

  bool get hasActiveFilters =>
      selectedStatus != null ||
      selectedPhase != null ||
      selectedCategory != null ||
      qtyRange != null ||
      priceRange != null;

  TicketFilterState copyWith({
    TicketStatus? selectedStatus,
    String? selectedPhase,
    String? selectedCategory,
    RangeValues? qtyRange,
    RangeValues? priceRange,
    bool clearStatus = false,
    bool clearPhase = false,
    bool clearCategory = false,
    bool clearQtyRange = false,
    bool clearPriceRange = false,
  }) {
    return TicketFilterState(
      selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      selectedPhase: clearPhase ? null : (selectedPhase ?? this.selectedPhase),
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      qtyRange: clearQtyRange ? null : (qtyRange ?? this.qtyRange),
      priceRange: clearPriceRange ? null : (priceRange ?? this.priceRange),
    );
  }

  List<EventTicketEntity> applyFilters(List<EventTicketEntity> tickets) {
    if (!hasActiveFilters) return tickets;

    return tickets.where((ticket) {
      // Status filter
      if (selectedStatus != null && ticket.status != selectedStatus) {
        return false;
      }

      // Phase filter
      if (selectedPhase != null && ticket.phase.name != selectedPhase) {
        return false;
      }

      // Category filter
      if (selectedCategory != null && ticket.category.name != selectedCategory) {
        return false;
      }

      // Quantity range filter
      if (qtyRange != null) {
        if (ticket.qty < qtyRange!.start || ticket.qty > qtyRange!.end) {
          return false;
        }
      }

      // Price range filter
      if (priceRange != null) {
        if (ticket.price < priceRange!.start || ticket.price > priceRange!.end) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}