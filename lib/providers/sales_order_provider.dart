import 'package:flutter/material.dart';
import 'package:wareflow/models/po_item_model.dart';
import 'package:wareflow/models/so_item_model.dart';
import 'package:wareflow/models/so_model.dart';
import 'package:wareflow/services/sales_order_service.dart';

class SalesOrderProvider extends ChangeNotifier {
  final Map<String, SalesOrderModel> _salesOrders = {};
  List<PoItemModel> _items = [];
  String _soId = '';
  String _customerId = '';
  String _customerName = '';
  String _createdBy = '';
  String _companyId = '';
  String _warehouseId = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expectedDate = DateTime.now();
  String _notes = '';
  String _status = ''; // e.g., 'pending', 'partial', 'completed'
  // double _totalAmount = 0;
  DateTime _approvalDate = DateTime.now();

  //getters
  Map<String, SalesOrderModel> get purchaseOrders {
    return {..._salesOrders};
  }

  String get soId => _soId;
  String get customerId => _customerId;
  String get customerName => _customerName;
  String get createdBy => _createdBy;
  String get companyId => _companyId;
  String get warehouseId => _warehouseId;
  DateTime get createdAt => _createdAt;
  DateTime get expectedDate => _expectedDate;
  String get notes => _notes;
  String get status => _status;
  List<PoItemModel> get items => _items;
  DateTime get approvaldate => _approvalDate;
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
    notifyListeners();
  }

  //set selectedSO
  void setSelectedSO({
    required String soId,
    required String customerId,
    required String customerName,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required DateTime createdAt,
    required DateTime expectedDate,
    required String notes,
    required String status, // e.g., 'pending', 'partial', 'completed'
    required double totalAmount,
    required DateTime approvaldate,
  }) {
    _salesOrders[soId] = SalesOrderModel(
      soId: soId,
      customerId: customerId,
      customerName: customerName,
      createdBy: createdBy,
      companyId: companyId,
      warehouseId: warehouseId,
      createdAt: createdAt,
      expectedDate: expectedDate,
      notes: notes,
      status: status,
      totalAmount: totalAmount,
      approvaldate: approvaldate,
    );
    _soId = soId;
    _customerId = customerId;
    _customerName = customerName;
    _createdBy = createdBy;
    _companyId = companyId;
    _warehouseId = warehouseId;
    _createdAt = createdAt;
    _expectedDate = expectedDate;
    _notes = notes;
    _status = status;
    _approvalDate = approvaldate;
    // _totalAmount = totalAmount;
    notifyListeners();
  }

  //PO submit to firestore
  Future<void> submitSO({
    required String soId,
    required String customerId,
    required String customerName,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required DateTime expectedDate,
    required String notes,
  }) async {
    await SalesOrderService().createSalesOrder(
      soId: soId,
      customerId: customerId,
      customerName: customerName,
      createdBy: createdBy,
      companyId: companyId,
      warehouseId: warehouseId,
      expectedDate: expectedDate,
      notes: notes,
      totalAmount: totalAmount,
      items: convertList(_items),
    );
    // await LogService().logPurchaseOrder(
    //   action: "created",
    //   poId: poId,
    //   createdBy: createdBy,
    //   companyId: companyId,
    //   warehouseId: warehouseId,
    //   extraDetails: {
    //     'supplierId': supplierId,
    //     'supplierName': supplierName,
    //     'expectedDate': expectedDate,
    //     'totalAmount': totalAmount,
    //   },
    // );
    clearAll();
  }

  //get pomodel item list as prmodel item list
  List<SoItemModel> convertList(List<PoItemModel> sourceList) {
    return sourceList.map((poItem) {
      return SoItemModel(
        itemId: poItem.itemId,
        itemName: poItem.itemName,
        image: poItem.image,
        orderedQty: poItem.orderedQty,
        unitPrice: poItem.unitPrice,
      );
    }).toList();
  }

  //delete so
  Future<void> deleteSO({required String soId}) async {
    await SalesOrderService().deleteSalesOrder(soId);
    notifyListeners();
  }
}
