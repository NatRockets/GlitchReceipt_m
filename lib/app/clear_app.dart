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
    print('[App Init] Starting app initialization');
    try {
      print('[App Init] Requesting camera permission');
      await _requestCameraPermission();
      print('[App Init] Camera permission completed');
      
      print('[App Init] Initializing storage service');
      final storageService = StorageService();
      await storageService.init();
      print('[App Init] Storage service initialized successfully');
      return storageService;
    } catch (e) {
      print('[App Init] Error during initialization: $e');
      rethrow;
    }
  }

  Future<void> _requestCameraPermission() async {
    try {
      print('[Camera Permission] Checking camera permission status');
      var status = await Permission.camera.status;
      print('[Camera Permission] Current status: $status');
      print('[Camera Permission] isDenied: ${status.isDenied}, isDenied: ${status.isDenied}, isPermanentlyDenied: ${status.isPermanentlyDenied}');
      
      if (status.isDenied) {
        print('[Camera Permission] Permission is denied, requesting...');
        status = await Permission.camera.request();
        print('[Camera Permission] Permission request result: $status');
      } else if (status.isGranted) {
        print('[Camera Permission] Permission already granted');
      } else if (status.isPermanentlyDenied) {
        print('[Camera Permission] Permission permanently denied by user');
      } else {
        print('[Camera Permission] Unknown permission status: $status');
      }
      
      print('[Camera Permission] Final status - isGranted: ${status.isGranted}');
    } catch (e) {
      print('[Camera Permission] Error requesting permission: $e');
      rethrow;
    }
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

        return MultiProvider(
          providers: [
            Provider<StorageService>(create: (_) => storageService),
            ChangeNotifierProvider(
              create: (_) => ReceiptProvider(storageService),
            ),
            ChangeNotifierProvider(create: (_) => settingsProvider),
            ProxyProvider<SettingsProvider, FeedbackService>(
              update: (_, settings, __) => FeedbackService(
                soundEnabled: settings.soundEnabled,
                vibrationEnabled: settings.vibrationEnabled,
              ),
            ),
          ],
          child: CupertinoApp(
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
