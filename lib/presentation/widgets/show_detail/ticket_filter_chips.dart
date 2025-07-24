import 'package:flutter/material.dart';
import '../../../domain/entities/event_ticket_entity.dart';

class TicketFilterChips extends StatelessWidget {
  final TicketStatus? selectedStatus;
  final String? selectedPhase;
  final String? selectedCategory;
  final RangeValues? qtyRange;
  final RangeValues? priceRange;
  final VoidCallback onClearStatus;
  final VoidCallback onClearPhase;
  final VoidCallback onClearCategory;
  final VoidCallback onClearQtyRange;
  final VoidCallback onClearPriceRange;
  final VoidCallback onClearAll;
  final String Function(double) formatPrice;

  const TicketFilterChips({
    super.key,
    this.selectedStatus,
    this.selectedPhase,
    this.selectedCategory,
    this.qtyRange,
    this.priceRange,
    required this.onClearStatus,
    required this.onClearPhase,
    required this.onClearCategory,
    required this.onClearQtyRange,
    required this.onClearPriceRange,
    required this.onClearAll,
    required this.formatPrice,
  });

  bool get hasActiveFilters =>
      selectedStatus != null ||
      selectedPhase != null ||
      selectedCategory != null ||
      qtyRange != null ||
      priceRange != null;

  @override
  Widget build(BuildContext context) {
    if (!hasActiveFilters) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              if (selectedStatus != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text('Status: ${selectedStatus!.value}'),
                    onDeleted: onClearStatus,
                    deleteIconColor: colorScheme.primary,
                  ),
                ),
              if (selectedPhase != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text('Phase: $selectedPhase'),
                    onDeleted: onClearPhase,
                    deleteIconColor: colorScheme.primary,
                  ),
                ),
              if (selectedCategory != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text('Category: $selectedCategory'),
                    onDeleted: onClearCategory,
                    deleteIconColor: colorScheme.primary,
                  ),
                ),
              if (qtyRange != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text('Qty: ${qtyRange!.start.toInt()}-${qtyRange!.end.toInt()}'),
                    onDeleted: onClearQtyRange,
                    deleteIconColor: colorScheme.primary,
                  ),
                ),
              if (priceRange != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text('Price: ${formatPrice(priceRange!.start)}-${formatPrice(priceRange!.end)}'),
                    onDeleted: onClearPriceRange,
                    deleteIconColor: colorScheme.primary,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: const Text('Clear All'),
                  onPressed: onClearAll,
                  backgroundColor: colorScheme.errorContainer,
                  labelStyle: TextStyle(color: colorScheme.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}