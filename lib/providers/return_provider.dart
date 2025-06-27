import 'package:flutter/material.dart';
import 'package:wareflow/models/return_model.dart';
import 'package:wareflow/models/returnable_item_model.dart';
import 'package:wareflow/services/return_service.dart';

class ReturnProvider extends ChangeNotifier {
  final String _id = '';
  final String _type = '';
  final String _companyId = '';
  final String _warehouseId = '';
  final String _referenceId = '';
  final String _createdBy = '';
  final DateTime _returnDate = DateTime.now();
  final String _note = '';
  List<ReturnableItemModel> _items = [];

  //state
  final Map<String, ReturnModel> _returns = {};
  //getters
  Map<String, ReturnModel> get returns {
    return {..._returns};
  }

  //getters
  String get id => _id;
  String get type => _type;
  String get companyId => _companyId;
  String get warehouseId => _warehouseId;
  String get referenceId => _referenceId;
  String get createdBy => _createdBy;
  DateTime get returnDate => _returnDate;
  String get note => _note;
  List<ReturnableItemModel> get items => _items;

  //add items to return
  void addItem(List<ReturnableItemModel> item) {
    _items = item;
    print("Items:${_items.first.itemId}");
    notifyListeners();
  }

  //create return
  Future<void> createReturn({
    required String id,
    required String type,
    required String companyId,
    required String warehouseId,
    required String referenceId,
    required String createdBy,
    required DateTime returnDate,
    required String note,
  }) async {
    await ReturnService().createReturn(
      id: id,
      type: type,
      companyId: companyId,
      warehouseId: warehouseId,
      referenceId: referenceId,
      createdBy: createdBy,
      returnDate: returnDate,
      note: note,
      items: items,
    );
  }
}
