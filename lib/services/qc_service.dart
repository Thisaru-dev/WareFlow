import 'package:cloud_firestore/cloud_firestore.dart';

class QcService {
  // update grn after qc
  Future<void> updareGRN({
    required String grnId,
    required String qcStatus,
    required DateTime qcDate,
    required String qcNote,
    required List<Map<String, dynamic>> itemIssued,
  }) async {
    final grnRef = FirebaseFirestore.instance.collection('grns').doc(grnId);
    final prItemRef = grnRef.collection('items');
    final batch = FirebaseFirestore.instance.batch();
    // update grn status
    batch.update(grnRef, {
      'qcStatus': qcStatus,
      'qcNote': qcNote,
      'qcDate': qcDate.toIso8601String(),
    });
    // update items with issues
    for (var item in itemIssued) {
      final String itemId = item['itemId'];
      final itemDoc = prItemRef.doc(itemId);

      batch.update(itemDoc, {
        'quantityIssuesQty': item['quantityIssuesQty'] ?? 0,
        'qualityIssuesQty': item['qualityIssuesQty'] ?? 0,
        'wrongItemsQty': item['wrongItemsQty'] ?? 0,
      });
    }
    try {
      await batch.commit();
      print("pr updated after inspection");
    } catch (e) {
      print("error during inpection update");
      rethrow;
    }
  }
}
