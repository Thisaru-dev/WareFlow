class QcIssuesModel {
  final String itemId;
  final int quantityIssueQty;
  final int qualityIssueQty;
  final int wrongItemsQty;

  QcIssuesModel({
    required this.itemId,
    required this.quantityIssueQty,
    required this.qualityIssueQty,
    required this.wrongItemsQty,
  });

  Map<String, dynamic> toMap() => {
    'itemId': itemId,
    'quantityIssuesQty': quantityIssueQty,
    'qualityIssuesQty': qualityIssueQty,
    'wrongItemsQty': wrongItemsQty,
  };
}
