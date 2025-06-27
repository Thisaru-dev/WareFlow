import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/item_model.dart';

class ItemService {
  final itemRef = FirebaseFirestore.instance.collection('items');
  Future<void> createNewItem({
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
    final item = ItemModel(
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
    try {
      await itemRef.doc(id).set(item.toMap());
      print('item created');
    } catch (e) {
      print("error during item creation");
    }
  }

  //update qty
  Future<void> updateItemsQty({
    required String warehouseId,
    required List<Map<String, dynamic>> itemUpdates,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var update in itemUpdates) {
      final itemRef = FirebaseFirestore.instance
          .collection('items')
          .doc(update['itemId']);
      final int qtyChange = update['qtyChange']; // can be +ve or -ve

      batch.update(itemRef, {
        'quantity': FieldValue.increment(qtyChange),
        'warehouseQuantities.$warehouseId': FieldValue.increment(qtyChange),
      });
    }

    await batch.commit();
    print('items qty incresed');
  }

  //decrease qty
  Future<void> decreaseItemsQtyFromPackages({
    required List<String> packageIds,
    required String warehouseId,
  }) async {
    final Map<String, int> itemTotals = {}; // itemId -> total qty

    for (String packageId in packageIds) {
      final doc =
          await FirebaseFirestore.instance
              .collection('packages')
              .doc(packageId)
              .collection('items')
              .get();

      for (var item in doc.docs) {
        final String itemId = item['itemId'];
        final int quantity = item['orderedQty'];

        itemTotals[itemId] = (itemTotals[itemId] ?? 0) + quantity;
      }
    }

    // Start batch update
    final batch = FirebaseFirestore.instance.batch();

    itemTotals.forEach((itemId, totalQty) {
      final itemRef = FirebaseFirestore.instance
          .collection('items')
          .doc(itemId);

      batch.update(itemRef, {
        'quantity': FieldValue.increment(-totalQty),
        'warehouseQuantities.$warehouseId': FieldValue.increment(-totalQty),
      });
    });

    await batch.commit();
    print('qnty decrease');
  }
}
