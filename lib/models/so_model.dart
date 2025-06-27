class SalesOrderModel {
  final String soId;
  final String customerId;
  final String customerName;
  final String createdBy;
  final String companyId;
  final String warehouseId;
  final DateTime createdAt;
  final DateTime expectedDate;
  final String notes;
  final String status; // e.g., 'pending', 'partial', 'completed'
  final double totalAmount;
  final DateTime approvaldate;

  SalesOrderModel({
    required this.soId,
    required this.customerId,
    required this.customerName,
    required this.createdBy,
    required this.companyId,
    required this.warehouseId,
    required this.createdAt,
    required this.expectedDate,
    required this.notes,
    required this.status,
    required this.totalAmount,
    required this.approvaldate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': soId,
      'customerId': customerId,
      'customerName': customerName,
      'createdBy': createdBy,
      'companyId': companyId,
      'warehouseId': warehouseId,
      'createdAt': createdAt.toIso8601String(),
      'expectedDate': expectedDate.toIso8601String(),
      'notes': notes,
      'status': status,
      'totalAmount': totalAmount,
      'approvalDate': approvaldate.toIso8601String(),
    };
  }

  factory SalesOrderModel.fromMap(Map<String, dynamic> map) {
    return SalesOrderModel(
      soId: map['id'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      createdBy: map['createdBy'],
      companyId: map['companyId'],
      warehouseId: map['warehouseId'],
      createdAt: DateTime.parse(map['createdAt']),
      expectedDate: DateTime.parse(map['expectedDate']),
      notes: map['notes'],
      status: map['status'],
      totalAmount: (map['totalAmount'] as num).toDouble(),
      approvaldate: DateTime.parse(map['approvalDate']),
    );
  }
}
