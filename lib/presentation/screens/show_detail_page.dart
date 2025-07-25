import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/ticket_filter_state.dart';
import '../core/utils/error_handler.dart';
import '../core/models/ticket_action.dart';
import '../../domain/entities/show_entity.dart';
import '../../domain/entities/event_ticket_entity.dart';
import '../../application/event_ticket/event_ticket_provider.dart';
import '../../application/core/async_state.dart';
import '../widgets/show_detail/show_info_card.dart';
import '../widgets/show_detail/ticket_filter_chips.dart';
import '../widgets/show_detail/ticket_filter_dialog.dart';
import '../widgets/show_detail/ticket_list_section.dart';
import '../widgets/show_detail/create_ticket_dialog.dart';
import '../widgets/show_detail/edit_ticket_dialog.dart';
import '../widgets/show_detail/delete_ticket_dialog.dart';

class ShowDetailPage extends ConsumerStatefulWidget {
  final ShowEntity show;

  const ShowDetailPage({super.key, required this.show});

  @override
  ConsumerState<ShowDetailPage> createState() => _ShowDetailPageState();
}

class _ShowDetailPageState extends ConsumerState<ShowDetailPage> {
  TicketFilterState _filterState = const TicketFilterState.empty();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(eventTicketListNotifierProvider.notifier)
          .loadEventTicketsByShow(widget.show.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ticketState = ref.watch(eventTicketListNotifierProvider);

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
                    icon: Icon(Icons.add, color: colorScheme.primary),
                    onPressed: () => _showCreateTicketDialog(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: colorScheme.primary),
                    onPressed: () => _showFilterDialog(context),
                  ),
                ],
              ),
            ),

            // Filter chips
            TicketFilterChips(
              selectedStatus: _filterState.selectedStatus,
              selectedPhase: _filterState.selectedPhase,
              selectedCategory: _filterState.selectedCategory,
              qtyRange: _filterState.qtyRange,
              priceRange: _filterState.priceRange,
              onClearStatus: () => setState(
                () => _filterState = _filterState.copyWith(clearStatus: true),
              ),
              onClearPhase: () => setState(
                () => _filterState = _filterState.copyWith(clearPhase: true),
              ),
              onClearCategory: () => setState(
                () => _filterState = _filterState.copyWith(clearCategory: true),
              ),
              onClearQtyRange: () => setState(
                () => _filterState = _filterState.copyWith(clearQtyRange: true),
              ),
              onClearPriceRange: () => setState(
                () =>
                    _filterState = _filterState.copyWith(clearPriceRange: true),
              ),
              onClearAll: _clearAllFilters,
            ),

            const SizedBox(height: 16),

            // Tickets List
            Expanded(
              child: TicketListSection(
                ticketState: ticketState,
                filteredTickets: _getFilteredTickets(ticketState),
                hasActiveFilters: _filterState.hasActiveFilters,
                onClearFilters: _clearAllFilters,
                onRetry: () => ref
                    .read(eventTicketListNotifierProvider.notifier)
                    .loadEventTicketsByShow(widget.show.id),
                onTicketAction: _handleTicketAction,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filterState = const TicketFilterState.empty();
    });
  }

  List<EventTicketEntity> _getFilteredTickets(
    AsyncState<List<EventTicketEntity>> ticketState,
  ) {
    final tickets = ticketState.maybeWhen(
      data: (tickets) => tickets,
      orElse: () => <EventTicketEntity>[],
    );

    return _filterState.applyFilters(tickets);
  }

  void _showFilterDialog(BuildContext context) {
    final tickets = ref
        .read(eventTicketListNotifierProvider)
        .maybeWhen(
          data: (tickets) => tickets,
          orElse: () => <EventTicketEntity>[],
        );

    if (tickets.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => TicketFilterDialog(
        tickets: tickets,
        initialStatus: _filterState.selectedStatus,
        initialPhase: _filterState.selectedPhase,
        initialCategory: _filterState.selectedCategory,
        initialQtyRange: _filterState.qtyRange,
        initialPriceRange: _filterState.priceRange,
        onApply: (status, phase, category, qty, price) {
          setState(() {
            _filterState = TicketFilterState(
              selectedStatus: status,
              selectedPhase: phase,
              selectedCategory: category,
              qtyRange: qty,
              priceRange: price,
            );
          });
        },
      ),
    );
  }

  void _showCreateTicketDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreateTicketDialog(show: widget.show),
    );
  }

  void _handleTicketAction(TicketAction action) {
    switch (action.type) {
      case TicketActionType.edit:
        _showEditTicketDialog(action.ticket);
        break;
      case TicketActionType.delete:
        _showDeleteTicketDialog(action.ticket);
        break;
      case TicketActionType.statusChange:
        _handleStatusChange(action.ticket, action.newStatus!);
        break;
    }
  }

  void _showEditTicketDialog(EventTicketEntity ticket) {
    showDialog(
      context: context,
      builder: (context) => EditTicketDialog(ticket: ticket),
    );
  }

  void _showDeleteTicketDialog(EventTicketEntity ticket) {
    showDialog(
      context: context,
      builder: (context) => DeleteTicketDialog(ticket: ticket),
    );
  }

  void _handleStatusChange(
    EventTicketEntity ticket,
    TicketStatus newStatus,
  ) async {
    final result = await ref
        .read(eventTicketListNotifierProvider.notifier)
        .updateEventTicketStatus(
          id: ticket.id,
          status: newStatus,
          showId: ticket.showId,
        );

    if (mounted) {
      ErrorHandler.handleResult(
        context,
        result,
        successMessage: 'Status updated to ${newStatus.value.toUpperCase()}',
        onSuccess: (_) {
          // Refresh the ticket list
          ref
              .read(eventTicketListNotifierProvider.notifier)
              .loadEventTicketsByShow(widget.show.id);
        },
      );
    }
  }
}
