import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../application/ticket_validation/ticket_validation_provider.dart';
import '../../application/purchased_ticket/purchased_ticket_provider.dart';
import '../../domain/entities/ticket_validation_entity.dart';
import '../../domain/entities/purchased_ticket_entity.dart';
import '../widgets/scan_qr/qr_scanner_overlay.dart';
import '../widgets/scan_qr/qr_camera_placeholder.dart';
import '../widgets/scan_qr/qr_validation_dialog.dart';
import '../widgets/scan_qr/qr_camera_error.dart';

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

    // Always close loading dialog first before showing any other dialog
    if (mounted) {
      Navigator.of(context).pop();
    }

    result.fold(
      (failure) {
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

        _showValidationResult(validation, ownerInfo);
      },
    );
  }

  void _showValidationResult(
    TicketValidationEntity validation,
    PurchasedTicketEntity? ownerInfo,
  ) {
    showDialog(
      context: context,
      builder: (context) => QRValidationDialog(
        validation: validation,
        ownerInfo: ownerInfo,
        onScanAgain: _toggleCamera,
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


  @override
  Widget build(BuildContext context) {
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
                return QRCameraError(
                  error: error,
                  onTryAgain: () => controller.start(),
                );
              },
            )
          else
            QRCameraPlaceholder(onStartCamera: _toggleCamera),

          // Scanning overlay (only when camera is active)
          if (isCameraActive) const QRScannerOverlay(),
        ],
      ),
    );
  }
}
