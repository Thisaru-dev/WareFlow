import 'package:flutter/material.dart';
import 'package:wareflow/services/log_service.dart';

class LogProvider extends ChangeNotifier {
  // // log state
  // final Map<dynamic, LogModel> _logs = {};
  // //getter
  // Map<dynamic, LogModel> get logs {
  //   return {..._logs};
  // }
  final LogService _logService = LogService();

  //create po log
  Future<void> logPO({
    required String action,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required String poId,
    required Map<String, dynamic>? extraDetails,
  }) async {
    await _logService.logPurchaseOrder(
      action: action,
      createdBy: createdBy,
      companyId: companyId,
      warehouseId: warehouseId,
      poId: poId,
      extraDetails: extraDetails,
    );
  }

  //create pr log
  Future<void> logPR({
    required String action,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required String grn,
    required String poId,
    required Map<String, dynamic>? extraDetails,
  }) async {
    await _logService.logPurchaseReceive(
      action: action,
      createdBy: createdBy,
      companyId: companyId,
      warehouseId: warehouseId,
      grn: grn,
      poId: poId,
      extraDetails: extraDetails,
    );
  }

  //create inspection log
  Future<void> inspectionPO({
    required String action,
    required String createdBy,
    required String companyId,
    required String warehouseId,
    required String poId,
    required Map<String, dynamic>? extraDetails,
  }) async {
    await _logService.logPurchaseOrder(
      action: action,
      createdBy: createdBy,
      companyId: companyId,
      warehouseId: warehouseId,
      poId: poId,
      extraDetails: extraDetails,
    );
  }
}
