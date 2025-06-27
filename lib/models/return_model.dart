class ReturnModel {
  final String id;
  final String type;
  final String companyId;
  final String warehouseId;
  final String referenceId; // grn/so/package id
  final String createdBy;
  final DateTime returnDate;
  final String note;

  ReturnModel({
    required this.id,
    required this.type,
    required this.companyId,
    required this.warehouseId,
    required this.referenceId,
    required this.createdBy,
    required this.returnDate,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'companyId': companyId,
      'warehouseId': warehouseId,
      'referenceId': referenceId,
      'createdBy': createdBy,
      'returnDate': returnDate.toIso8601String(),
      'note': note,
    };
  }

  factory ReturnModel.fromMap(Map<String, dynamic> map) {
    return ReturnModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      companyId: map['companyId'] ?? '',
      warehouseId: map['warehouseId'] ?? '',
      referenceId: map['referenceId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      returnDate: DateTime.parse(map['returnDate']),
      note: map['note'] ?? '',
    );
  }
}
