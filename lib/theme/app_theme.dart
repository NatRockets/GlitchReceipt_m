import 'package:flutter/cupertino.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 82, 190, 149);
  static const Color accentColor = Color.fromARGB(255, 170, 65, 20);
  static const Color successColor = CupertinoColors.systemGreen;
  static const Color errorColor = Color.fromARGB(255, 192, 28, 99);
  static const Color warningColor = CupertinoColors.systemOrange;

  static const Color textPrimary = Color.fromARGB(255, 108, 117, 179);
  static const Color textSecondary = Color.fromARGB(255, 220, 220, 225);
  static const Color textTertiary = Color.fromARGB(255, 180, 180, 183);

  static const Color appBackgroundColor = Color.fromARGB(255, 72, 66, 113);
  static const Color surfaceColor = Color.fromARGB(255, 120, 115, 167);
  static const Color dividerColor = CupertinoColors.systemGrey4;
  static const Color borderColor = CupertinoColors.systemGrey5;
  static const Color cardBackgroundColor = Color.fromARGB(255, 170, 170, 171);

  static const double iconSizeLarge = 80.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeSmall = 20.0;

  static const double fontSizeXLarge = 32.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeSmall = 14.0;
  static const double fontSizeXSmall = 12.0;
  static const double fontSizeXXSmall = 11.0;

  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.bold;

  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 20.0;
  static const double spacingXXLarge = 24.0;
  static const double spacingHuge = 30.0;

  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  static const EdgeInsets paddingSmall = EdgeInsets.all(spacingSmall);
  static const EdgeInsets paddingMedium = EdgeInsets.all(spacingMedium);
  static const EdgeInsets paddingLarge = EdgeInsets.all(spacingLarge);
  static const EdgeInsets paddingXLarge = EdgeInsets.all(spacingXLarge);

  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(
    vertical: spacingSmall,
  );
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(
    vertical: spacingMedium,
  );
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(
    vertical: spacingLarge,
  );

  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(
    horizontal: spacingSmall,
  );
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(
    horizontal: spacingMedium,
  );
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(
    horizontal: spacingLarge,
  );

  static TextStyle headlineXLarge = const TextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: fontWeightBold,
    color: textPrimary,
  );

  static TextStyle headingLarge = const TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: fontWeightMedium,
    color: textPrimary,
  );

  static TextStyle headingMedium = const TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: fontWeightSemiBold,
    color: textPrimary,
  );

  static TextStyle bodyLarge = const TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: fontWeightRegular,
    color: Color.fromARGB(255, 99, 103, 129),
  );

  static TextStyle bodyMedium = const TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: fontWeightRegular,
    color: Color.fromARGB(255, 212, 216, 241),
  );

  static TextStyle bodySmall = const TextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: fontWeightRegular,
    color: textSecondary,
  );

  static TextStyle labelLarge = const TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: fontWeightMedium,
    color: textPrimary,
  );

  static TextStyle labelMedium = const TextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: fontWeightMedium,
    color: textSecondary,
  );

  static TextStyle labelSmall = const TextStyle(
    fontSize: fontSizeXXSmall,
    fontWeight: fontWeightMedium,
    color: textSecondary,
  );

  static TextStyle captionStyle = const TextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: fontWeightRegular,
    color: textSecondary,
  );

  static TextStyle emptyStateTitle = const TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: fontWeightMedium,
    color: textPrimary,
  );

  static TextStyle emptyStateDescription = const TextStyle(
    fontSize: fontSizeSmall,
    color: textSecondary,
  );

  static TextStyle italicSmall = const TextStyle(
    fontSize: fontSizeSmall,
    fontStyle: FontStyle.italic,
    color: textPrimary,
  );

  static const bool blobEnabled = true;
  static const double blobOpacity = 0.15;
  static const Duration blobAnimationDuration = Duration(seconds: 6);
  static const List<Color> blobColors = [primaryColor, accentColor, errorColor];
  static const double blobSize = 150.0;
  static const int blobNumPoints = 83;
  static const bool blobFloatingEnabled = true;
  static const Duration blobFloatingDuration = Duration(seconds: 8);
  static const int blobNumberOfBlobs = 3;
  static const double blobMaxFloatDistance = 100.0;
  static const double blobSizeVariation = 1.2;

  static const BlobConfig blobConfig = BlobConfig(
    enabled: blobEnabled,
    opacity: blobOpacity,
    animationDuration: blobAnimationDuration,
    colors: blobColors,
    size: blobSize,
    numPoints: blobNumPoints,
    floatingEnabled: blobFloatingEnabled,
    floatingDuration: blobFloatingDuration,
    numberOfBlobs: blobNumberOfBlobs,
    maxFloatDistance: blobMaxFloatDistance,
    blobSizeVariation: blobSizeVariation,
  );

  static const ShadowConfig shadowConfig = ShadowConfig(
    blur: 12.0,
    offsetX: 0.0,
    offsetY: 4.0,
    opacity: 0.3,
  );

  static const BackgroundConfig backgroundConfig = BackgroundConfig(
    color: appBackgroundColor,
    useBlobBackground: true,
    blobOpacity: 0.08,
  );

  static const TabBarConfig tabBarConfig = TabBarConfig(
    activeColor: primaryColor,
    inactiveColor: textSecondary,
    backgroundColor: surfaceColor,
    borderColor: borderColor,
  );

  static const PageScaffoldConfig pageScaffoldConfig = PageScaffoldConfig(
    backgroundColor: CupertinoColors.transparent,
    navigationBarBackgroundColor: surfaceColor,
  );

  static const ButtonConfig buttonConfig = ButtonConfig(
    primaryColor: primaryColor,
    primaryTextColor: CupertinoColors.white,
    secondaryColor: surfaceColor,
    secondaryTextColor: primaryColor,
    height: buttonHeightMedium,
  );

  static const DialogConfig dialogConfig = DialogConfig(
    backgroundColor: surfaceColor,
    titleColor: textPrimary,
    contentColor: textPrimary,
    actionColor: primaryColor,
    destructiveActionColor: errorColor,
  );
}

class BlobConfig {
  final bool enabled;
  final double opacity;
  final Duration animationDuration;
  final List<Color> colors;
  final double size;
  final int numPoints;
  final bool floatingEnabled;
  final Duration floatingDuration;
  final int numberOfBlobs;
  final double maxFloatDistance;
  final double blobSizeVariation;

  const BlobConfig({
    required this.enabled,
    required this.opacity,
    required this.animationDuration,
    required this.colors,
    required this.size,
    required this.numPoints,
    this.floatingEnabled = true,
    this.floatingDuration = const Duration(seconds: 8),
    this.numberOfBlobs = 3,
    this.maxFloatDistance = 100.0,
    this.blobSizeVariation = 1.2,
  });

  BlobConfig copyWith({
    bool? enabled,
    double? opacity,
    Duration? animationDuration,
    List<Color>? colors,
    double? size,
    int? numPoints,
    bool? floatingEnabled,
    Duration? floatingDuration,
    int? numberOfBlobs,
    double? maxFloatDistance,
    double? blobSizeVariation,
  }) {
    return BlobConfig(
      enabled: enabled ?? this.enabled,
      opacity: opacity ?? this.opacity,
      animationDuration: animationDuration ?? this.animationDuration,
      colors: colors ?? this.colors,
      size: size ?? this.size,
      numPoints: numPoints ?? this.numPoints,
      floatingEnabled: floatingEnabled ?? this.floatingEnabled,
      floatingDuration: floatingDuration ?? this.floatingDuration,
      numberOfBlobs: numberOfBlobs ?? this.numberOfBlobs,
      maxFloatDistance: maxFloatDistance ?? this.maxFloatDistance,
      blobSizeVariation: blobSizeVariation ?? this.blobSizeVariation,
    );
  }
}

class ShadowConfig {
  final double blur;
  final double offsetX;
  final double offsetY;
  final double opacity;

  const ShadowConfig({
    required this.blur,
    required this.offsetX,
    required this.offsetY,
    required this.opacity,
  });
}

class BackgroundConfig {
  final Color color;
  final bool useBlobBackground;
  final double blobOpacity;

  const BackgroundConfig({
    required this.color,
    required this.useBlobBackground,
    required this.blobOpacity,
  });

  BackgroundConfig copyWith({
    Color? color,
    bool? useBlobBackground,
    double? blobOpacity,
  }) {
    return BackgroundConfig(
      color: color ?? this.color,
      useBlobBackground: useBlobBackground ?? this.useBlobBackground,
      blobOpacity: blobOpacity ?? this.blobOpacity,
    );
  }
}

class TabBarConfig {
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final Color borderColor;

  const TabBarConfig({
    required this.activeColor,
    required this.inactiveColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}

class PageScaffoldConfig {
  final Color backgroundColor;
  final Color navigationBarBackgroundColor;

  const PageScaffoldConfig({
    required this.backgroundColor,
    required this.navigationBarBackgroundColor,
  });
}

class ButtonConfig {
  final Color primaryColor;
  final Color primaryTextColor;
  final Color secondaryColor;
  final Color secondaryTextColor;
  final double height;

  const ButtonConfig({
    required this.primaryColor,
    required this.primaryTextColor,
    required this.secondaryColor,
    required this.secondaryTextColor,
    required this.height,
  });
}

class DialogConfig {
  final Color backgroundColor;
  final Color titleColor;
  final Color contentColor;
  final Color actionColor;
  final Color destructiveActionColor;

  const DialogConfig({
    required this.backgroundColor,
    required this.titleColor,
    required this.contentColor,
    required this.actionColor,
    required this.destructiveActionColor,
  });
}
