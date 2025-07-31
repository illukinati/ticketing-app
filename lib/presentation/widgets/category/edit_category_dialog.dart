import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/category/category_provider.dart';
import '../../../domain/entities/category_entity.dart';

class EditCategoryDialog extends ConsumerStatefulWidget {
  final CategoryEntity category;

  const EditCategoryDialog({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends ConsumerState<EditCategoryDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _sortOrderController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(text: widget.category.description);
    _sortOrderController = TextEditingController(text: widget.category.sortOrder.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _sortOrderController,
              decoration: const InputDecoration(
                labelText: 'Sort Order',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_nameController.text.trim().isNotEmpty &&
                _descriptionController.text.trim().isNotEmpty) {
              final sortOrder = int.tryParse(_sortOrderController.text) ?? widget.category.sortOrder;
              
              final result = await ref
                  .read(categoryListNotifierProvider.notifier)
                  .updateCategory(
                    id: widget.category.id,
                    name: _nameController.text.trim(),
                    description: _descriptionController.text.trim(),
                    sortOrder: sortOrder,
                  );

              if (context.mounted) {
                context.pop();
                result.fold(
                  (failure) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${failure.message}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  (updatedCategory) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Updated: ${updatedCategory.name}')),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in all required fields'),
                ),
              );
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

}