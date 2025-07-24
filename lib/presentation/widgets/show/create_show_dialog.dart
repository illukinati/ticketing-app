import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/show/show_provider.dart';

class CreateShowDialog extends ConsumerStatefulWidget {
  const CreateShowDialog({super.key});

  @override
  ConsumerState<CreateShowDialog> createState() => _CreateShowDialogState();
}

class _CreateShowDialogState extends ConsumerState<CreateShowDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Show'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Show Name',
          hintText: 'Enter show name',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_controller.text.trim().isNotEmpty) {
              final result = await ref
                  .read(showListNotifierProvider.notifier)
                  .createShow(_controller.text.trim());

              if (context.mounted) {
                context.pop();
                result.fold(
                  (failure) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${failure.message}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  (show) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Created: ${show.name}')),
                  ),
                );
              }
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}