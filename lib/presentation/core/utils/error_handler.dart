import 'package:flutter/material.dart';
import 'package:yb_management/domain/values_object/failure.dart';

class ErrorHandler {
  static void showError(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${failure.message}'),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// Extension method for easier usage with Either results
  static void handleResult<T>(
    BuildContext context,
    dynamic result, {
    String? successMessage,
    void Function(T)? onSuccess,
  }) {
    result.fold((failure) => showError(context, failure), (data) {
      if (successMessage != null) {
        showSuccess(context, successMessage);
      }
      onSuccess?.call(data);
    });
  }
}
