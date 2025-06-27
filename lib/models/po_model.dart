class PurchaseOrderModel {
  final String poId;
  final String supplierId;
  final String supplierName;
  final String createdBy;
  final String companyId;
  final DateTime createdAt;
  final DateTime expectedDate;
  final String notes;
  final String status; // e.g., 'pending', 'partial', 'completed'
  final double totalAmount;
  final String warehouseId;
  final DateTime approvalDate;

  PurchaseOrderModel({
    required this.poId,
    required this.supplierId,
    required this.supplierName,
    required this.createdBy,
    required this.companyId,
    required this.createdAt,
    required this.expectedDate,
    required this.notes,
    required this.status,
    required this.totalAmount,
    required this.warehouseId,
    required this.approvalDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': poId,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'createdBy': createdBy,
      'companyId': companyId,
      'createdAt': createdAt.toIso8601String(),
      'expectedDate': expectedDate.toIso8601String(),
      'notes': notes,
      'status': status,
      'totalAmount': totalAmount,
      'warehouseId': warehouseId,
      'approvalDate': approvalDate.toIso8601String(),
    };
  }

  factory PurchaseOrderModel.fromMap(String id, Map<String, dynamic> map) {
    return PurchaseOrderModel(
      poId: id,
      supplierId: map['supplierId'],
      supplierName: map['supplierName'],
      createdBy: map['createdBy'],
      companyId: map['companyId'],
      createdAt: DateTime.parse(map['createdAt']),
      expectedDate: DateTime.parse(map['expectedDate']),
      notes: map['notes'],
      status: map['status'],
      totalAmount: (map['totalAmount'] as num).toDouble(),
      warehouseId: map['warehouseId'],
      approvalDate: DateTime.parse(map['approvalDate']),
    );
  }
}
