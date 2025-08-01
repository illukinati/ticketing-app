import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../application/ticket_validation/ticket_validation_provider.dart';
import '../../application/purchased_ticket/purchased_ticket_provider.dart';
import '../../domain/entities/ticket_validation_entity.dart';
import '../../domain/entities/purchased_ticket_entity.dart';

class ScanQRPage extends ConsumerStatefulWidget {
  const ScanQRPage({super.key});

  @override
  ConsumerState<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends ConsumerState<ScanQRPage>
    with WidgetsBindingObserver {
  late MobileScannerController controller;
  bool isCameraActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      autoStart: false, // Don't auto start camera
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        if (isCameraActive) {
          controller.start();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (isCameraActive) {
          controller.stop();
        }
        break;
      default:
        break;
    }
  }

  void _toggleCamera() {
    setState(() {
      if (isCameraActive) {
        controller.stop();
        isCameraActive = false;
      } else {
        controller.start();
        isCameraActive = true;
      }
    });
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _validateTicket(barcode.rawValue!);
        break;
      }
    }
  }

  Future<void> _validateTicket(String token) async {

    // Stop scanner temporarily to prevent multiple scans
    controller.stop();
    setState(() {
      isCameraActive = false;
    });

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await ref
        .read(ticketValidationProvider.notifier)
        .validateTicket(token: token);

    result.fold(
      (failure) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        _showErrorSnackbar(failure.message);
      },
      (validation) async {
        PurchasedTicketEntity? ownerInfo;
        if (validation.isValid &&
            validation.ticket != null) {
          final purchaseResult = await ref
              .read(purchasedTicketRepositoryProvider)
              .getPurchasedTicketById(validation.ticket!.purchaseId);

          purchaseResult.fold(
            (failure) {
              ownerInfo = null;
            },
            (purchase) {
              ownerInfo = purchase;
            },
          );
        }

        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();
        }

        _showValidationResult(validation, ownerInfo);
      },
    );
  }

  void _showValidationResult(
    TicketValidationEntity validation,
    PurchasedTicketEntity? ownerInfo,
  ) {
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              validation.isValid 
                  ? Icons.check_circle 
                  : validation.isAlreadyUsed 
                      ? Icons.warning 
                      : Icons.error,
              color: validation.isValid 
                  ? Colors.green 
                  : validation.isAlreadyUsed 
                      ? Colors.orange 
                      : Colors.red,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                validation.message,
                style: textTheme.titleLarge?.copyWith(
                  color: validation.isValid 
                      ? Colors.green 
                      : validation.isAlreadyUsed 
                          ? Colors.orange 
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (validation.ticket != null) ...[
              // Owner Information Section
              if (ownerInfo != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Informasi Pemilik Tiket',
                            style: textTheme.titleSmall?.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Nama', ownerInfo.name),
                      const SizedBox(height: 6),
                      _buildInfoRow('Telepon', ownerInfo.phone),
                      const SizedBox(height: 6),
                      _buildInfoRow('Email', ownerInfo.email),
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        'Total Tiket',
                        '${ownerInfo.quantity} tiket',
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text(
                              'Digunakan:',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${ownerInfo.usedTicketsCount} dari ${ownerInfo.quantity} tiket',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ownerInfo.allTicketsUsed
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Ticket Information Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_number,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Informasi Tiket',
                          style: textTheme.titleSmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'ID Tiket',
                      '#${validation.ticket!.ticketId}',
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      'Nomor Tiket',
                      '${validation.ticket!.ticketNumber}',
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      'Event',
                      validation.ticket!.event,
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      'Kategori',
                      '${validation.ticket!.category} - ${validation.ticket!.phase}',
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(
                            'Status:',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: validation.ticket!.used
                                  ? Colors.red.withValues(alpha: 0.1)
                                  : Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: validation.ticket!.used
                                    ? Colors.red.withValues(alpha: 0.3)
                                    : Colors.green.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  validation.ticket!.used
                                      ? Icons.cancel
                                      : Icons.check_circle,
                                  size: 14,
                                  color: validation.ticket!.used
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  validation.ticket!.used
                                      ? 'Sudah Digunakan'
                                      : 'Belum Digunakan',
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: validation.ticket!.used
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (validation.ticket!.usedAt != null) ...[
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        'Digunakan',
                        _formatDateTime(validation.ticket!.usedAt!),
                      ),
                    ],
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        validation.message,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _toggleCamera();
            },
            child: const Text('Scan Lagi'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Scan Lagi',
          textColor: Colors.white,
          onPressed: () {
            _toggleCamera();
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '$label:',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Scan QR Code',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // Camera toggle button
          IconButton(
            icon: Icon(
              isCameraActive ? Icons.videocam : Icons.videocam_off,
              color: Colors.white,
            ),
            onPressed: _toggleCamera,
            tooltip: isCameraActive ? 'Turn off camera' : 'Turn on camera',
          ),
          if (isCameraActive) ...[
            ValueListenableBuilder<MobileScannerState>(
              valueListenable: controller,
              builder: (context, state, child) {
                return IconButton(
                  icon: Icon(
                    state.torchState == TorchState.on
                        ? Icons.flash_on
                        : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: () => controller.toggleTorch(),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.cameraswitch, color: Colors.white),
              onPressed: () => controller.switchCamera(),
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          // Camera view or placeholder
          if (isCameraActive)
            MobileScanner(
              controller: controller,
              onDetect: _onDetect,
              errorBuilder: (context, error, child) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Camera Error',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.errorDetails?.message ??
                              'Unable to access camera',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () => controller.start(),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          else
            Container(
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
                      onPressed: _toggleCamera,
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
            ),

          // Scanning overlay and instructions (only when camera is active)
          if (isCameraActive) ...[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Scanning frame
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.primary, width: 3),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),

            // Instructions
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Position QR code within the frame',
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
