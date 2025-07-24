import 'package:flutter/material.dart';
import '../../../domain/values_object/failure.dart';

class ShowErrorState extends StatelessWidget {
  final Failure failure;
  final VoidCallback onRetry;

  const ShowErrorState({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Error: ${failure.message}',
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
