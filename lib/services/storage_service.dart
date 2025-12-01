import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glitch_receipt/models/receipt.dart';
import 'package:glitch_receipt/models/glitch_art.dart';

class StorageService {
  static const String _receiptsKey = 'receipts';
  static const String _glitchArtsKey = 'glitchArts';
  static const String _autoSaveKey = 'autoSave';
  static const String _soundKey = 'soundEnabled';
  static const String _vibrationKey = 'vibrationEnabled';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveReceipts(List<Receipt> receipts) async {
    final jsonList = receipts.map((receipt) => receipt.toJson()).toList();
    await _prefs.setString(_receiptsKey, jsonEncode(jsonList));
  }

  Future<List<Receipt>> loadReceipts() async {
    final json = _prefs.getString(_receiptsKey);
    if (json == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(json);
      return decoded.map((item) => Receipt.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveGlitchArts(List<GlitchArt> glitchArts) async {
    final jsonList = glitchArts.map((art) => art.toJson()).toList();
    await _prefs.setString(_glitchArtsKey, jsonEncode(jsonList));
  }

  Future<List<GlitchArt>> loadGlitchArts() async {
    final json = _prefs.getString(_glitchArtsKey);
    if (json == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(json);
      return decoded.map((item) => GlitchArt.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> setAutoSave(bool enabled) async {
    await _prefs.setBool(_autoSaveKey, enabled);
  }

  bool getAutoSave() {
    return _prefs.getBool(_autoSaveKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundKey, enabled);
  }

  bool getSoundEnabled() {
    return _prefs.getBool(_soundKey) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs.setBool(_vibrationKey, enabled);
  }

  bool getVibrationEnabled() {
    return _prefs.getBool(_vibrationKey) ?? true;
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
