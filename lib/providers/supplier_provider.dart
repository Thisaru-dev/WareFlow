import 'package:flutter/material.dart';
import 'package:wareflow/models/supplier_model.dart';

class SupplierProvider extends ChangeNotifier {
  String _supplierId = '';
  String _supplierName = '';
  String _supplierEmail = '';
  String _supplierAddress = '';
  String _contact = '';
  //supplier state
  final Map<String, SupplierModel> _suppliers = {};
  //getter
  Map<String, SupplierModel> get suppliers {
    return {..._suppliers};
  }

  // set the selected supplier
  void setSelectedSupplier(
    String id,
    String name,
    String email,
    String address,
    String contact,
  ) {
    _suppliers[id] = SupplierModel(
      supplierId: id,
      supplierName: name,
      email: email,
      address: address,
      contact: contact,
    );
    _supplierId = id;
    _supplierName = name;
    _supplierEmail = email;
    _supplierAddress = address;
    _contact = contact;

    print("id $id name $name");
    notifyListeners();
  }

  // getters
  String get selectedSupplierId => _supplierId;
  String get selectedSupplierName => _supplierName;
  String get selectedSupplierEmail => _supplierEmail;
  String get selectedSupplierAddress => _supplierAddress;
  String get selectedSupplierContact => _contact;

  //clear selected supplier
  void clearSelectedSupplier() {
    _suppliers.clear();
    _supplierId = '';
    _supplierName = '';
    _supplierEmail = '';
    _supplierAddress = '';
    _contact = '';
    notifyListeners();
  }
}
