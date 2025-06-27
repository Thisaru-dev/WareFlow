class ReturnableItemModel {
  final String itemId;
  final String itemName;
  final String image;
  final int orderedQty;
  final int returnQty;
  final String reason;
  final double unitPrice;

  ReturnableItemModel({
    required this.itemId,
    required this.itemName,
    required this.image,
    required this.orderedQty,
    required this.returnQty,
    required this.reason,
    required this.unitPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'image': image,
      'orderedQty': orderedQty.toInt(),
      'returnQty': returnQty.toInt(),
      'reason': reason,
      'unitPrice': unitPrice.toDouble(),
    };
  }
}
