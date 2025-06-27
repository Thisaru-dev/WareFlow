import 'package:flutter/material.dart';
import 'package:wareflow/models/po_item_model.dart';
import 'package:wareflow/models/returnable_item_model.dart';
import 'package:wareflow/services/item_service.dart';

class ItemProvider extends ChangeNotifier {
  List<PoItemModel> _items = [];
  List<ReturnableItemModel> _returnambleItems = [];
  void addItems({required List<PoItemModel> items}) {
    _items = items;
  }

  void addReturnbleItems({required List<ReturnableItemModel> items}) {
    _returnambleItems = items;
  }

  //create new item
  Future<void> createItem({
    required String id,
    required String img,
    required String name,
    required int quantity,
    required double price,
    required String supplierId,
    required String category,
    required String description,
    required String companyId,
    required int lowStockThreshold,
    required Map<String, int> warehouseQuantities,
  }) async {
    await ItemService().createNewItem(
      id: id,
      img: img,
      name: name,
      quantity: quantity,
      price: price,
      supplierId: supplierId,
      category: category,
      description: description,
      companyId: companyId,
      lowStockThreshold: lowStockThreshold,
      warehouseQuantities: warehouseQuantities,
    );
    notifyListeners();
  }

  //updateQty
  Future<void> updateItemsQty({required String warehouseId}) async {
    await ItemService().updateItemsQty(
      warehouseId: warehouseId,
      itemUpdates:
          _items
              .map(
                (item) => {
                  'itemId': item.itemId,
                  'qtyChange':
                      item.orderedQty, // or -item.quantity for subtraction
                },
              )
              .toList(),
    );
    notifyListeners();
  }

  //updateQty for return items
  Future<void> updateItemsQtyinReturns({required String warehouseId}) async {
    await ItemService().updateItemsQty(
      warehouseId: warehouseId,
      itemUpdates:
          _returnambleItems
              .map(
                (item) => {
                  'itemId': item.itemId,
                  'qtyChange':
                      item.returnQty, // or -item.quantity for subtraction
                },
              )
              .toList(),
    );
    notifyListeners();
  }

  Future<void> decreaseQty({
    required String warehouseId,
    required List<String> packageIds,
  }) async {
    await ItemService().decreaseItemsQtyFromPackages(
      packageIds: packageIds,
      warehouseId: warehouseId,
    );
    notifyListeners();
  }
}
