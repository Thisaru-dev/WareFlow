class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String contact;
  final String address;
  final String organizationId;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
    required this.organizationId,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'address': address,
      'companyId': organizationId,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      contact: map['contact'] ?? '',
      address: map['address'] ?? '',
      organizationId: map['companyId'] ?? '',
    );
  }
}
