import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/phase/phase_provider.dart';
import '../../../domain/entities/phase_entity.dart';

class DeletePhaseDialog extends ConsumerWidget {
  final PhaseEntity phase;

  const DeletePhaseDialog({
    super.key,
    required this.phase,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Delete Phase'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to delete "${phase.name}"?'),
          const SizedBox(height: 8),
          Text(
            'Description: ${phase.description}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () async {
            final result = await ref
                .read(phaseListNotifierProvider.notifier)
                .deletePhase(phase.id);

            if (context.mounted) {
              Navigator.of(context).pop();
              result.fold(
                (failure) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${failure.message}'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
                (_) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted: ${phase.name}')),
                ),
              );
            }
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}