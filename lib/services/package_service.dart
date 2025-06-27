import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/package_model.dart';
import 'package:wareflow/models/so_item_model.dart';

class PackageService {
  //reference
  final docRef = FirebaseFirestore.instance.collection('packages');
  //create package
  Future<void> createPackage({
    required String packageId,
    required String soId,
    required String companyId,
    required String warehouseId,
    required String createdBy,
    required DateTime packageDate,
    required String packageNote,
    required String packageStatus,
    required List<SoItemModel> items,
  }) async {
    final package = PackageModel(
      packageId: packageId,
      soId: soId,
      companyId: companyId,
      warehouseId: warehouseId,
      createdBy: createdBy,
      packageDate: packageDate,
      packageNote: packageNote,
      packageStatus: packageStatus,
    );
    //add package
    await docRef.doc(packageId).set(package.toMap());

    //add items to packages
    for (var item in items) {
      await docRef
          .doc(packageId)
          .collection('items')
          .doc(item.itemId)
          .set(item.toMap());
    }
    print('package created succesfully');
  }
}
