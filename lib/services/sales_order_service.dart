import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/so_item_model.dart';
import 'package:wareflow/models/so_model.dart';

class SalesOrderService {
  // references
  final soRef = FirebaseFirestore.instance.collection('sales_orders');
  //create purchase order
  Future<void> createSalesOrder({
    required String soId,
    required String customerId,
    required String customerName,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required DateTime expectedDate,
    required String notes,
    required double totalAmount,
    required List<SoItemModel> items,
  }) async {
    if (customerId.isEmpty || items.isEmpty) {
      throw Exception('Customer and items are required.');
    }

    final so = SalesOrderModel(
      soId: soId,
      customerId: customerId,
      customerName: customerName,
      createdBy: createdBy,
      companyId: companyId,
      warehouseId: warehouseId,
      createdAt: DateTime.now(),
      expectedDate: expectedDate,
      notes: notes,
      status: "PENDING",
      totalAmount: totalAmount,
      approvaldate: DateTime(0000, 00, 00),
    );
    //add po to firestore
    await soRef.doc(soId).set(so.toMap());
    //add items to firestore
    for (var item in items) {
      await soRef
          .doc(soId)
          .collection('items')
          .doc(item.itemId)
          .set(item.toMap());
    }
    print("so created successfully");
  }

  Future<void> deleteSalesOrder(String salesOrderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('sales_orders')
          .doc(salesOrderId)
          .delete();
      print("Sales order $salesOrderId deleted successfully.");
    } catch (e) {
      print("Error deleting sales order: $e");
    }
  }

  // //edit SO
  // Future<void> editSalesOrder({
  //   required String soId,
  //   required String customerName,
  //   required String notes,
  //   required String customerId,

  // }) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('sales_orders')
  //         .doc(soId)
  //         .update({
  //           'customerName': customerName,
  //           'totalAmount': totalAmount,
  //           'status': status,
  //           'createdAt': createdAt.toIso8601String(),
  //         });
  //   } catch (e) {
  //     print("Error updating sales order: $e");
  //     rethrow;
  //   }
  // }
}
