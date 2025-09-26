import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class QRDownloadService {
  // Request storage permission
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS doesn't need explicit permission for gallery
  }

  // Capture QR widget as image and save to gallery
  static Future<bool> downloadQRCode(GlobalKey qrKey, String partName) async {
    try {
      // Request permission first
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // Capture the QR widget as image
      RenderRepaintBoundary boundary = 
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        throw Exception('Failed to convert QR to image');
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to gallery
      final result = await ImageGallerySaver.saveImage(
        pngBytes,
        name: 'QRail_${partName}_${DateTime.now().millisecondsSinceEpoch}',
        quality: 100,
      );

      return result['isSuccess'] ?? false;
    } catch (e) {
      print('Error downloading QR: $e');
      return false;
    }
  }

  // Save QR to app documents directory
  static Future<String?> saveQRToDocuments(GlobalKey qrKey, String partName) async {
    try {
      RenderRepaintBoundary boundary = 
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return null;

      Uint8List pngBytes = byteData.buffer.asUint8List();
      
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'QRail_${partName}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(pngBytes);
      return file.path;
    } catch (e) {
      print('Error saving QR to documents: $e');
      return null;
    }
  }
}