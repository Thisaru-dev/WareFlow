class SupplierModel {
  final String supplierId;
  final String supplierName;
  final String contact;
  final String email;
  final String address;

  SupplierModel({
    required this.supplierId,
    required this.supplierName,
    required this.contact,
    required this.email,
    required this.address,
  });
  Map<String, dynamic> toMap() {
    return {
      'supplierId': supplierId,
      'supplierName': supplierName,
      'contact': contact,
      'email': email,
      'address': address,
    };
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      supplierId: map['supplierId'] ?? '',
      supplierName: map['supplierName'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
