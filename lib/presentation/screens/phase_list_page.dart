import 'package:flutter/material.dart';

class PhaseListPage extends StatefulWidget {
  const PhaseListPage({super.key});

  @override
  State<PhaseListPage> createState() => _PhaseListPageState();
}

class _PhaseListPageState extends State<PhaseListPage> {
  final List<Map<String, String>> _phases = [
    {'name': 'Phase 1', 'description': 'Initial phase'},
    {'name': 'Phase 2', 'description': 'Development phase'},
    {'name': 'Phase 3', 'description': 'Testing phase'},
    {'name': 'Phase 4', 'description': 'Production phase'},
    {'name': 'Phase 5', 'description': 'Maintenance phase'},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Phases',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colorScheme.primary),
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
              colorScheme.primary.withValues(alpha: 0.05),
              colorScheme.surface,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _phases.length,
          itemBuilder: (context, index) {
            final phase = _phases[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(phase['name'] ?? ''),
                subtitle: Text(phase['description'] ?? ''),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showAddEditDialog(
                        context,
                        index: index,
                        initialName: phase['name'],
                        initialDescription: phase['description'],
                      );
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(
                        context,
                        phase['name'] ?? '',
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
                    SnackBar(content: Text('Selected ${phase['name']}')),
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
        title: Text('${isEdit ? 'Edit' : 'Add'} Phase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Phase Name',
                hintText: 'Enter phase name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Phase Description',
                hintText: 'Enter phase description',
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
                    _phases[index] = item;
                  } else {
                    _phases.add(item);
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
        title: const Text('Delete Phase'),
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
                _phases.removeAt(index);
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