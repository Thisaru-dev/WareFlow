import 'package:flutter/material.dart';
import 'package:wareflow/models/item_model.dart';
import 'package:wareflow/models/po_item_model.dart';

class StockInItemProvider extends ChangeNotifier {
  //stockinitem state
  final Map<String, ItemModel> _items = {};
  //getter
  Map<String, ItemModel> get items {
    return {..._items};
  }

  //add item
  void addItem(
    String id,
    String img,
    String title,
    int qnt,
    double price,
    String supplierId,
    String category,
    String description,
    String companyId,
    int lowStockThreshold,
    Map<String, dynamic> warehouseQuantities,
  ) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingItem) => ItemModel(
          id: existingItem.id,
          img: existingItem.img,
          name: existingItem.name,
          price: existingItem.price,
          quantity: qnt,
          supplierId: existingItem.supplierId,
          category: existingItem.category,
          description: existingItem.description,
          companyId: existingItem.companyId,
          lowStockThreshold: existingItem.lowStockThreshold,
          warehouseQuantities: existingItem.warehouseQuantities,
        ),
      );
      print("Add existing data qnt:${items[id]!.quantity}");
    } else {
      _items.putIfAbsent(
        id,
        () => ItemModel(
          id: id,
          img: img,
          name: title,
          quantity: qnt,
          price: price,
          supplierId: supplierId,
          category: category,
          description: description,
          companyId: companyId,
          lowStockThreshold: lowStockThreshold,
          warehouseQuantities: warehouseQuantities,
        ),
      );
      print("Add new data qnt :${items[id]!.quantity}}");
    }
    notifyListeners();
  }

  //remove selected item
  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  //remove quantity of a item
  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (existingSelectedItem) => ItemModel(
          id: existingSelectedItem.id,
          img: existingSelectedItem.img,
          name: existingSelectedItem.name,
          quantity: existingSelectedItem.quantity - 1,
          price: existingSelectedItem.price,
          supplierId: existingSelectedItem.supplierId,
          category: existingSelectedItem.category,
          description: existingSelectedItem.description,
          companyId: existingSelectedItem.companyId,
          lowStockThreshold: existingSelectedItem.lowStockThreshold,
          warehouseQuantities: existingSelectedItem.warehouseQuantities,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  //clear all items
  void clear() {
    _items.clear();
    notifyListeners();
  }

  //total amount
  double get totalAmount {
    var total = 0.0;
    _items.forEach((Key, items) {
      total += items.price * items.quantity;
    });

    return total;
  }

  //total quantity
  int get totalQty {
    var total = 0;
    _items.forEach((Key, items) {
      total += items.quantity;
    });
    return total;
  }

  //get items as a poList
  List<PoItemModel> get selectedItems {
    return _items.values.map((e) {
      return PoItemModel(
        itemId: e.id,
        itemName: e.name,
        image: e.img,
        orderedQty: e.quantity,
        receivedQty: 0,
        unitPrice: e.price,
      );
    }).toList();
  }

  //get items as a list
  List<ItemModel> get selectedItemsAsList {
    return _items.values.map((e) {
      return ItemModel(
        id: e.id,
        img: e.img,
        name: e.name,
        quantity: e.quantity,
        price: e.price,
        supplierId: e.supplierId,
        category: e.category,
        description: e.description,
        companyId: e.companyId,
        lowStockThreshold: e.lowStockThreshold,
        warehouseQuantities: e.warehouseQuantities,
      );
    }).toList();
  }
}
