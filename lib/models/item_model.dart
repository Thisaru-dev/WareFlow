class ItemModel {
  final String id;
  final String img;
  final String name;
  final int quantity;
  final double price;
  final String supplierId;
  final String category;
  final String description;
  final String companyId;
  final int lowStockThreshold;
  final Map<String, dynamic> warehouseQuantities;

  ItemModel({
    required this.id,
    required this.img,
    required this.name,
    required this.quantity,
    required this.price,
    required this.supplierId,
    required this.category,
    required this.description,
    required this.companyId,
    required this.lowStockThreshold,
    required this.warehouseQuantities,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'img': img,
      'name': name,
      'quantity': quantity,
      'price': price,
      'supplierId': supplierId,
      'category': category,
      'description': description,
      'companyId': companyId,
      'lowStockThreshold': lowStockThreshold,
      'warehouseQuantities': warehouseQuantities,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? '',
      img: map['img'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] as num).toDouble(),
      supplierId: map['supplierId'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      companyId: map['companyId'] ?? '',
      lowStockThreshold: map['lowStockThreshold'] ?? 0,
      warehouseQuantities: Map<String, dynamic>.from(
        map['warehouseQuantities'] ?? {},
      ),
    );
  }
}
