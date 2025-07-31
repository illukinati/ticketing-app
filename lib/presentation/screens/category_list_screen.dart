import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/category/category_provider.dart';
import '../../application/core/async_state.dart';
import '../../domain/entities/category_entity.dart';
import '../widgets/category/category_list_item.dart';
import '../widgets/category/category_empty_state.dart';
import '../widgets/category/category_error_state.dart';
import '../widgets/category/create_category_dialog.dart';
import '../widgets/category/edit_category_dialog.dart';
import '../widgets/category/delete_category_dialog.dart';

class CategoryListScreen extends ConsumerStatefulWidget {
  const CategoryListScreen({super.key});

  @override
  ConsumerState<CategoryListScreen> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends ConsumerState<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryListNotifierProvider.notifier).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryListNotifierProvider);
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
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actionsIconTheme: IconThemeData(color: colorScheme.secondary),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colorScheme.secondary),
            onPressed: () => _showCreateDialog(context),
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
        child: categoryState.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (categories) {
            if (categories.isEmpty) {
              return const CategoryEmptyState();
            }

            final sortedCategories = List<CategoryEntity>.from(categories)
              ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedCategories.length,
              itemBuilder: (context, index) {
                final category = sortedCategories[index];
                return CategoryListItem(
                  category: category,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected ${category.name}')),
                    );
                  },
                  onEdit: () => _showEditDialog(context, category),
                  onDelete: () => _showDeleteDialog(context, category),
                );
              },
            );
          },
          error: (failure) => CategoryErrorState(
            failure: failure,
            onRetry: () => ref
                .read(categoryListNotifierProvider.notifier)
                .loadCategories(),
          ),
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateCategoryDialog(),
    );
  }

  void _showEditDialog(BuildContext context, CategoryEntity category) {
    showDialog(
      context: context,
      builder: (context) => EditCategoryDialog(category: category),
    );
  }

  void _showDeleteDialog(BuildContext context, CategoryEntity category) {
    showDialog(
      context: context,
      builder: (context) => DeleteCategoryDialog(category: category),
    );
  }
}
