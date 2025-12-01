import 'package:flutter/cupertino.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
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

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _startScanning() async {
    print('[QR Scanner] _startScanning called');
    
    try {
      final feedback = context.read<FeedbackService>();
      await feedback.selectionClick();
      print('[QR Scanner] Feedback played');

      print('[QR Scanner] Opening barcode scanner');
      final result = await BarcodeScanner.scan();
      print('[QR Scanner] Scan result: $result');

      if (!mounted) return;

      final scannedCode = result.rawContent.trim();
      print('[QR Scanner] Scanned value: $scannedCode');

      if (scannedCode.isEmpty) {
        print('[QR Scanner] Empty scan result');
        return;
      }

      if (_isValidAmount(scannedCode)) {
        print('[QR Scanner] Valid amount detected: $scannedCode');
        _showNoteDialog(scannedCode);
      } else {
        print('[QR Scanner] Invalid amount: $scannedCode');
        _showInvalidAmountDialog(scannedCode);
      }
    } catch (e) {
      print('[QR Scanner] Scan error: $e');
      
      if (!mounted) return;

      final errorMessage = e.toString();
      
      if (errorMessage.contains('permission')) {
        print('[QR Scanner] Camera permission denied');
        showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Camera Permission Required'),
            content: const Text(
              'Camera permission is required to scan QR codes. Please enable it in Settings.',
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
                  Navigator.pop(context);
                  openAppSettings();
                },
              ),
            ],
          ),
        );
      } else if (errorMessage.contains('cancel') || errorMessage.contains('user')) {
        print('[QR Scanner] Scan cancelled by user');
      } else {
        print('[QR Scanner] Scan error: $errorMessage');
        showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Scan Error', style: AppTheme.headingMedium),
            content: Text(
              'Error scanning QR code: $errorMessage',
              style: AppTheme.bodyMedium,
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
  }

  void _showInvalidAmountDialog(String value) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Invalid Amount', style: AppTheme.headingMedium),
        content: Text(
          'The scanned value "$value" is not a valid amount.\n\nPlease scan a QR code with a numeric value.',
          style: AppTheme.bodyLarge,
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text('OK', style: AppTheme.headingMedium),
          ),
        ],
      ),
    );
  }

  void _showNoteDialog(String amount) {
    _noteController.clear();
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
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
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Receipt Saved', style: AppTheme.bodyLarge),
        content: Text('Amount: $amount'),
        actions: [
          CupertinoDialogAction(
            child: Text('OK', style: AppTheme.bodyLarge),
            onPressed: () async {
              final feedback = context.read<FeedbackService>();
              await feedback.lightImpact();
              if (!mounted) return;
              Navigator.pop(context);
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
    print('[QR Scanner] build() called');
    
    return CupertinoPageScaffold(
      backgroundColor: AppTheme.pageScaffoldConfig.backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor:
            AppTheme.pageScaffoldConfig.navigationBarBackgroundColor,
        middle: const Text('Scan QR Code'),
      ),
      child: SafeArea(
        child: Center(
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
