import 'package:flutter/material.dart';
import 'package:wareflow/models/so_item_model.dart';

class SoItemProvider extends ChangeNotifier {
  String? _selectedItemId;
  String? _selectedItemName;
  double? _selectedItemPrice;
  int? _selectedItemOrderedQty;

  // so_item state
  final Map<dynamic, SoItemModel> _soItems = {};
  //getter
  Map<dynamic, SoItemModel> get soItems {
    return {..._soItems};
  }

  //getters
  String? get selectedItemId => _selectedItemId;
  String? get selectedItemName => _selectedItemName;
  double? get selectedItemPrice => _selectedItemPrice;
  int? get selectedItemOrderedQty => _selectedItemOrderedQty;

  //setSelectedItems
  void setSelectedItems(
    String id,
    String itemName,
    String image,
    double price,
    int orderedQty,
  ) {
    _soItems[id] = SoItemModel(
      itemId: id,
      itemName: itemName,
      image: image,
      orderedQty: orderedQty,
      unitPrice: price,
    );
    _selectedItemId = id;
    _selectedItemName = itemName;
    _selectedItemPrice = price;
    _selectedItemOrderedQty = orderedQty;

    notifyListeners();
  }

  //add item
  void addItem(
    String id,
    String name,
    String img,
    int orderedQty,
    double price,
  ) {
    if (_soItems.containsKey(id)) {
      _soItems.update(
        id,
        (existingItem) => SoItemModel(
          itemId: existingItem.itemId,
          itemName: existingItem.itemName,
          image: existingItem.image,
          orderedQty: orderedQty,
          unitPrice: existingItem.unitPrice,
        ),
      );
      print("Add existing data qnt:${soItems[id]!.orderedQty}");
    } else {
      _soItems.putIfAbsent(
        id,
        () => SoItemModel(
          itemId: id,
          itemName: name,
          image: img,
          orderedQty: orderedQty,
          unitPrice: price,
        ),
      );
      print("Add new data qnt :${soItems[id]!.orderedQty}}");
    }
    notifyListeners();
  }

  //remove selected item
  void removeItem(String id) {
    _soItems.remove(id);
    notifyListeners();
  }

  //remove quantity of a item
  void removeSingleItem(String id) {
    if (!_soItems.containsKey(id)) {
      return;
    }
    if (_soItems[id]!.orderedQty > 1) {
      _soItems.update(
        id,
        (existingSelectedItem) => SoItemModel(
          itemId: existingSelectedItem.itemId,
          itemName: existingSelectedItem.itemName,
          image: existingSelectedItem.image,
          orderedQty: existingSelectedItem.orderedQty - 1,
          unitPrice: existingSelectedItem.unitPrice,
        ),
      );
    } else {
      _soItems.remove(id);
    }
    notifyListeners();
  }

  //clear all items
  void clear() {
    _soItems.clear();
    notifyListeners();
  }

  //get items as a poList
  List<SoItemModel> get selectedItems {
    return _soItems.values.map((e) {
      return SoItemModel(
        itemId: e.itemId,
        itemName: e.itemName,
        image: e.image,
        orderedQty: e.orderedQty,
        unitPrice: e.unitPrice,
      );
    }).toList();
  }
}
