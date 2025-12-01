import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:glitch_receipt/providers/receipt_provider.dart';
import 'package:glitch_receipt/widgets/glitch_art_display.dart';
import 'package:glitch_receipt/services/glitch_art_export_service.dart';
import 'package:glitch_receipt/services/feedback_service.dart';
import 'package:glitch_receipt/theme/app_theme.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late Future<void> _loadFuture;
  final Map<String, GlobalKey> _repaintKeys = {};

  @override
  void initState() {
    super.initState();
    _loadFuture = context.read<ReceiptProvider>().loadGlitchArts();
  }

  GlobalKey _getKeyForArt(String artId) {
    _repaintKeys.putIfAbsent(artId, () => GlobalKey());
    return _repaintKeys[artId]!;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppTheme.pageScaffoldConfig.backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor:
            AppTheme.pageScaffoldConfig.navigationBarBackgroundColor,
        middle: const Text('Collection'),
      ),
      child: SafeArea(
        child: FutureBuilder<void>(
          future: _loadFuture,
          builder: (context, snapshot) {
            return Consumer<ReceiptProvider>(
              builder: (context, provider, _) {
                if (provider.glitchArts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.collections,
                          size: AppTheme.iconSizeLarge,
                          color: AppTheme.accentColor,
                        ),
                        SizedBox(height: AppTheme.spacingXLarge),
                        Text(
                          'Your Collection',
                          style: AppTheme.emptyStateTitle,
                        ),
                        SizedBox(height: AppTheme.spacingSmall),
                        Text(
                          'Generate glitch arts from your receipts',
                          style: AppTheme.emptyStateDescription,
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: AppTheme.paddingLarge,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppTheme.spacingLarge,
                    crossAxisSpacing: AppTheme.spacingLarge,
                  ),
                  itemCount: provider.glitchArts.length,
                  itemBuilder: (context, index) {
                    final glitchArt = provider.glitchArts[index];
                    final key = _getKeyForArt(glitchArt.id);
                    return GestureDetector(
                      onLongPress: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () async {
                                  final feedback = context
                                      .read<FeedbackService>();
                                  await feedback.selectionClick();
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  GlitchArtExportService.exportGlitchArt(
                                    key: key,
                                    glitchArtId: glitchArt.id,
                                    amount: glitchArt.amount,
                                  );
                                },
                                child: Text(
                                  'Export for NFT',
                                  style: AppTheme.headingMedium,
                                ),
                              ),
                              CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                onPressed: () async {
                                  final feedback = context
                                      .read<FeedbackService>();
                                  await feedback.heavyImpact();
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  provider.removeReceipt(glitchArt.receiptId);
                                },
                                child: Text(
                                  'Delete',
                                  style: AppTheme.headingMedium,
                                ),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel', style: AppTheme.bodyLarge),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusMedium,
                          ),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    AppTheme.borderRadiusMedium,
                                  ),
                                  topRight: Radius.circular(
                                    AppTheme.borderRadiusMedium,
                                  ),
                                ),
                                child: RepaintBoundary(
                                  key: key,
                                  child: GlitchArtDisplay(
                                    amount: glitchArt.amount,
                                    seed: glitchArt.seed,
                                    qrContent: glitchArt.qrContent,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: AppTheme.cardBackgroundColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                    AppTheme.borderRadiusMedium,
                                  ),
                                  bottomRight: Radius.circular(
                                    AppTheme.borderRadiusMedium,
                                  ),
                                ),
                              ),
                              padding: AppTheme.paddingSmall,
                              child: Center(
                                child: Text(
                                  '${glitchArt.generatedAt.day}/${glitchArt.generatedAt.month}/${glitchArt.generatedAt.year}',
                                  style: AppTheme.labelSmall,
                                ),
                              ),
                            ),
                          ],
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
