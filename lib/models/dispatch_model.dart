class DispatchModel {
  final String dispatchId;
  final String companyId;
  final String warehouseId;
  final String soId;
  final DateTime dispatchDate;
  final String dispatchNote;
  final String dispatchStatus;

  DispatchModel({
    required this.dispatchId,
    required this.companyId,
    required this.warehouseId,
    required this.soId,
    required this.dispatchDate,
    required this.dispatchNote,
    required this.dispatchStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'dispatchId': dispatchId,
      'companyId': companyId,
      'warehouseId': warehouseId,
      'soId': soId,
      'dispatchDate': dispatchDate.toIso8601String(),
      'dispatchNote': dispatchNote,
      'dispatchStatus': dispatchStatus,
    };
  }

  factory DispatchModel.fromMap(Map<String, dynamic> map) {
    return DispatchModel(
      dispatchId: map['dispatchId'] ?? '',
      companyId: map['companyId'] ?? '',
      warehouseId: map['warehouseId'] ?? '',
      soId: map['soId'] ?? '',
      dispatchDate: DateTime.parse(map['dispatchDate']),
      dispatchNote: map['dispatchNote'] ?? '',
      dispatchStatus: map['dispatchStatus'] ?? '',
    );
  }
}
