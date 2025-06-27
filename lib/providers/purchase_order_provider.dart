import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wareflow/models/po_item_model.dart';
import 'package:wareflow/models/po_model.dart';
import 'package:wareflow/services/log_service.dart';
import 'package:wareflow/services/purchase_order_service.dart';

class PurchaseOrderProvider extends ChangeNotifier {
  String _poId = '';
  String _supplierId = '';
  String _supplierName = '';
  String _companyId = '';
  DateTime _createdAt = DateTime.now();
  String _createdBy = '';
  DateTime _expectedDate = DateTime.now();
  String _notes = '';
  String _status = '';
  String _warehouseId = '';
  DateTime _approvalDate = DateTime.now();
  final Map<String, PurchaseOrderModel> _purchaseOrders = {};
  List<PoItemModel> _items = [];

  //getters
  Map<String, PurchaseOrderModel> get purchaseOrders {
    return {..._purchaseOrders};
  }

  String get poId => _poId;
  String get supplierId => _supplierId;
  String get supplierName => _supplierName;
  String get companyId => _companyId;
  DateTime get createdAt => _createdAt;
  String get createdBy => _createdBy;
  DateTime get expectedDate => _expectedDate;
  String get notes => _notes;
  String get status => _status;
  String get warehouseId => _warehouseId;
  List<PoItemModel> get items => _items;
  DateTime get approvalDate => _approvalDate;
  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + item.unitPrice * item.orderedQty);

  void addItem(List<PoItemModel> item) {
    _items = item;
    print("Items:${_items.first.itemId}");
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.itemId == itemId);
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    _poId = '';
    _supplierId = '';
    _supplierName = '';
    _companyId = '';
    _createdAt = DateTime.now();
    _createdBy = '';
    _expectedDate = DateTime.now();
    _notes = '';
    _status = '';
    _warehouseId = '';
    _approvalDate = DateTime.now();
    notifyListeners();
  }

  void generateShortId(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    String id =
        List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
    _poId = 'PO-$id'; // e.g. PO-A7G9X2
  }

  //set selectedPO
  void setSelectedPO({
    required String poId,
    required String supplierId,
    required String supplierName,
    required String createdBy,
    required String companyId,
    required DateTime createdAt,
    required DateTime expectedDate,
    required String notes,
    required String status, // e.g., 'pending', 'partial', 'completed'
    required String warehouseId,
    required DateTime approvalDate,
  }) {
    _purchaseOrders[poId] = PurchaseOrderModel(
      poId: poId,
      supplierId: supplierId,
      supplierName: supplierName,
      createdBy: createdBy,
      companyId: companyId,
      createdAt: createdAt,
      expectedDate: expectedDate,
      notes: notes,
      status: status,
      totalAmount: totalAmount,
      warehouseId: warehouseId,
      approvalDate: approvalDate,
    );
    _poId = poId;
    _supplierId = supplierId;
    _supplierName = supplierName;
    _companyId = companyId;
    _createdAt = createdAt;
    _createdBy = createdBy;
    _expectedDate = expectedDate;
    _notes = notes;
    _status = status;
    _warehouseId = warehouseId;
    _approvalDate = approvalDate;
    notifyListeners();
  }

  //PO submit to firestore
  Future<void> submitPO(
    String supplierId,
    String supplierName,
    String createdBy,
    String companyId,
    DateTime expectedDate,
    String notes,
    String warehouseId,
  ) async {
    generateShortId(6);
    await PurchaseOrderService().createPurchaseOrder(
      poId,
      supplierId,
      supplierName,
      createdBy,
      companyId,
      expectedDate,
      notes,
      _items,
      totalAmount,
      warehouseId,
    );
    await LogService().logPurchaseOrder(
      action: "created",
      poId: poId,
      createdBy: createdBy,
      companyId: companyId,
      warehouseId: warehouseId,
      extraDetails: {
        'supplierId': supplierId,
        'supplierName': supplierName,
        'expectedDate': expectedDate,
        'totalAmount': totalAmount,
      },
    );
    clearAll();
  }

  //delete PO
  Future<void> deletePO({required String poId}) async {
    await PurchaseOrderService().deletePurchaseOrder(poId);
  }
}
