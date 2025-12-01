import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:glitch_receipt/theme/app_theme.dart';

class ThemedPrimaryButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final Color? color;
  final Color? textColor;

  const ThemedPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.color,
    this.textColor,
  });

  @override
  State<ThemedPrimaryButton> createState() => _ThemedPrimaryButtonState();
}

class _ThemedPrimaryButtonState extends State<ThemedPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.buttonConfig.primaryColor;
    final textColor =
        widget.textColor ?? AppTheme.buttonConfig.primaryTextColor;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(_controller),
        child: Container(
          height: AppTheme.buttonConfig.height,
          padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: textColor,
                fontWeight: AppTheme.fontWeightMedium,
                fontSize: AppTheme.fontSizeSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThemedSecondaryButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final Color? color;
  final Color? textColor;

  const ThemedSecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.color,
    this.textColor,
  });

  @override
  State<ThemedSecondaryButton> createState() => _ThemedSecondaryButtonState();
}

class _ThemedSecondaryButtonState extends State<ThemedSecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.buttonConfig.secondaryColor;
    final textColor =
        widget.textColor ?? AppTheme.buttonConfig.secondaryTextColor;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(_controller),
        child: Container(
          height: AppTheme.buttonConfig.height,
          padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: textColor, width: 1.5),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: textColor,
                fontWeight: AppTheme.fontWeightMedium,
                fontSize: AppTheme.fontSizeSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlobPainter extends CustomPainter {
  final Color color;
  final double animationValue;
  final int numPoints;

  BlobPainter({
    required this.color,
    required this.animationValue,
    this.numPoints = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2;

    final path = Path();

    for (int i = 0; i < numPoints; i++) {
      final angle = (i / numPoints) * 2 * pi;
      final variationAngle = angle + (animationValue * pi / 2);
      final radius = baseRadius * (0.7 + 0.3 * sin(variationAngle));

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BlobPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.numPoints != numPoints;
  }
}

class BlobWidget extends StatefulWidget {
  final Color? color;
  final double? size;
  final Alignment alignment;
  final BlobConfig? config;

  const BlobWidget({
    super.key,
    this.color,
    this.size,
    this.alignment = Alignment.center,
    this.config,
  });

  @override
  State<BlobWidget> createState() => _BlobWidgetState();
}

class _BlobWidgetState extends State<BlobWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final config = widget.config ?? AppTheme.blobConfig;
    _controller = AnimationController(
      duration: config.animationDuration,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config ?? AppTheme.blobConfig;
    if (!config.enabled) {
      return const SizedBox.shrink();
    }

    final color = widget.color ?? config.colors.first;
    final size = widget.size ?? config.size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          alignment: widget.alignment,
          child: Opacity(
            opacity: config.opacity,
            child: SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: BlobPainter(
                  color: color,
                  animationValue: _controller.value,
                  numPoints: config.numPoints,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MultiColorBlobBackground extends StatelessWidget {
  final List<Color>? colors;
  final double? size;
  final BlobConfig? config;

  const MultiColorBlobBackground({
    super.key,
    this.colors,
    this.size,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final config = this.config ?? AppTheme.blobConfig;
    final colors = this.colors ?? config.colors;
    final size = this.size ?? config.size;

    return Stack(
      children: List.generate(colors.length, (index) {
        final alignments = [
          Alignment.topLeft,
          Alignment.topRight,
          Alignment.bottomLeft,
          Alignment.bottomRight,
          Alignment.center,
        ];
        final alignment = alignments[index % alignments.length];

        return Positioned.fill(
          child: BlobWidget(
            color: colors[index],
            size: size,
            alignment: alignment,
            config: config,
          ),
        );
      }),
    );
  }
}

class FloatingBlobBackground extends StatefulWidget {
  final List<Color>? colors;
  final double? size;
  final BlobConfig? config;

  const FloatingBlobBackground({
    super.key,
    this.colors,
    this.size,
    this.config,
  });

  @override
  State<FloatingBlobBackground> createState() => _FloatingBlobBackgroundState();
}

class _FloatingBlobBackgroundState extends State<FloatingBlobBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Offset> _startPositions;
  late List<Offset> _targetPositions;
  late Random _random;
  Size? _screenSize;

  @override
  void initState() {
    super.initState();
    _random = Random();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final config = widget.config ?? AppTheme.blobConfig;
    final numBlobs = config.numberOfBlobs;

    _controllers = List.generate(
      numBlobs,
      (index) =>
          AnimationController(duration: config.floatingDuration, vsync: this)
            ..repeat(reverse: true),
    );

    _startPositions = List.generate(numBlobs, (_) => Offset.zero);
    _targetPositions = List.generate(numBlobs, (_) => Offset.zero);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _generateTargetPositions();
  }

  void _generateTargetPositions() {
    if (_screenSize == null) return;

    final config = widget.config ?? AppTheme.blobConfig;
    final distance = config.maxFloatDistance;

    for (int i = 0; i < _startPositions.length; i++) {
      _startPositions[i] = Offset(
        _random.nextDouble() * _screenSize!.width,
        _random.nextDouble() * _screenSize!.height,
      );

      _targetPositions[i] = Offset(
        _startPositions[i].dx + (_random.nextDouble() - 0.5) * distance * 2,
        _startPositions[i].dy + (_random.nextDouble() - 0.5) * distance * 2,
      );

      _targetPositions[i] = Offset(
        _targetPositions[i].dx.clamp(0, _screenSize!.width),
        _targetPositions[i].dy.clamp(0, _screenSize!.height),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config ?? AppTheme.blobConfig;
    if (!config.enabled || !config.floatingEnabled) {
      return const SizedBox.shrink();
    }

    final colors = widget.colors ?? config.colors;
    final size = widget.size ?? config.size;

    return Stack(
      children: List.generate(_controllers.length, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            final currentPosition = Offset.lerp(
              _startPositions[index],
              _targetPositions[index],
              _controllers[index].value,
            )!;

            final blobSize = size * config.blobSizeVariation;

            return Positioned(
              left: currentPosition.dx - blobSize / 2,
              top: currentPosition.dy - blobSize / 2,
              child: Opacity(
                opacity: config.opacity,
                child: SizedBox(
                  width: blobSize,
                  height: blobSize,
                  child: CustomPaint(
                    painter: BlobPainter(
                      color: colors[index % colors.length],
                      animationValue:
                          _controllers[(index + 1) % _controllers.length].value,
                      numPoints: config.numPoints,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class BlobButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;
  final ShadowConfig? shadowConfig;

  const BlobButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.color,
    this.textColor,
    this.borderRadius,
    this.shadowConfig,
  });

  @override
  State<BlobButton> createState() => _BlobButtonState();
}

class _BlobButtonState extends State<BlobButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.primaryColor;
    final textColor = widget.textColor ?? CupertinoColors.white;
    final borderRadius = widget.borderRadius ?? AppTheme.borderRadiusMedium;
    final shadowConfig = widget.shadowConfig ?? AppTheme.shadowConfig;

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(_controller),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: shadowConfig.opacity),
                blurRadius: shadowConfig.blur,
                offset: Offset(shadowConfig.offsetX, shadowConfig.offsetY),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLarge,
            vertical: AppTheme.spacingMedium,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: textColor,
              fontWeight: AppTheme.fontWeightMedium,
              fontSize: AppTheme.fontSizeSmall,
            ),
          ),
        ),
      ),
    );
  }
}

class ThemedAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onPressed;
  final String actionText;

  const ThemedAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.onPressed,
    this.actionText = 'OK',
  });

  @override
  Widget build(BuildContext context) {
    final config = AppTheme.dialogConfig;

    return CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: config.titleColor,
          fontSize: AppTheme.fontSizeLarge,
          fontWeight: AppTheme.fontWeightMedium,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: config.contentColor,
          fontSize: AppTheme.fontSizeSmall,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          textStyle: TextStyle(
            color: config.actionColor,
            fontWeight: AppTheme.fontWeightMedium,
          ),
          onPressed: () {
            Navigator.pop(context);
            onPressed?.call();
          },
          child: Text(actionText),
        ),
      ],
    );
  }
}

class ThemedConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ThemedConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = AppTheme.dialogConfig;
    final confirmColor = isDestructive
        ? config.destructiveActionColor
        : config.actionColor;

    return CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: config.titleColor,
          fontSize: AppTheme.fontSizeLarge,
          fontWeight: AppTheme.fontWeightMedium,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: config.contentColor,
          fontSize: AppTheme.fontSizeSmall,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          textStyle: TextStyle(
            color: config.actionColor,
            fontWeight: AppTheme.fontWeightMedium,
          ),
          onPressed: () {
            Navigator.pop(context);
            onCancel?.call();
          },
          child: Text(cancelText),
        ),
        CupertinoDialogAction(
          textStyle: TextStyle(
            color: confirmColor,
            fontWeight: AppTheme.fontWeightMedium,
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm?.call();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}

class ThemedListSection extends StatelessWidget {
  final List<Widget> children;
  final Widget? header;
  final Color? backgroundColor;
  final double? borderRadius;
  final bool enableBlobBackground;

  const ThemedListSection({
    super.key,
    required this.children,
    this.header,
    this.backgroundColor,
    this.borderRadius,
    this.enableBlobBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? AppTheme.surfaceColor.withValues(alpha: 0.7);
    final radius = borderRadius ?? AppTheme.borderRadiusMedium;

    return Stack(
      children: [
        if (enableBlobBackground)
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMedium,
                vertical: AppTheme.spacingSmall,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
              ),
              child: MultiColorBlobBackground(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.3),
                  AppTheme.accentColor.withValues(alpha: 0.2),
                ],
                size: 120.0,
                config: AppTheme.blobConfig.copyWith(opacity: 0.06),
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMedium,
            vertical: AppTheme.spacingSmall,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppTheme.borderColor, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (header != null)
                Padding(
                  padding: EdgeInsets.all(AppTheme.spacingMedium),
                  child: DefaultTextStyle(
                    style: AppTheme.labelMedium,
                    child: header!,
                  ),
                ),
              ...children,
            ],
          ),
        ),
      ],
    );
  }
}
