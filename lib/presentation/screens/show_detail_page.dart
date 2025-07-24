import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/show_entity.dart';
import '../../domain/entities/event_ticket_entity.dart';
import '../../application/event_ticket/event_ticket_provider.dart';
import '../../application/core/async_state.dart';
import '../widgets/show_detail/show_info_card.dart';
import '../widgets/show_detail/ticket_filter_chips.dart';
import '../widgets/show_detail/ticket_filter_dialog.dart';
import '../widgets/show_detail/ticket_list_section.dart';

class ShowDetailPage extends ConsumerStatefulWidget {
  final ShowEntity show;

  const ShowDetailPage({super.key, required this.show});

  @override
  ConsumerState<ShowDetailPage> createState() => _ShowDetailPageState();
}

class _ShowDetailPageState extends ConsumerState<ShowDetailPage> {
  // Filter states
  TicketStatus? selectedStatus;
  String? selectedPhase;
  String? selectedCategory;
  RangeValues? qtyRange;
  RangeValues? priceRange;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventTicketByShowNotifierProvider.notifier).loadEventTicketsByShow(widget.show.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ticketState = ref.watch(eventTicketByShowNotifierProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Show Details',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.secondary.withValues(alpha: 0.05),
              colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            // Show Detail Section
            ShowInfoCard(show: widget.show),
            
            // Tickets Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.confirmation_number, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Ticket Information',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: colorScheme.primary,
                    ),
                    onPressed: () => _showFilterDialog(context),
                  ),
                ],
              ),
            ),

            // Filter chips
            TicketFilterChips(
              selectedStatus: selectedStatus,
              selectedPhase: selectedPhase,
              selectedCategory: selectedCategory,
              qtyRange: qtyRange,
              priceRange: priceRange,
              onClearStatus: () => setState(() => selectedStatus = null),
              onClearPhase: () => setState(() => selectedPhase = null),
              onClearCategory: () => setState(() => selectedCategory = null),
              onClearQtyRange: () => setState(() => qtyRange = null),
              onClearPriceRange: () => setState(() => priceRange = null),
              onClearAll: _clearAllFilters,
              formatPrice: _formatPrice,
            ),

            const SizedBox(height: 16),

            // Tickets List
            Expanded(
              child: TicketListSection(
                ticketState: ticketState,
                filteredTickets: _getFilteredTickets(ticketState),
                hasActiveFilters: _hasActiveFilters(),
                onClearFilters: _clearAllFilters,
                onRetry: () => ref.read(eventTicketByShowNotifierProvider.notifier)
                    .loadEventTicketsByShow(widget.show.id),
                formatPrice: _formatPrice,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return selectedStatus != null ||
        selectedPhase != null ||
        selectedCategory != null ||
        qtyRange != null ||
        priceRange != null;
  }

  void _clearAllFilters() {
    setState(() {
      selectedStatus = null;
      selectedPhase = null;
      selectedCategory = null;
      qtyRange = null;
      priceRange = null;
    });
  }

  List<EventTicketEntity> _getFilteredTickets(AsyncState<List<EventTicketEntity>> ticketState) {
    final tickets = ticketState.maybeWhen(
      data: (tickets) => tickets,
      orElse: () => <EventTicketEntity>[],
    );

    if (!_hasActiveFilters()) return tickets;

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

  void _showFilterDialog(BuildContext context) {
    final tickets = ref.read(eventTicketByShowNotifierProvider).maybeWhen(
      data: (tickets) => tickets,
      orElse: () => <EventTicketEntity>[],
    );
    
    if (tickets.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => TicketFilterDialog(
        tickets: tickets,
        initialStatus: selectedStatus,
        initialPhase: selectedPhase,
        initialCategory: selectedCategory,
        initialQtyRange: qtyRange,
        initialPriceRange: priceRange,
        formatPrice: _formatPrice,
        onApply: (status, phase, category, qty, price) {
          setState(() {
            selectedStatus = status;
            selectedPhase = phase;
            selectedCategory = category;
            qtyRange = qty;
            priceRange = price;
          });
        },
      ),
    );
  }

  String _formatPrice(double price) {
    final priceInt = price.toInt();
    final priceString = priceInt.toString();
    final result = StringBuffer();
    
    for (int i = 0; i < priceString.length; i++) {
      if ((priceString.length - i) % 3 == 0 && i != 0) {
        result.write(',');
      }
      result.write(priceString[i]);
    }
    
    return result.toString();
  }
}