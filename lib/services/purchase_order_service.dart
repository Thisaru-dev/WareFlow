import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/po_item_model.dart';
import 'package:wareflow/models/po_model.dart';

class PurchaseOrderService {
  // references
  final poRef = FirebaseFirestore.instance.collection('purchase_orders');
  //create purchase order
  Future<void> createPurchaseOrder(
    String customDocId,
    String supplierId,
    String supplierName,
    String createdBy,
    String companyId,
    DateTime expectedDate,
    String notes,
    List<PoItemModel> items,
    double totalAmount,
    String warehouseId,
  ) async {
    if (supplierId.isEmpty || items.isEmpty) {
      throw Exception('Supplier and items are required.');
    }

    final po = PurchaseOrderModel(
      poId: customDocId,
      supplierId: supplierId,
      supplierName: supplierName,
      createdBy: createdBy,
      companyId: companyId,
      createdAt: DateTime.now(),
      expectedDate: expectedDate,
      notes: notes,
      status: 'PENDING',
      totalAmount: totalAmount,
      warehouseId: warehouseId,
      approvalDate: DateTime(0000, 00, 00),
    );
    //add po to firestore
    await poRef.doc(customDocId).set(po.toMap());
    //add items to firestore
    for (var item in items) {
      await poRef
          .doc(customDocId)
          .collection('items')
          .doc(item.itemId)
          .set(item.toMap());
    }
    print("po created successfully");
  }

  //update po item received qty
  Future<void> updateReceivedQty(String poId, List<PoItemModel> items) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final item in items) {
      final docRef = FirebaseFirestore.instance
          .collection('purchase_orders')
          .doc(poId)
          .collection('items')
          .doc(item.itemId);
      batch.update(docRef, {
        'receivedQty': FieldValue.increment(item.receivedQty),
      });
    }
    await batch.commit();
  }

  //delete purchase order
  Future<void> deletePurchaseOrder(String poId) async {
    try {
      await FirebaseFirestore.instance
          .collection('purchase_orders')
          .doc(poId)
          .delete();
      print("Sales order $poId deleted successfully.");
    } catch (e) {
      print("Error deleting sales order: $e");
    }
  }
}
