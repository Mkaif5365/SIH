import 'package:cloud_firestore/cloud_firestore.dart';

class ScanHistoryModel {
  final String id;
  final String inspectorId;
  final String partId;
  final String partName;
  final String vendorName;
  final DateTime scannedAt;
  final String status;
  final String? remarks;
  final String? inspectionResult;
  final Map<String, dynamic>? inspectionData;

  ScanHistoryModel({
    required this.id,
    required this.inspectorId,
    required this.partId,
    required this.partName,
    required this.vendorName,
    required this.scannedAt,
    this.status = 'scanned',
    this.remarks,
    this.inspectionResult,
    this.inspectionData,
  });

  factory ScanHistoryModel.fromMap(Map<String, dynamic> data, String id) {
    return ScanHistoryModel(
      id: id,
      inspectorId: data['inspectorId'] ?? '',
      partId: data['partId'] ?? '',
      partName: data['partName'] ?? '',
      vendorName: data['vendorName'] ?? '',
      scannedAt: (data['scannedAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'scanned',
      remarks: data['remarks'],
      inspectionResult: data['inspectionResult'],
      inspectionData: data['inspectionData'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inspectorId': inspectorId,
      'partId': partId,
      'partName': partName,
      'vendorName': vendorName,
      'scannedAt': Timestamp.fromDate(scannedAt),
      'status': status,
      'remarks': remarks,
      'inspectionResult': inspectionResult,
      'inspectionData': inspectionData,
    };
  }
}