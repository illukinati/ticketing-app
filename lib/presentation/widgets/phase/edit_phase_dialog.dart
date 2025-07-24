import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/phase/phase_provider.dart';
import '../../../domain/entities/phase_entity.dart';

class EditPhaseDialog extends ConsumerStatefulWidget {
  final PhaseEntity phase;

  const EditPhaseDialog({
    super.key,
    required this.phase,
  });

  @override
  ConsumerState<EditPhaseDialog> createState() => _EditPhaseDialogState();
}

class _EditPhaseDialogState extends ConsumerState<EditPhaseDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _active;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.phase.name);
    _descriptionController = TextEditingController(text: widget.phase.description);
    _startDate = widget.phase.startDate;
    _endDate = widget.phase.endDate;
    _active = widget.phase.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Phase'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Phase Name',
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
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Start Date'),
                    subtitle: Text(_formatDate(_startDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectStartDate(context),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('End Date'),
                    subtitle: Text(_formatDate(_endDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectEndDate(context),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            SwitchListTile(
              title: const Text('Active'),
              value: _active,
              onChanged: (value) => setState(() => _active = value),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_nameController.text.trim().isNotEmpty &&
                _descriptionController.text.trim().isNotEmpty) {
              final result = await ref
                  .read(phaseListNotifierProvider.notifier)
                  .updatePhase(
                    id: widget.phase.id,
                    name: _nameController.text.trim(),
                    description: _descriptionController.text.trim(),
                    startDate: _startDate,
                    endDate: _endDate,
                    active: _active,
                  );

              if (context.mounted) {
                Navigator.of(context).pop();
                result.fold(
                  (failure) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${failure.message}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  (updatedPhase) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Updated: ${updatedPhase.name}')),
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

  Future<void> _selectStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}