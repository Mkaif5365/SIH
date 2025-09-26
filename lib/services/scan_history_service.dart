import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scan_history_model.dart';

class ScanHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add scan history
  Future<String> addScanHistory(ScanHistoryModel scanHistory) async {
    try {
      DocumentReference docRef = await _firestore.collection('scanHistory').add(scanHistory.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add scan history: $e');
    }
  }

  // Get scan history by inspector ID
  Stream<List<ScanHistoryModel>> getScanHistoryByInspector(String inspectorId) {
    return _firestore
        .collection('scanHistory')
        .where('inspectorId', isEqualTo: inspectorId)
        .orderBy('scannedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScanHistoryModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Update scan history
  Future<void> updateScanHistory(String scanId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('scanHistory').doc(scanId).update(updates);
    } catch (e) {
      throw Exception('Failed to update scan history: $e');
    }
  }
}