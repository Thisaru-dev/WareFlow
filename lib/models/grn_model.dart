class GrnModel {
  final String grnId;
  final String poId;
  final String companyId;
  final String warehouseId;
  final DateTime grnDate;
  final String grnNote;
  final String status;
  final DateTime qcDate;
  final String qcNote;
  final String qcStatus;
  final DateTime approvalDate;

  GrnModel({
    required this.grnId,
    required this.poId,
    required this.companyId,
    required this.warehouseId,
    required this.grnDate,
    required this.grnNote,
    required this.status,
    required this.qcDate,
    required this.qcNote,
    required this.qcStatus,
    required this.approvalDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'grnId': grnId,
      'poId': poId,
      'companyId': companyId,
      'warehouseId': warehouseId,
      'grnDate': grnDate.toIso8601String(),
      'grnNote': grnNote,
      'status': status,
      'qcDate': qcDate.toIso8601String(),
      'qcNote': qcNote,
      'qcStatus': qcStatus,
      'approvalDate': approvalDate.toIso8601String(),
    };
  }

  factory GrnModel.fromMap(Map<String, dynamic> map) {
    return GrnModel(
      grnId: map['grnId'],
      poId: map['poId'],
      companyId: map['companyId'],
      warehouseId: map['warehouseId'],
      grnDate: DateTime.parse(map['grnDate']),
      grnNote: map['grnNote'],
      status: map['status'],
      qcDate: DateTime.parse(map['qcDate']),
      qcNote: map['qcNote'],
      qcStatus: map['qcStatus'],
      approvalDate: DateTime.parse(map['approvalDate']),
    );
  }
}
