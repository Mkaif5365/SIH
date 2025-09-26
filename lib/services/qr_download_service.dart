import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class QRDownloadService {
  static Future<bool> downloadQRCode(GlobalKey qrKey, String partName) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        return false;
      }

      // Capture the QR code widget as image
      RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return false;
      
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Get downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      // Create file
      String fileName = 'QR_${partName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
      File file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(pngBytes);
      return true;
    } catch (e) {
      print('Error downloading QR code: $e');
      return false;
    }
  }
}