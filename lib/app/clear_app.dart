import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:glitch_receipt/providers/receipt_provider.dart';
import 'package:glitch_receipt/providers/settings_provider.dart';
import 'package:glitch_receipt/services/storage_service.dart';
import 'package:glitch_receipt/services/feedback_service.dart';
import 'package:glitch_receipt/screens/qr_scan_screen.dart';
import 'package:glitch_receipt/screens/saved_receipts_screen.dart';
import 'package:glitch_receipt/screens/collection_screen.dart';
import 'package:glitch_receipt/screens/settings_screen.dart';
import 'package:glitch_receipt/theme/app_theme.dart';
import 'package:glitch_receipt/widgets/blob_widget.dart';

class ClearApp extends StatefulWidget {
  const ClearApp({super.key});

  @override
  State<ClearApp> createState() => _ClearAppState();
}

class _ClearAppState extends State<ClearApp> {
  late Future<StorageService> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initialize();
  }

  Future<StorageService> _initialize() async {
    await _requestCameraPermission();
    final storageService = StorageService();
    await storageService.init();
    return storageService;
  }

  Future<void> _requestCameraPermission() async {
    await Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StorageService>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CupertinoApp(
            debugShowCheckedModeBanner: false,
            home: const CupertinoPageScaffold(
              child: Center(child: CupertinoActivityIndicator()),
            ),
          );
        }

        final storageService = snapshot.data!;
        final settingsProvider = SettingsProvider(storageService);
        final feedbackService = FeedbackService(
          soundEnabled: storageService.getSoundEnabled(),
          vibrationEnabled: storageService.getVibrationEnabled(),
        );

        return MultiProvider(
          providers: [
            Provider<StorageService>(create: (_) => storageService),
            Provider<FeedbackService>(create: (_) => feedbackService),
            ChangeNotifierProvider(
              create: (_) => ReceiptProvider(storageService),
            ),
            ChangeNotifierProvider(create: (_) => settingsProvider),
          ],
          child: Consumer<SettingsProvider>(
            builder: (context, settings, _) {
              feedbackService.setSoundEnabled(settings.soundEnabled);
              feedbackService.setVibrationEnabled(settings.vibrationEnabled);

              return CupertinoApp(
                debugShowCheckedModeBanner: false,
                home: CupertinoTabScaffold(
                  backgroundColor: CupertinoColors.transparent,
                  tabBar: CupertinoTabBar(
                    backgroundColor: AppTheme.tabBarConfig.backgroundColor,
                    activeColor: AppTheme.tabBarConfig.activeColor,
                    inactiveColor: AppTheme.tabBarConfig.inactiveColor,
                    border: Border(
                      top: BorderSide(
                        color: AppTheme.tabBarConfig.borderColor,
                        width: 0.5,
                      ),
                    ),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.qrcode),
                        label: 'Scan',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.doc_text),
                        label: 'Receipts',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.collections),
                        label: 'Collection',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.settings),
                        label: 'Settings',
                      ),
                    ],
                  ),
                  tabBuilder: (context, index) {
                    return _TabContentWrapper(child: _buildScreen(index));
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const QrScanScreen();
      case 1:
        return const SavedReceiptsScreen();
      case 2:
        return const CollectionScreen();
      case 3:
        return const SettingsScreen();
      default:
        return const QrScanScreen();
    }
  }
}

class _TabContentWrapper extends StatelessWidget {
  final Widget child;

  const _TabContentWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final bgConfig = AppTheme.backgroundConfig;

    return Stack(
      children: [
        Positioned.fill(child: Container(color: bgConfig.color)),
        if (bgConfig.useBlobBackground)
          Positioned.fill(
            child: IgnorePointer(
              child: FloatingBlobBackground(
                colors: const [
                  AppTheme.primaryColor,
                  AppTheme.accentColor,
                  AppTheme.errorColor,
                ],
                size: 200,
                config: AppTheme.blobConfig,
              ),
            ),
          ),
        Positioned.fill(child: child),
      ],
    );
  }
}
