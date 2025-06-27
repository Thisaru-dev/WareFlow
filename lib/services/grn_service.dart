import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/grn_item_model.dart';
import 'package:wareflow/models/grn_model.dart';

class GrnService {
  final ref = FirebaseFirestore.instance.collection('grns');

  Future<void> createGrn({
    required String grnId,
    required String poId,
    required String companyId,
    required String warehouseId,
    required DateTime grnDate,
    required String grnNote,
    required String status,
    required DateTime qcDate,
    required String qcNote,
    required String qcStatus,
    required DateTime approvalDate,
    required List<GrnItemModel> items,
  }) async {
    final grn = GrnModel(
      grnId: grnId,
      poId: poId,
      companyId: companyId,
      warehouseId: warehouseId,
      grnDate: grnDate,
      grnNote: grnNote,
      status: status,
      qcDate: qcDate,
      qcNote: qcNote,
      qcStatus: qcStatus,
      approvalDate: approvalDate,
    );
    //add grn to firestore
    await ref.doc(grnId).set(grn.toMap());
    //add items to grn
    for (var item in items) {
      await ref
          .doc(grnId)
          .collection('items')
          .doc(item.itemId)
          .set(item.toMap());
    }
    print('GRN created succesfully');
  }
}
