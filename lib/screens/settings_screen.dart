import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:glitch_receipt/providers/settings_provider.dart';
import 'package:glitch_receipt/providers/receipt_provider.dart';
import 'package:glitch_receipt/services/feedback_service.dart';
import 'package:glitch_receipt/theme/app_theme.dart';
import 'package:glitch_receipt/widgets/blob_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final feedback = context.read<FeedbackService>();
    await feedback.selectionClick();
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppTheme.pageScaffoldConfig.backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor:
            AppTheme.pageScaffoldConfig.navigationBarBackgroundColor,
        middle: const Text('Settings'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: AppTheme.paddingLarge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppTheme.spacingXLarge),

                  SizedBox(height: AppTheme.spacingHuge),
                  ThemedListSection(
                    children: [
                      Consumer<SettingsProvider>(
                        builder: (context, settings, _) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoListTile(
                                title: Text(
                                  'Auto Save',
                                  style: AppTheme.bodyMedium,
                                ),
                                trailing: CupertinoSwitch(
                                  value: settings.autoSaveEnabled,
                                  onChanged: (value) async {
                                    final feedback = context
                                        .read<FeedbackService>();
                                    await feedback.selectionClick();
                                    await settings.setAutoSave(value);
                                    if (context.mounted) {
                                      context
                                          .read<ReceiptProvider>()
                                          .setAutoSaveEnabled(value);
                                      if (value) {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) => ThemedAlertDialog(
                                            title: 'Auto Save Enabled',
                                            content:
                                                'Your data will be saved automatically.',
                                            onPressed: () async {
                                              if (!context.mounted) return;
                                              final feedback = context
                                                  .read<FeedbackService>();
                                              await feedback.lightImpact();
                                            },
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              CupertinoListTile(
                                title: Text(
                                  'Sound',
                                  style: AppTheme.bodyMedium,
                                ),
                                trailing: CupertinoSwitch(
                                  value: settings.soundEnabled,
                                  onChanged: (value) async {
                                    await settings.setSoundEnabled(value);
                                  },
                                ),
                              ),
                              CupertinoListTile(
                                title: Text(
                                  'Vibration',
                                  style: AppTheme.bodyMedium,
                                ),
                                trailing: CupertinoSwitch(
                                  value: settings.vibrationEnabled,
                                  onChanged: (value) async {
                                    if (value) {
                                      final feedback = context
                                          .read<FeedbackService>();
                                      await feedback.selectionClick();
                                    }
                                    await settings.setVibrationEnabled(value);
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacingHuge),
                  ThemedListSection(
                    header: const Text('About'),
                    children: [
                      CupertinoListTile(
                        title: Text('App Version', style: AppTheme.bodyMedium),
                        trailing: Text('1.1.0', style: AppTheme.bodySmall),
                      ),
                      CupertinoListTile(
                        title: Text(
                          'Help & Support',
                          style: AppTheme.bodyMedium,
                        ),
                        trailing: Icon(
                          CupertinoIcons.forward,
                          color: AppTheme.primaryColor,
                          size: AppTheme.iconSizeSmall,
                        ),
                        onTap: () => _launchUrl(
                          context,
                          'https://glitch-receeipt.com/support.html',
                        ),
                      ),
                      CupertinoListTile(
                        title: Text('App Privacy', style: AppTheme.bodyMedium),
                        trailing: Icon(
                          CupertinoIcons.forward,
                          color: AppTheme.primaryColor,
                          size: AppTheme.iconSizeSmall,
                        ),
                        onTap: () => _launchUrl(
                          context,
                          'https://glitch-receeipt.com/privacy-policy.html',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
