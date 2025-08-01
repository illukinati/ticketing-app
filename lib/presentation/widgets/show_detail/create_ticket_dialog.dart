import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_management/application/core/async_state.dart';
import '../../core/utils/error_handler.dart';
import '../../../domain/entities/event_ticket_entity.dart';
import '../../../domain/entities/show_entity.dart';
import '../../../domain/entities/phase_entity.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../application/event_ticket/event_ticket_provider.dart';
import '../../../application/phase/phase_provider.dart';
import '../../../application/category/category_provider.dart';

class CreateTicketDialog extends ConsumerStatefulWidget {
  final ShowEntity show;

  const CreateTicketDialog({super.key, required this.show});

  @override
  ConsumerState<CreateTicketDialog> createState() => _CreateTicketDialogState();
}

class _CreateTicketDialogState extends ConsumerState<CreateTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();

  PhaseEntity? _selectedPhase;
  CategoryEntity? _selectedCategory;
  TicketStatus _selectedStatus = TicketStatus.available;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load phases and categories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(phaseListNotifierProvider.notifier).loadPhases();
      ref.read(categoryListNotifierProvider.notifier).loadCategories();
    });
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phasesState = ref.watch(phaseListNotifierProvider);
    final categoriesState = ref.watch(categoryListNotifierProvider);

    final phases = phasesState.maybeWhen(
      data: (phases) => phases,
      orElse: () => <PhaseEntity>[],
    );

    final categories = categoriesState.maybeWhen(
      data: (categories) => categories,
      orElse: () => <CategoryEntity>[],
    );

    return AlertDialog(
      title: const Text('Create New Ticket'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phase dropdown
              DropdownButtonFormField<PhaseEntity>(
                value: _selectedPhase,
                decoration: const InputDecoration(
                  labelText: 'Phase',
                  border: OutlineInputBorder(),
                ),
                items: phases.map((phase) {
                  return DropdownMenuItem(
                    value: phase,
                    child: Row(
                      children: [
                        Text(phase.name),
                        if (!phase.active) ...[ 
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Inactive',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedPhase = value),
                validator: (value) =>
                    value == null ? 'Please select a phase' : null,
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<CategoryEntity>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              // Quantity field
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  final qty = int.tryParse(value);
                  if (qty == null || qty <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price field
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status dropdown
              DropdownButtonFormField<TicketStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: TicketStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.value.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedStatus = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => context.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createTicket,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final qty = int.parse(_qtyController.text);
    final price = double.parse(_priceController.text);

    final result = await ref
        .read(eventTicketListNotifierProvider.notifier)
        .createEventTicket(
          qty: qty,
          price: price,
          showId: widget.show.id,
          phaseId: _selectedPhase!.id,
          categoryId: _selectedCategory!.id,
          status: _selectedStatus,
          originalQty: qty,
        );

    if (mounted) {
      setState(() => _isLoading = false);

      ErrorHandler.handleResult(
        context,
        result,
        successMessage: 'Ticket created successfully',
        onSuccess: (_) {
          context.pop();
          // Refresh the ticket list
          ref
              .read(eventTicketListNotifierProvider.notifier)
              .loadEventTicketsByShow(widget.show.id);
        },
      );
    }
  }

}
