import 'package:flutter/material.dart';
import 'package:wareflow/models/package_model.dart';
import 'package:wareflow/services/dispatch_service.dart';

class DispatchProvider extends ChangeNotifier {
  List<PackageModel> _packages = [];

  //add packages
  void addPackages(List<PackageModel> packages) {
    _packages = packages;
    print('packages added');
    notifyListeners();
  }

  //create dispatch
  Future<void> createDispatch({
    required String dispatchId,
    required String companyId,
    required String warehouseId,
    required String soId,
    required DateTime dispatchDate,
    required String dispatchNote,
    required String dispatchStatus,
  }) async {
    await DispatchService().createDispatch(
      dispatchId: dispatchId,
      companyId: companyId,
      warehouseId: warehouseId,
      soId: soId,
      dispatchDate: dispatchDate,
      dispatchNote: dispatchNote,
      dispatchStatus: dispatchStatus,
      packages: _packages,
    );
  }

  //get package ids
  List<String> get packageIds {
    return _packages.map((pkg) => pkg.packageId).toList();
  }
}
