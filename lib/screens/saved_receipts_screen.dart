import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:glitch_receipt/providers/receipt_provider.dart';
import 'package:glitch_receipt/models/glitch_art.dart';
import 'package:glitch_receipt/widgets/glitch_art_display.dart';
import 'package:glitch_receipt/services/feedback_service.dart';
import 'package:glitch_receipt/theme/app_theme.dart';
import 'package:glitch_receipt/widgets/blob_widget.dart';

class SavedReceiptsScreen extends StatefulWidget {
  const SavedReceiptsScreen({super.key});

  @override
  State<SavedReceiptsScreen> createState() => _SavedReceiptsScreenState();
}

class _SavedReceiptsScreenState extends State<SavedReceiptsScreen> {
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadData();
  }

  Future<void> _loadData() async {
    final provider = context.read<ReceiptProvider>();
    await provider.loadReceipts();
    await provider.loadGlitchArts();
  }

  Future<void> _showGlitchArtDialog(
    dynamic receipt,
    ReceiptProvider provider,
  ) async {
    if (!mounted) return;

    int currentSeed = Random().nextInt(10000);

    await showCupertinoDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: Text('Generated Glitch Art', style: AppTheme.headingMedium),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppTheme.borderRadiusSmall,
                    ),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: GlitchArtDisplay(
                    amount: receipt.amount,
                    seed: currentSeed,
                    qrContent: receipt.qrContent,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Amount: ${receipt.amount}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Regenerate', style: AppTheme.bodyLarge),
              onPressed: () async {
                final feedback = context.read<FeedbackService>();
                await feedback.lightImpact();
                setState(() {
                  currentSeed = Random().nextInt(10000);
                });
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Save', style: AppTheme.bodyLarge),
              onPressed: () async {
                final feedback = context.read<FeedbackService>();
                await feedback.heavyImpact();
                if (!mounted) return;
                Navigator.pop(context);

                final glitchArt = GlitchArt(
                  id: const Uuid().v4(),
                  receiptId: receipt.id,
                  amount: receipt.amount,
                  seed: currentSeed,
                  generatedAt: DateTime.now(),
                  qrContent: receipt.qrContent,
                );

                await provider.addGlitchArt(glitchArt);
              },
            ),
          ],
        ),
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
        middle: const Text('Saved Receipts'),
      ),
      child: SafeArea(
        child: FutureBuilder<void>(
          future: _loadFuture,
          builder: (context, snapshot) {
            return Consumer<ReceiptProvider>(
              builder: (context, receiptProvider, _) {
                if (receiptProvider.receipts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.doc_text,
                          size: AppTheme.iconSizeLarge,
                          color: AppTheme.successColor,
                        ),
                        SizedBox(height: AppTheme.spacingXLarge),
                        Text(
                          'No saved receipts yet',
                          style: AppTheme.emptyStateTitle,
                        ),
                        SizedBox(height: AppTheme.spacingSmall),
                        Text(
                          'Your scanned receipts will appear here',
                          style: AppTheme.emptyStateDescription,
                        ),
                      ],
                    ),
                  );
                }

                final receiptsWithoutArt = receiptProvider.receipts.where((
                  receipt,
                ) {
                  return receiptProvider.getGlitchArtByReceiptId(receipt.id) ==
                      null;
                }).toList();

                if (receiptsWithoutArt.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.doc_text,
                          size: AppTheme.iconSizeLarge,
                          color: AppTheme.successColor,
                        ),
                        SizedBox(height: AppTheme.spacingXLarge),
                        Text(
                          'No receipts to generate art from',
                          style: AppTheme.emptyStateTitle,
                        ),
                        SizedBox(height: AppTheme.spacingSmall),
                        Text(
                          'All receipts have generated art in your collection',
                          style: AppTheme.emptyStateDescription,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: receiptsWithoutArt.length,
                  itemBuilder: (context, index) {
                    final receipt = receiptsWithoutArt[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingLarge,
                        vertical: AppTheme.spacingSmall,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.borderColor),
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusSmall,
                          ),
                        ),
                        child: Padding(
                          padding: AppTheme.paddingMedium,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount: ${receipt.amount}',
                                    style: AppTheme.headingMedium,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final feedback = context
                                          .read<FeedbackService>();
                                      await feedback.heavyImpact();
                                      if (mounted) {
                                        receiptProvider.removeReceipt(
                                          receipt.id,
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      CupertinoIcons.delete,
                                      color: AppTheme.errorColor,
                                      size: AppTheme.iconSizeSmall,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppTheme.spacingXSmall),
                              Text(
                                '${receipt.scannedAt.day}/${receipt.scannedAt.month}/${receipt.scannedAt.year} '
                                '${receipt.scannedAt.hour}:${receipt.scannedAt.minute.toString().padLeft(2, '0')}',
                                style: AppTheme.labelMedium,
                              ),
                              if (receipt.note != null &&
                                  receipt.note!.isNotEmpty) ...[
                                SizedBox(height: AppTheme.spacingSmall),
                                Text(
                                  receipt.note!,
                                  style: AppTheme.italicSmall,
                                ),
                              ],
                              SizedBox(height: AppTheme.spacingMedium),
                              SizedBox(
                                width: double.infinity,
                                child: ThemedPrimaryButton(
                                  onPressed: () async {
                                    final feedback = context
                                        .read<FeedbackService>();
                                    await feedback.selectionClick();
                                    _showGlitchArtDialog(
                                      receipt,
                                      receiptProvider,
                                    );
                                  },
                                  label: 'Generate Glitch Art',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
