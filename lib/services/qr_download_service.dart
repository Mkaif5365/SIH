import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class QRDownloadService {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
    return true;
  }

  static Future<String?> downloadQRCode(GlobalKey qrKey, String partName) async {
    try {
      // Request permission first
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        return null;
      }

      // Capture QR code as image
      RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return null;
      
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Get download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) return null;

      // Create unique filename
      String fileName = 'QR_${partName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
      File file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(pngBytes);
      return file.path;
    } catch (e) {
      print('Error downloading QR code: $e');
      return null;
    }
  }
}