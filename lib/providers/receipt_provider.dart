import 'package:flutter/foundation.dart';
import 'package:glitch_receipt/models/receipt.dart';
import 'package:glitch_receipt/models/glitch_art.dart';
import 'package:glitch_receipt/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class ReceiptProvider extends ChangeNotifier {
  final List<Receipt> _receipts = [];
  final List<GlitchArt> _glitchArts = [];
  final StorageService _storageService;
  late bool _autoSaveEnabled;

  ReceiptProvider(this._storageService) {
    _autoSaveEnabled = _storageService.getAutoSave();
  }

  List<Receipt> get receipts => List.unmodifiable(_receipts);
  List<GlitchArt> get glitchArts => List.unmodifiable(_glitchArts);

  GlitchArt? getGlitchArtByReceiptId(String receiptId) {
    try {
      return _glitchArts.firstWhere((art) => art.receiptId == receiptId);
    } catch (e) {
      return null;
    }
  }

  Future<void> loadReceipts() async {
    _receipts.clear();
    _receipts.addAll(await _storageService.loadReceipts());
    notifyListeners();
  }

  Future<void> loadGlitchArts() async {
    _glitchArts.clear();
    _glitchArts.addAll(await _storageService.loadGlitchArts());
    notifyListeners();
  }

  Future<void> _saveIfNeeded() async {
    if (_autoSaveEnabled) {
      await _storageService.saveReceipts(_receipts);
    }
  }

  Future<void> _saveGlitchArtsIfNeeded() async {
    if (_autoSaveEnabled) {
      await _storageService.saveGlitchArts(_glitchArts);
    }
  }

  void setAutoSaveEnabled(bool enabled) {
    _autoSaveEnabled = enabled;
    if (enabled) {
      _saveIfNeeded();
      _saveGlitchArtsIfNeeded();
    }
  }

  void addReceipt(String amount, {String? note, String? qrContent}) {
    final receipt = Receipt(
      id: const Uuid().v4(),
      amount: amount,
      scannedAt: DateTime.now(),
      note: note,
      qrContent: qrContent,
    );
    _receipts.insert(0, receipt);
    _saveIfNeeded();
    notifyListeners();
  }

  void removeReceipt(String id) {
    _receipts.removeWhere((receipt) => receipt.id == id);
    _glitchArts.removeWhere((art) => art.receiptId == id);
    _saveIfNeeded();
    _saveGlitchArtsIfNeeded();
    notifyListeners();
  }

  Future<void> addGlitchArt(GlitchArt glitchArt) async {
    _glitchArts.add(glitchArt);
    
    final receiptIndex = _receipts.indexWhere((r) => r.id == glitchArt.receiptId);
    if (receiptIndex != -1) {
      final updatedReceipt = _receipts[receiptIndex].copyWith(glitchArtId: glitchArt.id);
      _receipts[receiptIndex] = updatedReceipt;
      _saveIfNeeded();
    }
    
    _saveGlitchArtsIfNeeded();
    notifyListeners();
  }

  Future<void> clearData() async {
    _receipts.clear();
    _glitchArts.clear();
    await _storageService.clear();
    notifyListeners();
  }
}
