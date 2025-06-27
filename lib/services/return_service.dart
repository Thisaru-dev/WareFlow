import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/return_model.dart';
import 'package:wareflow/models/returnable_item_model.dart';

class ReturnService {
  //reference
  final docRef = FirebaseFirestore.instance.collection('returns');
  //create return
  Future<void> createReturn({
    required String id,
    required String type,
    required String companyId,
    required String warehouseId,
    required String referenceId,
    required String createdBy,
    required DateTime returnDate,
    required String note,
    required List<ReturnableItemModel> items,
  }) async {
    final r = ReturnModel(
      id: id,
      type: type,
      companyId: companyId,
      warehouseId: warehouseId,
      referenceId: referenceId,
      createdBy: createdBy,
      returnDate: returnDate,
      note: note,
    );
    await docRef.doc(id).set(r.toMap());
    //add items to return
    for (var item in items) {
      await docRef
          .doc(id)
          .collection('items')
          .doc(item.itemId)
          .set(item.toMap());
    }
    print('return created succesfully');
  }
}
