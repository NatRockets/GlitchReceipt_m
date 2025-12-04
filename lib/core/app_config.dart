import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppConfig {
  static const String appsFlyerDevKey = '2azqU6HmYMGBoovYSSMNQQ';
  static const String appsFlyerAppId = '6755954169'; // Для iOS'
  static const String bundleId = 'com.fink.gli.tch'; // Для iOS'
  static const String locale = 'en'; // Для iOS'
  static const String os = 'iOS'; // Для iOS'
  static const String endpoint = 'https://glitch-receeipt.com'; // Для iOS'
  static const String firebaseProjectId = 'glitch-receipt'; // Для iOS'

  //UI Settings
  // Splash Screen
  static const Decoration splashDecoration = const BoxDecoration(
    gradient: AppConfig.splashGradient,
  );

  static const Gradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.fromARGB(255, 100, 47, 160), Color.fromARGB(255, 60, 30, 0)],
  );
  static const String logoPath = 'assets/images/L1.png';

  static const Color loadingTextColor = Color(0xFFFFFFFF);
  static const Color spinerColor = Color(0xFCFFFFFF);
  // Push Request Screen Settings

  static const Decoration pushRequestDecoration = const BoxDecoration(
    gradient: AppConfig.pushRequestFadeGradient,
  );

  static const Gradient pushRequestGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color.fromARGB(255, 100, 47, 160), Color.fromARGB(255, 60, 30, 0)],
  );
  static const Gradient pushRequestFadeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color.fromARGB(135, 0, 0, 0)],
  );
  static const Color titleTextColor = Color(0xFFFFFFFF);
  static const Color subtitleTextColor = Color(0x80FDFDFD);

  static const Color yesButtonColor = Color(0xFFFFB301);
  static const Color yesButtonShadowColor = Color(0xFF8B3619);
  static const Color yesButtonTextColor = Color(0xFFFFFFFF);
  static const Color skipTextColor = Color(0x7DF9F9F9);

  // Путь к логотипу, если не находит добавить в pubspec.yaml
  static const String pushRequestLogoPath = 'assets/images/L1.png';

  // экран ошибки подключения интернета
  // Error Screen
  static const Decoration errorScreenDecoration = const BoxDecoration(
    gradient: AppConfig.errorScreenGradient,
  );

  static const Gradient errorScreenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.fromARGB(255, 85, 65, 108), Color.fromARGB(255, 54, 29, 10)],
  );
  static const Color errorScreenTextColor = Color(0xFFFFFFFF);
  static const Color errorScreenIconColor = Color(0xFCFFFFFF);
}
