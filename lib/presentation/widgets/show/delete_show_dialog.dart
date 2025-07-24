import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/show/show_provider.dart';
import '../../../domain/entities/show_entity.dart';

class DeleteShowDialog extends ConsumerWidget {
  final ShowEntity show;

  const DeleteShowDialog({
    super.key,
    required this.show,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Delete Show'),
      content: Text('Are you sure you want to delete "${show.name}"?'),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () async {
            final result = await ref
                .read(showListNotifierProvider.notifier)
                .deleteShow(show.id);

            if (context.mounted) {
              context.pop();
              result.fold(
                (failure) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${failure.message}'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
                (_) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted: ${show.name}')),
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