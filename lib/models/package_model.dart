class PackageModel {
  final String packageId;
  final String soId;
  final String companyId;
  final String warehouseId;
  final String createdBy;
  final DateTime packageDate;
  final String packageNote;
  final String packageStatus;

  PackageModel({
    required this.packageId,
    required this.soId,
    required this.companyId,
    required this.warehouseId,
    required this.createdBy,
    required this.packageDate,
    required this.packageNote,
    required this.packageStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'packageId': packageId,
      'soId': soId,
      'companyId': companyId,
      'warehouseId': warehouseId,
      'createdBy': createdBy,
      'packageDate': packageDate.toIso8601String(),
      'packageNote': packageNote,
      'packageStatus': packageStatus,
    };
  }

  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
      packageId: map['packageId'] ?? '',
      soId: map['soId'] ?? '',
      companyId: map['companyId'] ?? '',
      warehouseId: map['warehouseId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      packageDate: DateTime.parse(map['packageDate']),
      packageNote: map['packageNote'] ?? '',
      packageStatus: map['packageStatus'] ?? '',
    );
  }
}
