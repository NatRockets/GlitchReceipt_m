import 'package:flutter/foundation.dart';
import 'package:glitch_receipt/services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;
  late bool _autoSaveEnabled;
  late bool _soundEnabled;
  late bool _vibrationEnabled;

  SettingsProvider(this._storageService) {
    _autoSaveEnabled = _storageService.getAutoSave();
    _soundEnabled = _storageService.getSoundEnabled();
    _vibrationEnabled = _storageService.getVibrationEnabled();
  }

  bool get autoSaveEnabled => _autoSaveEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  Future<void> setAutoSave(bool enabled) async {
    _autoSaveEnabled = enabled;
    await _storageService.setAutoSave(enabled);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _storageService.setSoundEnabled(enabled);
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    await _storageService.setVibrationEnabled(enabled);
    notifyListeners();
  }
}
