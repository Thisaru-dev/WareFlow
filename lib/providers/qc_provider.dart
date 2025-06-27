import 'package:flutter/material.dart';
import 'package:wareflow/models/qc_issues_model.dart';
import 'package:wareflow/services/qc_service.dart';
import 'package:wareflow/services/log_service.dart';

class QcProvider extends ChangeNotifier {
  // issues list
  List<QcIssuesModel> issueList = [];
  //get issues
  List<QcIssuesModel> get issues => issueList;
  //add issues
  void addIssue(
    String itemId,
    int quantityIssueQty,
    int qualityIssueQty,
    int wrongItemsQty,
  ) {
    final index = issueList.indexWhere((e) => e.itemId == itemId);
    if (index != -1) {
      issueList[index] = QcIssuesModel(
        itemId: itemId,
        quantityIssueQty: quantityIssueQty,
        qualityIssueQty: qualityIssueQty,
        wrongItemsQty: wrongItemsQty,
      );
    } else {
      issueList.add(
        QcIssuesModel(
          itemId: itemId,
          quantityIssueQty: quantityIssueQty,
          qualityIssueQty: qualityIssueQty,
          wrongItemsQty: wrongItemsQty,
        ),
      );
    }
    notifyListeners();
  }

  // new qc
  Future<void> createQC({
    required String poId,
    required String grnId,
    required String qcStatus,
    required DateTime qcDate,
    required String qcNote,
  }) async {
    await QcService().updareGRN(
      grnId: grnId,
      qcDate: qcDate,
      qcNote: qcNote,
      qcStatus: qcStatus,
      itemIssued: issueList.map((e) => e.toMap()).toList(),
    );
    await LogService().logInspection(
      action: "created",
      grn: grnId,
      poId: poId,
      createdBy: 'no',
      companyId: 'no',
      warehouseId: 'no',
      extraDetails: {},
    );
    notifyListeners();
  }
}
