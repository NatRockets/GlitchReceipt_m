import 'package:flutter/services.dart';

class FeedbackService {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  FeedbackService({
    required bool soundEnabled,
    required bool vibrationEnabled,
  })  : _soundEnabled = soundEnabled,
        _vibrationEnabled = vibrationEnabled;

  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
  }

  Future<void> selectionClick() async {
    if (_soundEnabled) {
      await HapticFeedback.selectionClick();
    }
  }

  Future<void> lightImpact() async {
    if (_vibrationEnabled) {
      await HapticFeedback.lightImpact();
    }
  }

  Future<void> heavyImpact() async {
    if (_vibrationEnabled) {
      await HapticFeedback.heavyImpact();
    }
  }
}
