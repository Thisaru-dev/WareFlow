class GrnItemModel {
  final String itemId;
  final String itemName;
  final String image;
  final int orderedQty;
  final int receivedQty;
  final int quantityIssuesQty;
  final int qualityIssuesQty;
  final int wrongItemsQty;
  final double unitPrice;

  GrnItemModel({
    required this.itemId,
    required this.itemName,
    required this.image,
    required this.orderedQty,
    required this.receivedQty,
    required this.quantityIssuesQty,
    required this.qualityIssuesQty,
    required this.wrongItemsQty,
    required this.unitPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'image': image,
      'orderedQty': orderedQty,
      'receivedQty': receivedQty,
      'quantityIssuesQty': qualityIssuesQty,
      'qualityIssuesQty': qualityIssuesQty,
      'wrongItemsQty': wrongItemsQty,
      'unitPrice': unitPrice,
    };
  }

  factory GrnItemModel.fromMap(Map<String, dynamic> map) {
    return GrnItemModel(
      itemId: map['itemId'],
      itemName: map['itemName'],
      image: map['image'],
      orderedQty: map['orderedQty'],
      receivedQty: map['receivedQty'],
      quantityIssuesQty: map['quantityIssuesQty'],
      qualityIssuesQty: map['qualityIssuesQty'],
      wrongItemsQty: map['wrongItemsQty'],
      unitPrice: (map['unitPrice'] as num).toDouble(),
    );
  }
}
