import '../models/part_model.dart';
import 'firebase_service.dart';

class PartsService {
  Future<String> createPart(PartModel part) async {
    return await FirebaseService.createPart(part);
  }

  Future<PartModel?> getPartById(String partId) async {
    return await FirebaseService.getPartById(partId);
  }

  Stream<List<PartModel>> getPartsByVendor(String vendorId) {
    return FirebaseService.getPartsByVendor(vendorId);
  }

  Future<void> updatePartStatus(String partId, String status) async {
    return await FirebaseService.updatePartStatus(partId, status);
  }
}