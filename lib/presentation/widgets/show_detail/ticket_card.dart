import 'package:flutter/material.dart';
import '../../../domain/entities/event_ticket_entity.dart';
import '../../../domain/entities/phase_entity.dart';
import '../../core/extensions/price_extension.dart';
import '../../core/models/ticket_action.dart';

class TicketCard extends StatelessWidget {
  final EventTicketEntity ticket;
  final Function(TicketAction)? onAction;

  const TicketCard({super.key, required this.ticket, this.onAction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TicketHeader(ticket: ticket, onAction: onAction),
            const SizedBox(height: 8),
            Text(
              ticket.price.toFormattedPriceWithCurrency(),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ticket.category.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _TicketQuantityInfo(ticket: ticket),
          ],
        ),
      ),
    );
  }
}

class _TicketHeader extends StatelessWidget {
  final EventTicketEntity ticket;
  final Function(TicketAction)? onAction;

  const _TicketHeader({required this.ticket, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatusBadge(status: ticket.status),
        const SizedBox(width: 12),
        _PhaseInfo(phase: ticket.phase),
        const Spacer(),
        if (onAction != null) _TicketMenu(ticket: ticket, onAction: onAction!),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TicketStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final statusColor = _getTicketStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.value.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getTicketStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.available:
        return Colors.green;
      case TicketStatus.unavailable:
        return Colors.orange;
      case TicketStatus.soldOut:
        return Colors.red;
    }
  }
}

class _PhaseInfo extends StatelessWidget {
  final PhaseEntity phase;

  const _PhaseInfo({required this.phase});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timeline, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          phase.name,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TicketMenu extends StatelessWidget {
  final EventTicketEntity ticket;
  final Function(TicketAction) onAction;

  const _TicketMenu({required this.ticket, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onAction(TicketAction.edit(ticket));
            break;
          case 'delete':
            onAction(TicketAction.delete(ticket));
            break;
          case 'status_available':
            onAction(TicketAction.statusChange(ticket, TicketStatus.available));
            break;
          case 'status_unavailable':
            onAction(
              TicketAction.statusChange(ticket, TicketStatus.unavailable),
            );
            break;
          case 'status_soldOut':
            onAction(TicketAction.statusChange(ticket, TicketStatus.soldOut));
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'status_header',
          enabled: false,
          child: Text(
            'Change Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        ...TicketStatus.values
            .where((status) => status != ticket.status)
            .map(
              (status) => PopupMenuItem(
                value: 'status_${status.name}',
                child: _StatusMenuItem(status: status),
              ),
            ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'edit',
          child: _MenuItem(icon: Icons.edit, text: 'Edit'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: _MenuItem(
            icon: Icons.delete,
            text: 'Delete',
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

class _StatusMenuItem extends StatelessWidget {
  final TicketStatus status;

  const _StatusMenuItem({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getTicketStatusColor(status),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(status.value.toUpperCase()),
      ],
    );
  }

  Color _getTicketStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.available:
        return Colors.green;
      case TicketStatus.unavailable:
        return Colors.orange;
      case TicketStatus.soldOut:
        return Colors.red;
    }
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _MenuItem({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(text, style: color != null ? TextStyle(color: color) : null),
      ],
    );
  }
}

class _TicketQuantityInfo extends StatelessWidget {
  final EventTicketEntity ticket;

  const _TicketQuantityInfo({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuantityItem(
          icon: Icons.inventory,
          label: 'Total',
          value: ticket.originalQty.toString(),
        ),
        const SizedBox(width: 16),
        _QuantityItem(
          icon: Icons.confirmation_number_outlined,
          label: 'Available',
          value: ticket.availableQty.toString(),
        ),
      ],
    );
  }
}

class _QuantityItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuantityItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
