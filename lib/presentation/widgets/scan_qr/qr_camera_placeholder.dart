import 'package:flutter/material.dart';

class QRCameraPlaceholder extends StatelessWidget {
  final VoidCallback onStartCamera;

  const QRCameraPlaceholder({
    super.key,
    required this.onStartCamera,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 120,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 32),
            Text(
              'QR Code Scanner',
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tap the camera button to start scanning',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 48),
            FilledButton.icon(
              onPressed: onStartCamera,
              icon: const Icon(Icons.videocam),
              label: const Text('Start Camera'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}