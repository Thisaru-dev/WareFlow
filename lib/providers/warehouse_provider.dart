import 'package:flutter/material.dart';
import 'package:wareflow/models/warehouse_model.dart';

class WarehouseProvider extends ChangeNotifier {
  String? _warehouseId;
  String? _warehouseName;
  String? _location;

  // warehouse state
  final Map<String, WarehouseModel> _warehouses = {};
  //getter
  Map<String, WarehouseModel> get warehouses {
    return {..._warehouses};
  }

  // set selected warehouse
  void setSelectedWarehouse({
    required String id,
    required String name,
    required String location,
    required String address,
    required String contact,
    required String companyId,
  }) {
    _warehouses[id] = WarehouseModel(
      id: id,
      name: name,
      location: location,
      address: address,
      contact: contact,
      companyId: companyId,
    );
    _warehouseId = id;
    _warehouseName = name;
    _location = location;

    notifyListeners();
  }

  // clear selected warehouse
  void clearSelectedWarehouse() {
    _warehouses.clear();
    _warehouseId = null;
    _warehouseName = null;
    _location = null;
    notifyListeners();
  }

  //getters
  String? get warehouseId => _warehouseId;
  String? get warehouseName => _warehouseName;
  String? get warehouseLocation => _location;
}
