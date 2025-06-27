import 'package:flutter/material.dart';
import 'package:wareflow/models/package_model.dart';
import 'package:wareflow/models/so_item_model.dart';
import 'package:wareflow/services/log_service.dart';
import 'package:wareflow/services/package_service.dart';

class PackageProvider extends ChangeNotifier {
  List<SoItemModel> _items = [];
  String _packageId = '';
  String _soId = '';
  String _companyId = '';
  String _createdBy = '';
  String _warehouseId = '';
  DateTime _packageDate = DateTime.now();
  String _packageNote = '';
  String _packageStatus = '';
  //state
  final Map<String, PackageModel> _packages = {};
  //getter
  Map<String, PackageModel> get packages {
    return {..._packages};
  }

  List<SoItemModel> get items => _items;
  //add items to
  void addItem(List<SoItemModel> item) {
    _items = item;
    print("Items:${_items.first.itemId}");
    notifyListeners();
  }

  //getters
  String get packageId => _packageId;
  String get salesOrderId => _soId;
  String get companyId => _companyId;
  String get warehouseId => _warehouseId;
  DateTime get packageDate => _packageDate;
  String get packageNote => _packageNote;
  String get packageStatus => _packageStatus;
  String get createdBy => _createdBy;
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
  }) async {
    await PackageService().createPackage(
      packageId: packageId,
      soId: soId,
      companyId: companyId,
      warehouseId: warehouseId,
      createdBy: createdBy,
      packageNote: packageNote,
      packageDate: packageDate,
      packageStatus: packageStatus,
      items: _items,
    );
    await LogService().logPackage(
      action: "created",
      createdBy: createdBy,
      companyId: "no",
      warehouseId: "no",
      soId: soId,
      extraDetails: {},
    );
    notifyListeners();
  }

  //set selected packages
  void setSelectedPackages({
    required String packageId,
    required String soId,
    required String companyId,
    required String warehouseId,
    required String createdBy,
    required DateTime packageDate,
    required String packageNote,
    required String packageStatus,
  }) {
    _packages[packageId] = PackageModel(
      packageId: packageId,
      soId: soId,
      companyId: companyId,
      warehouseId: warehouseId,
      createdBy: createdBy,
      packageDate: packageDate,
      packageNote: packageNote,
      packageStatus: packageStatus,
    );
    _packageId = packageId;
    _soId = soId;
    _companyId = companyId;
    _warehouseId = warehouseId;
    _createdBy = createdBy;
    _packageDate = packageDate;
    _packageNote = packageNote;
    _packageStatus = packageStatus;
    notifyListeners();
  }

  // remove a package
  void remove(String packageId) {
    _packages.remove(packageId);
    notifyListeners();
  }

  //get packages as a List
  List<PackageModel> get selectedPackages {
    return _packages.values.map((e) {
      return PackageModel(
        packageId: e.packageId,
        soId: e.soId,
        companyId: e.companyId,
        warehouseId: e.warehouseId,
        createdBy: e.createdBy,
        packageDate: e.packageDate,
        packageNote: e.packageNote,
        packageStatus: e.packageStatus,
      );
    }).toList();
  }

  //clear all
  void clearAll() {
    _packages.clear();
    _items = [];
    _packageId = '';
    _soId = '';
    _companyId = '';
    _warehouseId = '';
    _packageDate = DateTime.now();
    _packageNote = '';
    _packageStatus = '';
    notifyListeners();
  }
}
