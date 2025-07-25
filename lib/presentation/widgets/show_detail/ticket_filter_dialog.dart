import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/event_ticket_entity.dart';
import '../../core/extensions/price_extension.dart';

class TicketFilterDialog extends StatefulWidget {
  final List<EventTicketEntity> tickets;
  final TicketStatus? initialStatus;
  final String? initialPhase;
  final String? initialCategory;
  final RangeValues? initialQtyRange;
  final RangeValues? initialPriceRange;
  final Function(
    TicketStatus? status,
    String? phase,
    String? category,
    RangeValues? qtyRange,
    RangeValues? priceRange,
  ) onApply;

  const TicketFilterDialog({
    super.key,
    required this.tickets,
    this.initialStatus,
    this.initialPhase,
    this.initialCategory,
    this.initialQtyRange,
    this.initialPriceRange,
    required this.onApply,
  });

  @override
  State<TicketFilterDialog> createState() => _TicketFilterDialogState();
}

class _TicketFilterDialogState extends State<TicketFilterDialog> {
  late TicketStatus? tempStatus;
  late String? tempPhase;
  late String? tempCategory;
  late RangeValues? tempQtyRange;
  late RangeValues? tempPriceRange;

  late List<String> phases;
  late List<String> categories;
  late double minQty;
  late double maxQty;
  late double minPrice;
  late double maxPrice;

  @override
  void initState() {
    super.initState();
    
    // Initialize temporary values
    tempStatus = widget.initialStatus;
    tempPhase = widget.initialPhase;
    tempCategory = widget.initialCategory;
    tempQtyRange = widget.initialQtyRange;
    tempPriceRange = widget.initialPriceRange;

    // Get unique values for filters
    phases = widget.tickets.map((t) => t.phase.name).toSet().toList()..sort();
    categories = widget.tickets.map((t) => t.category.name).toSet().toList()..sort();
    
    // Calculate min/max for ranges
    minQty = widget.tickets.map((t) => t.qty).reduce((a, b) => a < b ? a : b).toDouble();
    maxQty = widget.tickets.map((t) => t.qty).reduce((a, b) => a > b ? a : b).toDouble();
    minPrice = widget.tickets.map((t) => t.price).reduce((a, b) => a < b ? a : b);
    maxPrice = widget.tickets.map((t) => t.price).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: const Text('Filter Tickets'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status filter
            _buildSectionTitle('Status', textTheme),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: TicketStatus.values.map((status) {
                return ChoiceChip(
                  label: Text(status.value.toUpperCase()),
                  selected: tempStatus == status,
                  onSelected: (selected) {
                    setState(() {
                      tempStatus = selected ? status : null;
                    });
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Phase filter
            _buildSectionTitle('Phase', textTheme),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: phases.map((phase) {
                return ChoiceChip(
                  label: Text(phase),
                  selected: tempPhase == phase,
                  onSelected: (selected) {
                    setState(() {
                      tempPhase = selected ? phase : null;
                    });
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Category filter
            _buildSectionTitle('Category', textTheme),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: tempCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      tempCategory = selected ? category : null;
                    });
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Quantity range
            _buildSectionTitle('Quantity Range', textTheme),
            const SizedBox(height: 8),
            if (maxQty > minQty) ...[
              RangeSlider(
                values: tempQtyRange ?? RangeValues(minQty, maxQty),
                min: minQty,
                max: maxQty,
                divisions: (maxQty - minQty).toInt(),
                labels: RangeLabels(
                  (tempQtyRange?.start ?? minQty).toInt().toString(),
                  (tempQtyRange?.end ?? maxQty).toInt().toString(),
                ),
                onChanged: (values) {
                  setState(() {
                    tempQtyRange = values;
                  });
                },
              ),
              Text(
                'From ${(tempQtyRange?.start ?? minQty).toInt()} to ${(tempQtyRange?.end ?? maxQty).toInt()}',
                style: textTheme.bodySmall,
              ),
            ] else
              Text(
                'All tickets have the same quantity',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Price range
            _buildSectionTitle('Price Range', textTheme),
            const SizedBox(height: 8),
            if (maxPrice > minPrice) ...[
              RangeSlider(
                values: tempPriceRange ?? RangeValues(minPrice, maxPrice),
                min: minPrice,
                max: maxPrice,
                divisions: ((maxPrice - minPrice) / 1000).round(),
                labels: RangeLabels(
                  (tempPriceRange?.start ?? minPrice).toFormattedPriceWithCurrency(),
                  (tempPriceRange?.end ?? maxPrice).toFormattedPriceWithCurrency(),
                ),
                onChanged: (values) {
                  setState(() {
                    tempPriceRange = values;
                  });
                },
              ),
              Text(
                'From ${(tempPriceRange?.start ?? minPrice).toFormattedPriceWithCurrency()} to ${(tempPriceRange?.end ?? maxPrice).toFormattedPriceWithCurrency()}',
                style: textTheme.bodySmall,
              ),
            ] else
              Text(
                'All tickets have the same price',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Reset temp values
            setState(() {
              tempStatus = null;
              tempPhase = null;
              tempCategory = null;
              tempQtyRange = null;
              tempPriceRange = null;
            });
          },
          child: const Text('Reset'),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(
              tempStatus,
              tempPhase,
              tempCategory,
              tempQtyRange,
              tempPriceRange,
            );
            context.pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, TextTheme textTheme) {
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}