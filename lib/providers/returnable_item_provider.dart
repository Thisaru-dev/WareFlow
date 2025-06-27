import 'package:flutter/material.dart';
import 'package:wareflow/models/returnable_item_model.dart';

class ReturnableItemProvider extends ChangeNotifier {
  String _itemId = '';
  String _itemName = '';
  String _image = '';
  int _orderedQty = 0;
  int _returnQty = 0;
  String _reason = '';
  double _unitPrice = 0;

  // Returnable_item state
  final Map<dynamic, ReturnableItemModel> _returnableItems = {};
  //getter
  Map<dynamic, ReturnableItemModel> get returnableItems {
    return {..._returnableItems};
  }
  //getters

  String get itemId => _itemId;
  String get itemName => _itemName;
  String get image => _image;
  int get orderedQty => _orderedQty;
  int get returnQty => _returnQty;
  String get reason => _reason;
  double get unitPrice => _unitPrice;

  // issues list
  // List<QcIssuesModel> issueList = [];
  // //get issues
  // List<QcIssuesModel> get issues => issueList;
  // //add issues
  // void addIssue(
  //   String itemId,
  //   int quantityIssueQty,
  //   int qualityIssueQty,
  //   int wrongItemsQty,
  // ) {
  //   final index = issueList.indexWhere((e) => e.itemId == itemId);
  //   if (index != -1) {
  //     issueList[index] = QcIssuesModel(
  //       itemId: itemId,
  //       quantityIssueQty: quantityIssueQty,
  //       qualityIssueQty: qualityIssueQty,
  //       wrongItemsQty: wrongItemsQty,
  //     );
  //   } else {
  //     issueList.add(
  //       QcIssuesModel(
  //         itemId: itemId,
  //         quantityIssueQty: quantityIssueQty,
  //         qualityIssueQty: qualityIssueQty,
  //         wrongItemsQty: wrongItemsQty,
  //       ),
  //     );
  //   }
  //   notifyListeners();
  // }

  void setSelectedItems(
    String itemId,
    String itemName,
    String image,
    int orderedQty,
    int returnQty,
    String reason,
    double unitPrice,
  ) {
    _returnableItems[itemId] = ReturnableItemModel(
      itemId: itemId,
      itemName: itemName,
      image: image,
      orderedQty: orderedQty,
      returnQty: returnQty,
      reason: reason,
      unitPrice: unitPrice,
    );
    _itemId = itemId;
    _itemName = itemName;
    _image = image;
    _orderedQty = orderedQty;
    _returnQty = returnQty;
    _reason = reason;
    _unitPrice = unitPrice;

    notifyListeners();
  }

  //add item
  // void addItem(
  //   String itemId,
  //   String itemName,
  //   String image,
  //   int orderedQty,
  //   int receivedQty,
  //   int returnedQty,
  //   int quantityIssuesQty,
  //   int qualityIssuesQty,
  //   int wrongItemsQty,
  //   double unitPrice,
  // ) {
  //   if (_returnableItems.containsKey(itemId)) {
  //     _returnableItems.update(
  //       itemId,
  //       (existingItem) => ReturnableItemModel(
  //         itemId: existingItem.itemId,
  //         itemName: existingItem.itemName,
  //         image: existingItem.image,
  //         orderedQty: existingItem.orderedQty,
  //         receivedQty: existingItem.receivedQty,
  //         returnedQty: returnedQty,
  //         quantityIssuesQty: existingItem.quantityIssuesQty,
  //         qualityIssuesQty: existingItem.qualityIssuesQty,
  //         wrongItemsQty: existingItem.wrongItemsQty,
  //         unitPrice: existingItem.unitPrice,
  //       ),
  //     );
  //     print("Add existing data qnt:${returnableItems[itemId]!.returnedQty}");
  //   } else {
  //     _returnableItems.putIfAbsent(
  //       itemId,
  //       () => ReturnableItemModel(
  //         itemId: itemId,
  //         itemName: itemName,
  //         image: image,
  //         orderedQty: orderedQty,
  //         receivedQty: receivedQty,
  //         returnedQty: returnedQty,
  //         quantityIssuesQty: quantityIssuesQty,
  //         qualityIssuesQty: qualityIssuesQty,
  //         wrongItemsQty: wrongItemsQty,
  //         unitPrice: unitPrice,
  //       ),
  //     );
  //     print("Add new data qnt :${returnableItems[itemId]!.returnedQty}}");
  //   }
  //   notifyListeners();
  // }

  // //remove selected item
  // void removeItem(String id) {
  //   _returnableItems.remove(id);
  //   notifyListeners();
  // }

  // //remove quantity of a item
  // void removeSingleItem(String id) {
  //   if (!_returnableItems.containsKey(id)) {
  //     return;
  //   }
  //   if (_returnableItems[id]!.returnedQty > 1) {
  //     _returnableItems.update(
  //       id,
  //       (existingSelectedItem) => ReturnableItemModel(
  //         itemId: existingSelectedItem.itemId,
  //         itemName: existingSelectedItem.itemName,
  //         image: existingSelectedItem.image,
  //         orderedQty: existingSelectedItem.orderedQty,
  //         receivedQty: existingSelectedItem.receivedQty,
  //         quantityIssuesQty: existingSelectedItem.quantityIssuesQty,
  //         qualityIssuesQty: existingSelectedItem.qualityIssuesQty,
  //         wrongItemsQty: existingSelectedItem.wrongItemsQty,
  //         unitPrice: existingSelectedItem.unitPrice,
  //       ),
  //     );
  //   } else {
  //     _returnableItems.remove(id);
  //   }
  //   notifyListeners();
  // }

  //clear all items
  void clear() {
    _returnableItems.clear();
    notifyListeners();
  }

  // get items as a list
  List<ReturnableItemModel> get selectedItems {
    return _returnableItems.values.map((e) {
      return ReturnableItemModel(
        itemId: e.itemId,
        itemName: e.itemName,
        image: e.image,
        orderedQty: e.orderedQty,
        returnQty: e.returnQty,
        reason: e.reason,
        unitPrice: e.unitPrice,
      );
    }).toList();
  }
}
