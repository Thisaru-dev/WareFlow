class SoItemModel {
  final String itemId;
  final String itemName;
  final String image;
  final int orderedQty;
  final double unitPrice;

  SoItemModel({
    required this.itemId,
    required this.itemName,
    required this.image,
    required this.orderedQty,
    required this.unitPrice,
  });
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'image': image,
      'orderedQty': orderedQty,
      'unitPrice': unitPrice,
    };
  }

  factory SoItemModel.fromMap(Map<String, dynamic> map) {
    return SoItemModel(
      itemId: map['itemId'] ?? '',
      itemName: map['itemName'] ?? '',
      image: map['image'] ?? '',
      orderedQty: map['orderedQty'] ?? 0,
      unitPrice: (map['unitPrice'] as num).toDouble(),
    );
  }
}
