import 'package:flutter/material.dart';
import '../../../domain/entities/ticket_validation_entity.dart';
import '../../../domain/entities/purchased_ticket_entity.dart';

class QRValidationDialog extends StatelessWidget {
  final TicketValidationEntity validation;
  final PurchasedTicketEntity? ownerInfo;
  final VoidCallback onScanAgain;

  const QRValidationDialog({
    super.key,
    required this.validation,
    this.ownerInfo,
    required this.onScanAgain,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            validation.isValid 
                ? Icons.check_circle 
                : validation.isAlreadyUsed 
                    ? Icons.warning 
                    : Icons.error,
            color: validation.isValid 
                ? Colors.green 
                : validation.isAlreadyUsed 
                    ? Colors.orange 
                    : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              validation.message,
              style: textTheme.titleLarge?.copyWith(
                color: validation.isValid 
                    ? Colors.green 
                    : validation.isAlreadyUsed 
                        ? Colors.orange 
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (validation.ticket != null) ...[
            // Owner Information Section
            if (ownerInfo != null) ...[
              _OwnerInfoSection(ownerInfo: ownerInfo!),
              const SizedBox(height: 16),
            ],

            // Ticket Information Section
            _TicketInfoSection(validation: validation),
          ] else ...[
            _ErrorInfoSection(validation: validation),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onScanAgain();
          },
          child: const Text('Scan Lagi'),
        ),
      ],
    );
  }
}

class _OwnerInfoSection extends StatelessWidget {
  final PurchasedTicketEntity ownerInfo;

  const _OwnerInfoSection({required this.ownerInfo});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Informasi Pemilik Tiket',
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Nama', value: ownerInfo.name),
          const SizedBox(height: 6),
          _InfoRow(label: 'Telepon', value: ownerInfo.phone),
          const SizedBox(height: 6),
          _InfoRow(label: 'Email', value: ownerInfo.email),
          const SizedBox(height: 6),
          _InfoRow(label: 'Total Tiket', value: '${ownerInfo.quantity} tiket'),
          const SizedBox(height: 6),
          _UsageInfoRow(ownerInfo: ownerInfo),
        ],
      ),
    );
  }
}

class _TicketInfoSection extends StatelessWidget {
  final TicketValidationEntity validation;

  const _TicketInfoSection({required this.validation});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.confirmation_number,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Informasi Tiket',
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'ID Tiket',
            value: '#${validation.ticket!.ticketId}',
          ),
          const SizedBox(height: 6),
          _InfoRow(
            label: 'Nomor Tiket',
            value: '${validation.ticket!.ticketNumber}',
          ),
          const SizedBox(height: 6),
          _InfoRow(
            label: 'Event',
            value: validation.ticket!.event,
          ),
          const SizedBox(height: 6),
          _InfoRow(
            label: 'Kategori',
            value: '${validation.ticket!.category} - ${validation.ticket!.phase}',
          ),
          const SizedBox(height: 6),
          _TicketStatusRow(ticket: validation.ticket!),
          if (validation.ticket!.usedAt != null) ...[
            const SizedBox(height: 6),
            _InfoRow(
              label: 'Digunakan',
              value: _formatDateTime(validation.ticket!.usedAt!),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _ErrorInfoSection extends StatelessWidget {
  final TicketValidationEntity validation;

  const _ErrorInfoSection({required this.validation});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              validation.message,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '$label:',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _UsageInfoRow extends StatelessWidget {
  final PurchasedTicketEntity ownerInfo;

  const _UsageInfoRow({required this.ownerInfo});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            'Digunakan:',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            '${ownerInfo.usedTicketsCount} dari ${ownerInfo.quantity} tiket',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: ownerInfo.allTicketsUsed
                  ? Colors.red
                  : Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}

class _TicketStatusRow extends StatelessWidget {
  final dynamic ticket;

  const _TicketStatusRow({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            'Status:',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: ticket.used
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: ticket.used
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.green.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  ticket.used
                      ? Icons.cancel
                      : Icons.check_circle,
                  size: 14,
                  color: ticket.used
                      ? Colors.red
                      : Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  ticket.used
                      ? 'Sudah Digunakan'
                      : 'Belum Digunakan',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ticket.used
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}