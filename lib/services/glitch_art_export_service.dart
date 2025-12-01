import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GlitchArtExportService {
  static Future<void> exportGlitchArt({
    required GlobalKey key,
    required String glitchArtId,
    required String amount,
  }) async {
    try {
      final RenderRepaintBoundary? boundary = 
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) return;
      
      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return;
      
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/glitch_art_$timestamp.png');
      
      await file.writeAsBytes(byteData.buffer.asUint8List());
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Glitch Art #$glitchArtId\nAmount: $amount\n\nGenerated with Glitch Receipt',
      );
    } catch (e) {
      // Silently handle export errors
    }
  }
}
