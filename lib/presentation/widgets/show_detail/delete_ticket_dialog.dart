import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/event_ticket_entity.dart';
import '../../../application/event_ticket/event_ticket_provider.dart';
import '../../core/extensions/price_extension.dart';
import '../../core/utils/error_handler.dart';

class DeleteTicketDialog extends ConsumerWidget {
  final EventTicketEntity ticket;

  const DeleteTicketDialog({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: const Text('Delete Ticket'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Are you sure you want to delete this ticket?'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ticket Details',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Category', ticket.category.name),
                _buildDetailRow('Phase', ticket.phase.name),
                _buildDetailRow('Price', ticket.price.toFormattedPriceWithCurrency()),
                _buildDetailRow('Available Qty', '${ticket.qty}'),
                _buildDetailRow('Original Qty', '${ticket.originalQty}'),
                _buildDetailRow('Status', ticket.status.value.toUpperCase()),
                if (ticket.soldQty > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${ticket.soldQty} tickets have been sold',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This action cannot be undone.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.error),
          onPressed: () async {
            final result = await ref
                .read(eventTicketListNotifierProvider.notifier)
                .deleteEventTicket(ticket.id, ticket.showId);

            if (context.mounted) {
              context.pop();
              ErrorHandler.handleResult(
                context,
                result,
                successMessage: 'Ticket deleted successfully',
                onSuccess: (_) {
                  // Refresh the ticket list
                  ref
                      .read(eventTicketListNotifierProvider.notifier)
                      .loadEventTicketsByShow(ticket.showId);
                },
              );
            }
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:', style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
