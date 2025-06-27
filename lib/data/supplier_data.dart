import 'package:wareflow/models/supplier_model.dart';

class SupplierData {
  static List<SupplierModel> getSupplierData() {
    return [
      SupplierModel(
        supplierId: "1",
        supplierName: "sup1",
        email: "thisarukalpana01@gmail.com",
        address: "Beijin, china",
        contact: "Bearings,Welding rods",
      ),
      SupplierModel(
        supplierId: "2",
        supplierName: "sup2",
        email: "thisarukalpana5@gmail.com",
        address: "chicago",
        contact: "Gear motors",
      ),
    ];
  }
}
