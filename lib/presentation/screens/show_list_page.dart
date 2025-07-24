import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yono_bakrie_app/application/core/async_state.dart';
import '../../application/show/show_provider.dart';
import '../../domain/entities/show_entity.dart';
import '../widgets/show/show_list_item.dart';
import '../widgets/show/show_empty_state.dart';
import '../widgets/show/show_error_state.dart';
import '../widgets/show/create_show_dialog.dart';
import '../widgets/show/edit_show_dialog.dart';
import '../widgets/show/delete_show_dialog.dart';

class ShowListPage extends ConsumerStatefulWidget {
  const ShowListPage({super.key});

  @override
  ConsumerState<ShowListPage> createState() => _ShowListPageState();
}

class _ShowListPageState extends ConsumerState<ShowListPage> {
  @override
  void initState() {
    super.initState();
    // Load shows when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(showListNotifierProvider.notifier).loadShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final showState = ref.watch(showListNotifierProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'YB Management - Shows',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.primary),
            onPressed: () {
              ref.read(showListNotifierProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: colorScheme.primary),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreateShowDialog(),
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
        child: Column(
          children: [
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/phases'),
                      icon: const Icon(Icons.timeline),
                      label: const Text('PHASES'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/categories'),
                      icon: const Icon(Icons.category),
                      label: const Text('CATEGORY'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: showState.when(
                initial: () =>
                    const Center(child: Text('Tap refresh to load shows')),
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (shows) => _buildShowsList(shows),
                error: (failure) => ShowErrorState(
                  failure: failure,
                  onRetry: () =>
                      ref.read(showListNotifierProvider.notifier).refresh(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowsList(List<ShowEntity> shows) {
    if (shows.isEmpty) {
      return const ShowEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: shows.length,
      itemBuilder: (context, index) {
        final show = shows[index];
        return ShowListItem(
          show: show,
          onTap: () {
            context.push('/show-detail', extra: show);
          },
          onEdit: () => showDialog(
            context: context,
            builder: (context) => EditShowDialog(show: show),
          ),
          onDelete: () => showDialog(
            context: context,
            builder: (context) => DeleteShowDialog(show: show),
          ),
        );
      },
    );
  }
}
