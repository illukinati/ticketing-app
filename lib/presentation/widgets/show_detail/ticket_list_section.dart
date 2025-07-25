import 'package:flutter/material.dart';
import '../../../domain/entities/event_ticket_entity.dart';
import '../../../application/core/async_state.dart';
import '../../core/models/ticket_action.dart';
import 'ticket_card.dart';

class TicketListSection extends StatelessWidget {
  final AsyncState<List<EventTicketEntity>> ticketState;
  final List<EventTicketEntity> filteredTickets;
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onRetry;
  final Function(TicketAction)? onTicketAction;

  const TicketListSection({
    super.key,
    required this.ticketState,
    required this.filteredTickets,
    required this.hasActiveFilters,
    required this.onClearFilters,
    required this.onRetry,
    this.onTicketAction,
  });

  @override
  Widget build(BuildContext context) {
    return ticketState.when(
      initial: () => const Center(child: Text('Loading tickets...')),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) {
        if (filteredTickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  hasActiveFilters
                      ? 'No tickets match the selected filters'
                      : 'No tickets available for this show',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                if (hasActiveFilters) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onClearFilters,
                    child: const Text('Clear Filters'),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredTickets.length,
          itemBuilder: (context, index) {
            final ticket = filteredTickets[index];
            return TicketCard(
              ticket: ticket,
              onAction: onTicketAction,
            );
          },
        );
      },
      error: (failure) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${failure.message}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
