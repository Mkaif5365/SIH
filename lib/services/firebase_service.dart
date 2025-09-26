import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/part_model.dart';
import '../models/scan_history_model.dart';
import '../models/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication
  static Future<UserModel?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print('Sign in error: $e');
    }
    return null;
  }

  static Future<UserModel?> registerWithEmailPassword(String email, String password, String name, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        UserModel newUser = UserModel(
          id: user.uid,
          name: name,
          email: email,
          role: role,
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      print('Registration error: $e');
    }
    return null;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Parts Management
  static Future<String> createPart(PartModel part) async {
    try {
      DocumentReference docRef = await _firestore.collection('parts').add(part.toMap());
      await docRef.update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      print('Create part error: $e');
      throw e;
    }
  }

  static Future<PartModel?> getPartById(String partId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('parts').doc(partId).get();
      if (doc.exists) {
        return PartModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Get part error: $e');
    }
    return null;
  }

  static Stream<List<PartModel>> getPartsByVendor(String vendorId) {
    return _firestore
        .collection('parts')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PartModel.fromMap(doc.data()))
            .toList());
  }

  static Future<void> updatePartStatus(String partId, String status) async {
    try {
      await _firestore.collection('parts').doc(partId).update({'status': status});
    } catch (e) {
      print('Update part status error: $e');
      throw e;
    }
  }

  // Scan History Management
  static Future<String> addScanHistory(ScanHistoryModel scanHistory) async {
    try {
      DocumentReference docRef = await _firestore.collection('scan_history').add(scanHistory.toMap());
      await docRef.update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      print('Add scan history error: $e');
      throw e;
    }
  }

  static Stream<List<ScanHistoryModel>> getScanHistoryByInspector(String inspectorId) {
    return _firestore
        .collection('scan_history')
        .where('inspectorId', isEqualTo: inspectorId)
        .orderBy('scannedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScanHistoryModel.fromMap(doc.data()))
            .toList());
  }

  static Future<void> updateScanHistory(String scanId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('scan_history').doc(scanId).update(updates);
    } catch (e) {
      print('Update scan history error: $e');
      throw e;
    }
  }
}