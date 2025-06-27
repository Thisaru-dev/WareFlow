import 'package:flutter/material.dart';
import 'package:wareflow/models/po_item_model.dart';

class PoItemProvider extends ChangeNotifier {
  String? _selectedItemId;
  String? _selectedItemName;
  double? _selectedItemPrice;
  int? _selectedItemOrderedQty;
  int? _selectedItemReceivedQty;

  // po_item state
  final Map<dynamic, PoItemModel> _poItems = {};
  //getter
  Map<dynamic, PoItemModel> get poItems {
    return {..._poItems};
  }

  //getters
  String? get selectedItemId => _selectedItemId;
  String? get selectedItemName => _selectedItemName;
  double? get selectedItemPrice => _selectedItemPrice;
  int? get selectedItemOrderedQty => _selectedItemOrderedQty;
  int? get selectedItemReceivedQty => _selectedItemReceivedQty;

  //setSelectedItems
  void setSelectedItems(
    String id,
    String itemName,
    String image,
    double price,
    int orderedQty,
    int receivedQty,
  ) {
    _poItems[id] = PoItemModel(
      itemId: id,
      itemName: itemName,
      image: image,
      orderedQty: orderedQty,
      receivedQty: receivedQty,
      unitPrice: price,
    );
    _selectedItemId = id;
    _selectedItemName = itemName;
    _selectedItemPrice = price;
    _selectedItemOrderedQty = orderedQty;
    _selectedItemReceivedQty = receivedQty;

    notifyListeners();
  }

  //add item
  void addItem(
    String id,
    String name,
    String img,
    int orderedQty,
    int receivedQty,
    double price,
  ) {
    if (_poItems.containsKey(id)) {
      _poItems.update(
        id,
        (existingItem) => PoItemModel(
          itemId: existingItem.itemId,
          itemName: existingItem.itemName,
          image: existingItem.image,
          orderedQty: existingItem.orderedQty,
          receivedQty: receivedQty,
          unitPrice: existingItem.unitPrice,
        ),
      );
      print("Add existing data qnt:${poItems[id]!.receivedQty}");
    } else {
      _poItems.putIfAbsent(
        id,
        () => PoItemModel(
          itemId: id,
          itemName: name,
          image: img,
          orderedQty: orderedQty,
          receivedQty: receivedQty,
          unitPrice: price,
        ),
      );
      print("Add new data qnt :${poItems[id]!.receivedQty}}");
    }
    notifyListeners();
  }

  //remove selected item
  void removeItem(String id) {
    _poItems.remove(id);
    notifyListeners();
  }

  //remove quantity of a item
  void removeSingleItem(String id) {
    if (!_poItems.containsKey(id)) {
      return;
    }
    if (_poItems[id]!.receivedQty > 1) {
      _poItems.update(
        id,
        (existingSelectedItem) => PoItemModel(
          itemId: existingSelectedItem.itemId,
          itemName: existingSelectedItem.itemName,
          image: existingSelectedItem.image,
          orderedQty: existingSelectedItem.orderedQty,
          receivedQty: existingSelectedItem.receivedQty - 1,
          unitPrice: existingSelectedItem.unitPrice,
        ),
      );
    } else {
      _poItems.remove(id);
    }
    notifyListeners();
  }

  //clear all items
  void clear() {
    _poItems.clear();
    notifyListeners();
  }

  //get items as a poList
  List<PoItemModel> get selectedItems {
    return _poItems.values.map((e) {
      return PoItemModel(
        itemId: e.itemId,
        itemName: e.itemName,
        image: e.image,
        orderedQty: e.orderedQty,
        receivedQty: e.receivedQty,
        unitPrice: e.unitPrice,
      );
    }).toList();
  }
}
