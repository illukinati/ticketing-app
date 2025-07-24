import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/show/show_provider.dart';
import '../../../domain/entities/show_entity.dart';

class EditShowDialog extends ConsumerStatefulWidget {
  final ShowEntity show;

  const EditShowDialog({
    super.key,
    required this.show,
  });

  @override
  ConsumerState<EditShowDialog> createState() => _EditShowDialogState();
}

class _EditShowDialogState extends ConsumerState<EditShowDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.show.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Show'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Show Name'),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_controller.text.trim().isNotEmpty) {
              final result = await ref
                  .read(showListNotifierProvider.notifier)
                  .updateShow(widget.show.id, _controller.text.trim());

              if (context.mounted) {
                Navigator.of(context).pop();
                result.fold(
                  (failure) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${failure.message}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  (updatedShow) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Updated: ${updatedShow.name}')),
                  ),
                );
              }
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}