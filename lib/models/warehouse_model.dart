class WarehouseModel {
  final String id;
  final String name;
  final String location;
  final String address;
  final String contact;
  final String companyId;
  WarehouseModel({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.contact,
    required this.companyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'address': address,
      'contact': contact,
      'companyId': companyId,
    };
  }

  factory WarehouseModel.fromMap(Map<String, dynamic> map) {
    return WarehouseModel(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      address: map['address'],
      contact: map['contact'],
      companyId: map['comapnyId'],
    );
  }
}
