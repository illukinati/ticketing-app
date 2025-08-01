import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_management/application/core/async_state.dart';
import '../../application/phase/phase_provider.dart';
import '../../domain/entities/phase_entity.dart';
import '../widgets/phase/phase_list_item.dart';
import '../widgets/phase/phase_empty_state.dart';
import '../widgets/phase/phase_error_state.dart';
import '../widgets/phase/create_phase_dialog.dart';
import '../widgets/phase/edit_phase_dialog.dart';
import '../widgets/phase/delete_phase_dialog.dart';

class PhaseListScreen extends ConsumerStatefulWidget {
  const PhaseListScreen({super.key});

  @override
  ConsumerState<PhaseListScreen> createState() => _PhaseListPageState();
}

class _PhaseListPageState extends ConsumerState<PhaseListScreen> {
  @override
  void initState() {
    super.initState();
    // Load phases when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(phaseListNotifierProvider.notifier).loadPhases();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final phaseState = ref.watch(phaseListNotifierProvider);

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
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actionsIconTheme: IconThemeData(color: colorScheme.primary),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.primary),
            onPressed: () {
              ref.read(phaseListNotifierProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: colorScheme.primary),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreatePhaseDialog(),
              );
            },
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
        child: phaseState.when(
          initial: () =>
              const Center(child: Text('Tap refresh to load phases')),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (phases) => _buildPhasesList(phases),
          error: (failure) => PhaseErrorState(
            failure: failure,
            onRetry: () =>
                ref.read(phaseListNotifierProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }

  Widget _buildPhasesList(List<PhaseEntity> phases) {
    if (phases.isEmpty) {
      return const PhaseEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: phases.length,
      itemBuilder: (context, index) {
        final phase = phases[index];
        return PhaseListItem(
          phase: phase,
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Selected: ${phase.name}')));
          },
          onEdit: () => showDialog(
            context: context,
            builder: (context) => EditPhaseDialog(phase: phase),
          ),
          onDelete: () => showDialog(
            context: context,
            builder: (context) => DeletePhaseDialog(phase: phase),
          ),
        );
      },
    );
  }
}
