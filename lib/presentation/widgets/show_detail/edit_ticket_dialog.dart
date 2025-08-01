import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_management/application/core/async_state.dart';
import '../../core/utils/error_handler.dart';
import '../../../domain/entities/event_ticket_entity.dart';
import '../../../domain/entities/phase_entity.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../application/event_ticket/event_ticket_provider.dart';
import '../../../application/phase/phase_provider.dart';
import '../../../application/category/category_provider.dart';

class EditTicketDialog extends ConsumerStatefulWidget {
  final EventTicketEntity ticket;

  const EditTicketDialog({super.key, required this.ticket});

  @override
  ConsumerState<EditTicketDialog> createState() => _EditTicketDialogState();
}

class _EditTicketDialogState extends ConsumerState<EditTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;

  late PhaseEntity _selectedPhase;
  late CategoryEntity _selectedCategory;
  late TicketStatus _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: widget.ticket.qty.toString());
    _priceController = TextEditingController(
      text: widget.ticket.price.toStringAsFixed(0),
    );
    _selectedPhase = widget.ticket.phase;
    _selectedCategory = widget.ticket.category;
    _selectedStatus = widget.ticket.status;

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
      orElse: () => [_selectedPhase],
    );

    final categories = categoriesState.maybeWhen(
      data: (categories) => categories,
      orElse: () => [_selectedCategory],
    );

    return AlertDialog(
      title: const Text('Edit Ticket'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phase dropdown
              DropdownButtonFormField<PhaseEntity>(
                value: phases.any((p) => p.id == _selectedPhase.id)
                    ? _selectedPhase
                    : null,
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
                onChanged: (value) => setState(() => _selectedPhase = value!),
                validator: (value) =>
                    value == null ? 'Please select a phase' : null,
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<CategoryEntity>(
                value: categories.any((c) => c.id == _selectedCategory.id)
                    ? _selectedCategory
                    : null,
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
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              // Quantity field
              TextFormField(
                controller: _qtyController,
                decoration: InputDecoration(
                  labelText: 'Available Quantity',
                  border: const OutlineInputBorder(),
                  helperText: 'Original: ${widget.ticket.originalQty}',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  final qty = int.tryParse(value);
                  if (qty == null || qty < 0) {
                    return 'Please enter a valid quantity';
                  }
                  if (qty > widget.ticket.originalQty) {
                    return 'Cannot exceed original quantity';
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
          onPressed: _isLoading ? null : _updateTicket,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Update'),
        ),
      ],
    );
  }

  Future<void> _updateTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final qty = int.parse(_qtyController.text);
    final price = double.parse(_priceController.text);

    final result = await ref
        .read(eventTicketListNotifierProvider.notifier)
        .updateEventTicket(
          id: widget.ticket.id,
          qty: qty,
          price: price,
          showId: widget.ticket.showId,
          phaseId: _selectedPhase.id,
          categoryId: _selectedCategory.id,
          status: _selectedStatus,
          originalQty: widget.ticket.originalQty,
          movedQty: widget.ticket.movedQty,
        );

    if (mounted) {
      setState(() => _isLoading = false);

      ErrorHandler.handleResult(
        context,
        result,
        successMessage: 'Ticket updated successfully',
        onSuccess: (_) {
          context.pop();
          // Refresh the ticket list
          ref
              .read(eventTicketListNotifierProvider.notifier)
              .loadEventTicketsByShow(widget.ticket.showId);
        },
      );
    }
  }
}
