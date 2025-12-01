import 'dart:math';
import 'package:flutter/material.dart';

class GlitchArtDisplay extends CustomPaint {
  GlitchArtDisplay({
    super.key,
    required String amount,
    required int seed,
    String? qrContent,
  }) : super(
    painter: _GlitchArtPainter(amount: amount, seed: seed, qrContent: qrContent),
    size: const Size(256, 256),
  );
}

class _GlitchArtPainter extends CustomPainter {
  final String amount;
  final int seed;
  final String? qrContent;

  _GlitchArtPainter({required this.amount, required this.seed, this.qrContent});

  @override
  void paint(Canvas canvas, Size size) {
    final sourceData = qrContent ?? amount;
    final colors = _extractColorsFromAmount(sourceData, seed);
    final random = Random(seed);

    final baseColor = Color.fromARGB(
      255,
      (colors[0] * 25.3).toInt().clamp(0, 255),
      (colors[1] * 25.3).toInt().clamp(0, 255),
      (colors[2] * 25.3).toInt().clamp(0, 255),
    );

    _drawGlitchBackground(canvas, baseColor, random, size);
    _drawGlitchPatterns(canvas, baseColor, random, size);
    _drawGlitchStripes(canvas, random, size);
    _drawNoise(canvas, random, size);
  }

  List<int> _extractColorsFromAmount(String amount, int seed) {
    final cleanAmount = amount.replaceAll(RegExp(r'[^\d]'), '');
    final digitList = cleanAmount.isEmpty ? [0] : cleanAmount.split('').map(int.parse).toList();

    while (digitList.length < 3) {
      digitList.add((seed + digitList.length) % 10);
    }

    return digitList.take(3).toList();
  }

  int _getColorComponent(Color color, int componentIndex) {
    switch (componentIndex) {
      case 0:
        return (color.r * 255.0).round() & 0xff;
      case 1:
        return (color.g * 255.0).round() & 0xff;
      case 2:
        return (color.b * 255.0).round() & 0xff;
      default:
        return 0;
    }
  }

  void _drawGlitchBackground(Canvas canvas, Color baseColor, Random random, Size size) {
    final paint = Paint()..color = baseColor;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    for (int i = 0; i < 5; i++) {
      final offsetX = random.nextDouble() * size.width * 0.2;
      final offsetY = random.nextDouble() * size.height;
      final width = random.nextDouble() * size.width * 0.3;
      final height = random.nextDouble() * size.height * 0.1;

      final baseR = _getColorComponent(baseColor, 0);
      final baseG = _getColorComponent(baseColor, 1);
      final baseB = _getColorComponent(baseColor, 2);

      final layerColor = Color.fromARGB(
        100 + random.nextInt(100),
        (baseR + random.nextInt(50) - 25).clamp(0, 255),
        (baseG + random.nextInt(50) - 25).clamp(0, 255),
        (baseB + random.nextInt(50) - 25).clamp(0, 255),
      );

      final layerPaint = Paint()..color = layerColor;
      canvas.drawRect(
        Rect.fromLTWH(offsetX, offsetY, width, height),
        layerPaint,
      );
    }
  }

  void _drawGlitchPatterns(Canvas canvas, Color baseColor, Random random, Size size) {
    final baseR = _getColorComponent(baseColor, 0);
    final baseG = _getColorComponent(baseColor, 1);
    final baseB = _getColorComponent(baseColor, 2);

    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final shapeSize = random.nextDouble() * 30 + 10;

      final patternColor = Color.fromARGB(
        150 + random.nextInt(105),
        (baseR + random.nextInt(80) - 40).clamp(0, 255),
        (baseG + random.nextInt(80) - 40).clamp(0, 255),
        (baseB + random.nextInt(80) - 40).clamp(0, 255),
      );

      final paint = Paint()
        ..color = patternColor
        ..strokeWidth = random.nextDouble() * 2 + 0.5
        ..style = random.nextBool() ? PaintingStyle.stroke : PaintingStyle.fill;

      final shapeType = random.nextInt(4);
      switch (shapeType) {
        case 0:
          canvas.drawCircle(Offset(x, y), shapeSize / 2, paint);
        case 1:
          canvas.drawRect(Rect.fromLTWH(x - shapeSize / 2, y - shapeSize / 2, shapeSize, shapeSize), paint);
        case 2:
          canvas.drawLine(
            Offset(x, y),
            Offset(x + shapeSize, y + shapeSize),
            paint,
          );
        default:
          canvas.drawOval(
            Rect.fromLTWH(x - shapeSize / 2, y - shapeSize / 4, shapeSize, shapeSize / 2),
            paint,
          );
      }
    }
  }

  void _drawGlitchStripes(Canvas canvas, Random random, Size size) {
    for (int i = 0; i < 8; i++) {
      final y = random.nextDouble() * size.height;
      final height = random.nextDouble() * 15 + 5;

      final stripColor = Color.fromARGB(
        80 + random.nextInt(120),
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );

      final paint = Paint()..color = stripColor;
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, height),
        paint,
      );
    }
  }

  void _drawNoise(Canvas canvas, Random random, Size size) {
    for (int i = 0; i < 500; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final noiseColor = Color.fromARGB(
        random.nextInt(200),
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );

      final paint = Paint()..color = noiseColor;
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(_GlitchArtPainter oldDelegate) {
    return oldDelegate.amount != amount || oldDelegate.seed != seed || oldDelegate.qrContent != qrContent;
  }
}
