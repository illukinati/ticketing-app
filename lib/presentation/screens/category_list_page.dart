import 'package:flutter/material.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final List<Map<String, String>> _categories = [
    {'name': 'Category A', 'description': 'Premium category'},
    {'name': 'Category B', 'description': 'Standard category'},
    {'name': 'Category C', 'description': 'Basic category'},
    {'name': 'Category D', 'description': 'Entry category'},
    {'name': 'Category E', 'description': 'Special category'},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Categories',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colorScheme.secondary),
            onPressed: () => _showAddEditDialog(context),
          ),
        ],
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(category['name'] ?? ''),
                subtitle: Text(category['description'] ?? ''),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showAddEditDialog(
                        context,
                        index: index,
                        initialName: category['name'],
                        initialDescription: category['description'],
                      );
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(
                        context,
                        category['name'] ?? '',
                        index,
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected ${category['name']}')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddEditDialog(
    BuildContext context, {
    int? index,
    String? initialName,
    String? initialDescription,
  }) {
    final nameController = TextEditingController(text: initialName);
    final descriptionController = TextEditingController(text: initialDescription);
    final isEdit = index != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${isEdit ? 'Edit' : 'Add'} Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'Enter category name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Category Description',
                hintText: 'Enter category description',
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
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  final item = {
                    'name': nameController.text.trim(),
                    'description': descriptionController.text.trim(),
                  };
                  
                  if (isEdit) {
                    _categories[index] = item;
                  } else {
                    _categories.add(item);
                  }
                });
                
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${isEdit ? 'Updated' : 'Added'}: ${nameController.text}',
                    ),
                  ),
                );
              }
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String name,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              setState(() {
                _categories.removeAt(index);
              });
              
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleted: $name')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}