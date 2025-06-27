class PoItemModel {
  final String itemId;
  final String itemName;
  final String image;
  final int orderedQty;
  final int receivedQty;
  final double unitPrice;

  PoItemModel({
    required this.itemId,
    required this.itemName,
    required this.image,
    required this.orderedQty,
    required this.receivedQty,
    required this.unitPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'image': image,
      'orderedQty': orderedQty,
      'receivedQty': receivedQty,
      'unitPrice': unitPrice,
    };
  }

  factory PoItemModel.fromMap(Map<String, dynamic> map) {
    return PoItemModel(
      itemId: map['itemId'],
      itemName: map['itemName'],
      image: map['image'],
      orderedQty: map['orderedQty'],
      receivedQty: map['receivedQty'],
      unitPrice: (map['unitPrice'] as num).toDouble(),
    );
  }
}
