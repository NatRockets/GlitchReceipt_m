import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:glitch_receipt/providers/receipt_provider.dart';
import 'package:glitch_receipt/services/feedback_service.dart';
import 'package:glitch_receipt/theme/app_theme.dart';
import 'package:glitch_receipt/widgets/blob_widget.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _isValidAmount(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    return parsed != null && parsed > 0;
  }

  late MobileScannerController controller;
  bool _isScanning = false;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // Request permission
      status = await Permission.camera.request();
      if (status.isGranted) {
        // Permission granted, proceed with camera operations
      } else if (status.isPermanentlyDenied) {
        // User denied permission permanently, guide them to settings
        openAppSettings();
      }
    } else if (status.isGranted) {
      // Permission already granted, proceed
    } else if (status.isPermanentlyDenied) {
      // User denied permission permanently, guide them to settings
      openAppSettings();
    }
  }

  Future<void> _startScanning() async {
    await requestCameraPermission();
    final feedback = context.read<FeedbackService>();
    await feedback.selectionClick();
    final status = await Permission.camera.status;

    if (!status.isGranted) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Camera Permission'),
          content: const Text(
            'Camera permission is required to scan QR codes.',
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel', style: AppTheme.headingMedium),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Settings', style: AppTheme.headingMedium),
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      return;
    }

    try {
      await controller.start();
      if (mounted) {
        setState(() => _isScanning = true);
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Camera Error', style: AppTheme.headingMedium),
          content: Text(
            'Camera is not available on this device.',
            style: AppTheme.headingMedium,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('OK', style: AppTheme.headingMedium),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  void _handleBarcode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        final value = barcode.rawValue!;
        if (_isValidAmount(value)) {
          _showNoteDialog(value);
        } else {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text('Invalid Amount', style: AppTheme.headingMedium),
              content: Text(
                'The receipt amount must be a valid number.',
                style: AppTheme.bodyLarge,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: Text('OK', style: AppTheme.headingMedium),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  void _showNoteDialog(String amount) {
    _noteController.clear();
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Add Note', style: AppTheme.headingMedium),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 180),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text('Amount: $amount', style: AppTheme.bodyLarge),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _noteController,
                  placeholder: 'Add a note (optional)',
                  maxLines: 4,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel', style: AppTheme.headingMedium),
            onPressed: () {
              Navigator.pop(context);
              _noteController.clear();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Save', style: AppTheme.headingMedium),
            onPressed: () async {
              final feedback = context.read<FeedbackService>();
              await feedback.heavyImpact();
              if (!mounted) return;
              Navigator.pop(context);
              _saveReceipt(
                amount,
                _noteController.text.isEmpty ? null : _noteController.text,
              );
              _noteController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _saveReceipt(String amount, [String? note]) {
    if (!mounted) return;

    final provider = context.read<ReceiptProvider>();
    provider.addReceipt(amount, note: note);

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Receipt', style: AppTheme.bodyLarge),
        content: Text('Amount: $amount'),
        actions: [
          CupertinoDialogAction(
            child: Text('OK', style: AppTheme.bodyLarge),
            onPressed: () async {
              final feedback = context.read<FeedbackService>();
              await feedback.lightImpact();
              if (!mounted) return;
              Navigator.pop(context);
              setState(() => _isScanning = false);
              controller.stop();
            },
          ),
        ],
      ),
    );
  }

  void _showManualInputDialog() async {
    final feedback = context.read<FeedbackService>();
    await feedback.selectionClick();
    _amountController.clear();
    if (!mounted) return;
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Enter Amount'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _amountController,
                placeholder: 'Enter receipt amount',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel', style: AppTheme.headingMedium),
            onPressed: () {
              Navigator.pop(context);
              _amountController.clear();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Next', style: AppTheme.headingMedium),
            onPressed: () async {
              final text = _amountController.text;
              if (text.isNotEmpty) {
                if (_isValidAmount(text)) {
                  final feedback = context.read<FeedbackService>();
                  await feedback.selectionClick();
                  if (!mounted) return;
                  Navigator.pop(context);
                  _showNoteDialog(text);
                  _amountController.clear();
                } else {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: Text(
                        'Invalid Amount',
                        style: AppTheme.headingLarge,
                      ),
                      content: Text(
                        'The receipt amount must be a valid number.',
                        style: AppTheme.bodyLarge,
                      ),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          child: Text('OK', style: AppTheme.bodyLarge),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppTheme.pageScaffoldConfig.backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor:
            AppTheme.pageScaffoldConfig.navigationBarBackgroundColor,
        middle: const Text('Scan QR Code'),
      ),
      child: SafeArea(
        child: _isScanning
            ? Column(
                children: [
                  Expanded(
                    child: MobileScanner(
                      controller: controller,
                      onDetect: _handleBarcode,
                    ),
                  ),
                  Padding(
                    padding: AppTheme.paddingLarge,
                    child: SizedBox(
                      width: double.infinity,
                      child: ThemedPrimaryButton(
                        onPressed: () async {
                          final feedback = context.read<FeedbackService>();
                          await feedback.selectionClick();
                          setState(() => _isScanning = false);
                          controller.stop();
                        },
                        label: 'Stop Scanning',
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.qrcode,
                      size: AppTheme.iconSizeLarge,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(height: AppTheme.spacingXLarge),
                    Text('Scan Receipt QR Code', style: AppTheme.headingLarge),
                    SizedBox(height: AppTheme.spacingHuge),
                    SizedBox(
                      width: 200,
                      child: ThemedPrimaryButton(
                        onPressed: _startScanning,
                        label: 'Start Scanning',
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingLarge),
                    SizedBox(
                      width: 200,
                      child: ThemedSecondaryButton(
                        onPressed: _showManualInputDialog,
                        label: 'Enter Amount Manually',
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
