import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/log_model.dart';

class LogService {
  String _logId = 'log-0000';
  // reference
  final logRef = FirebaseFirestore.instance.collection('logs');
  //create po log
  Future<void> logPurchaseOrder({
    required String action,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required String poId,
    required Map<String, dynamic>? extraDetails,
  }) async {
    generateShortId(4);
    final log = LogModel(
      logId: logId,
      type: 'purchase_order',
      action: action,
      companyId: companyId,
      warehouseId: warehouseId,
      createdBy: createdBy,
      createdAt: DateTime.now(),
      details: {'poId': poId, ...?extraDetails},
    );
    await logRef.doc(logId).set(log.toMap());
  }

  // create pr log
  Future<void> logPurchaseReceive({
    required String action,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required String grn,
    required String poId,
    required Map<String, dynamic>? extraDetails,
  }) async {
    generateShortId(4);
    final log = LogModel(
      logId: logId,
      type: 'purchase_receive',
      action: action,
      companyId: companyId,
      warehouseId: warehouseId,
      createdBy: createdBy,
      createdAt: DateTime.now(),
      details: {'poId': poId, 'grn': grn, ...?extraDetails},
    );
    await logRef.doc(logId).set(log.toMap());
  }

  // create inspection log
  Future<void> logInspection({
    required String action,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required String grn,
    required String poId,
    required Map<String, dynamic>? extraDetails,
  }) async {
    generateShortId(4);
    final log = LogModel(
      logId: logId,
      type: 'inspection',
      action: action,
      companyId: companyId,
      warehouseId: warehouseId,
      createdBy: createdBy,
      createdAt: DateTime.now(),
      details: {'poId': poId, 'grn': grn, ...?extraDetails},
    );
    await logRef.doc(logId).set(log.toMap());
  }

  // create package log
  Future<void> logPackage({
    required String action,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required String soId,
    required Map<String, dynamic>? extraDetails,
  }) async {
    generateShortId(4);
    final log = LogModel(
      logId: logId,
      type: 'package',
      action: action,
      companyId: companyId,
      warehouseId: warehouseId,
      createdBy: createdBy,
      createdAt: DateTime.now(),
      details: {'soId': soId, ...?extraDetails},
    );
    await logRef.doc(logId).set(log.toMap());
  }

  void generateShortId(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    String id =
        List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
    _logId = 'log-$id'; // e.g. PO-A7G9X2
  }

  // get logId
  String get logId => _logId;
}
