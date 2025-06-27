import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/dispatch_model.dart';
import 'package:wareflow/models/package_model.dart';

class DispatchService {
  //reference
  final docRef = FirebaseFirestore.instance.collection('dispatches');
  //create dispatch
  Future<void> createDispatch({
    required String dispatchId,
    required String companyId,
    required String warehouseId,
    required String soId,
    required DateTime dispatchDate,
    required String dispatchNote,
    required String dispatchStatus,
    required List<PackageModel> packages,
  }) async {
    final dispatch = DispatchModel(
      dispatchId: dispatchId,
      companyId: companyId,
      warehouseId: warehouseId,
      soId: soId,
      dispatchDate: dispatchDate,
      dispatchNote: dispatchNote,
      dispatchStatus: dispatchStatus,
    );
    //add dispatch
    await docRef.doc(dispatchId).set(dispatch.toMap());
    //add packages
    for (var pack in packages) {
      await docRef
          .doc(dispatchId)
          .collection('packages')
          .doc(pack.packageId)
          .set(pack.toMap());
    }
    print('dispatch created successfully');
  }
}
