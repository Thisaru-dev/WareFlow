import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wareflow/models/po_item_model.dart';
import 'package:wareflow/models/grn_item_model.dart';
import 'package:wareflow/models/grn_model.dart';
import 'package:wareflow/services/log_service.dart';
import 'package:wareflow/services/purchase_order_service.dart';
import 'package:wareflow/services/grn_service.dart';

class GrnProvider extends ChangeNotifier {
  List<PoItemModel> _items = [];
  String _grnId = '';
  String _poId = '';
  String _companyId = '';
  String _warehouseId = '';
  DateTime _grnDate = DateTime.now();
  String _grnNote = '';
  String _grnStatus = '';
  DateTime _qcDate = DateTime.now();
  String _qcNote = '';
  String _qcStatus = '';
  DateTime _approvalDate = DateTime.now();

  //state
  final Map<String, GrnModel> _grns = {};
  //getters
  Map<String, GrnModel> get grns {
    return {..._grns};
  }

  String get grnId => _grnId;
  String get poId => _poId;
  String get companyId => _companyId;
  String get warehouseId => _warehouseId;
  DateTime get grnDate => _grnDate;
  String get grnNote => _grnNote;
  String get grnStatus => _grnStatus;
  DateTime get qcDate => _qcDate;
  String get qcNote => _qcNote;
  String get qcStatus => _qcStatus;
  DateTime get approvalDate => _approvalDate;
  List<PoItemModel> get items => _items;

  //add items to grn list
  void addItem(List<PoItemModel> item) {
    _items = item;
    print("Items:${_items.first.itemId}");
    notifyListeners();
  }

  void generateShortId() {
    final rand = Random.secure();
    int no = rand.nextInt(9000) + 1000;
    _grnId = 'GRN-$no'; // e.g. GRN-A7G9X2
  }

  //create GRN
  Future<void> createGrn({
    required String grnId,
    required String poId,
    required String companyId,
    required String warehouseId,
    required DateTime grnDate,
    required String grnNote,
    required String status,
    required DateTime qcDate,
    required String qcNote,
    required String qcStatus,
    required DateTime approvalDate,
  }) async {
    await GrnService().createGrn(
      grnId: grnId,
      poId: poId,
      companyId: companyId,
      warehouseId: warehouseId,
      grnDate: grnDate,
      grnNote: grnNote,
      status: status,
      qcDate: qcDate,
      qcNote: qcNote,
      qcStatus: qcStatus,
      approvalDate: approvalDate,
      items: convertList(_items),
    );

    await PurchaseOrderService().updateReceivedQty(poId, items);
    await LogService().logPurchaseReceive(
      action: "created",
      createdBy: "no",
      companyId: "no",
      warehouseId: "no",
      poId: poId,
      grn: "no",
      extraDetails: {},
    );
    notifyListeners();
  }

  //set selected grn
  void setSelectedGRN({
    required String grnId,
    required String poId,
    required String companyId,
    required String warehouseId,
    required DateTime grnDate,
    required String grnNote,
    required String status,
    required DateTime qcDate,
    required String qcNote,
    required String qcStatus,
    required DateTime approvalDate,
  }) {
    _grns[grnId] = GrnModel(
      grnId: grnId,
      poId: poId,
      companyId: companyId,
      warehouseId: warehouseId,
      grnDate: grnDate,
      grnNote: grnNote,
      status: status,
      qcDate: qcDate,
      qcNote: qcNote,
      qcStatus: qcStatus,
      approvalDate: approvalDate,
    );
    _grnId = grnId;
    _poId = poId;
    _companyId = companyId;
    _warehouseId = warehouseId;
    _grnDate = grnDate;
    _grnNote = grnNote;
    _grnStatus = grnStatus;
    _qcDate = qcDate;
    _qcNote = qcNote;
    _qcStatus = qcStatus;
    _approvalDate = approvalDate;
    notifyListeners();
  }

  //get grn as a grnList
  List<GrnModel> get selectedItems {
    return _grns.values.map((e) {
      return GrnModel(
        grnId: e.grnId,
        poId: e.poId,
        companyId: e.companyId,
        warehouseId: e.warehouseId,
        grnDate: e.grnDate,
        grnNote: e.grnNote,
        status: e.status,
        qcDate: e.qcDate,
        qcNote: e.qcNote,
        qcStatus: e.qcStatus,
        approvalDate: e.approvalDate,
      );
    }).toList();
  }

  //get pomodel item list as grnmodel item list
  List<GrnItemModel> convertList(List<PoItemModel> sourceList) {
    return sourceList.map((poItem) {
      return GrnItemModel(
        itemId: poItem.itemId,
        itemName: poItem.itemName,
        image: poItem.image,
        orderedQty: poItem.orderedQty,
        receivedQty: poItem.receivedQty,
        unitPrice: poItem.unitPrice,
        quantityIssuesQty: 0,
        qualityIssuesQty: 0,
        wrongItemsQty: 0,
      );
    }).toList();
  }

  //clear all
  void clearAll() {
    _items = [];
    _grnId = '';
    _poId = '';
    _companyId = '';
    _warehouseId = '';
    _grnDate = DateTime.now();
    _grnNote = '';
    _grnStatus = '';
    _qcDate = DateTime.now();
    _qcNote = '';
    _qcStatus = '';
    _approvalDate = DateTime.now();
  }
}
