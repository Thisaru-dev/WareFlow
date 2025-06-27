import 'package:cloud_firestore/cloud_firestore.dart';

class LogModel {
  final String logId;
  final String type; //like po,pr,inventory
  final String action; // creade, updated
  final String companyId;
  final String warehouseId;
  final String createdBy;
  final DateTime createdAt;
  final Map<String, dynamic>? details;

  LogModel({
    required this.logId,
    required this.type,
    required this.action,
    required this.companyId,
    required this.warehouseId,
    required this.createdBy,
    required this.createdAt,
    this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'logId': logId,
      'type': type,
      'action': action,
      'companyId': companyId,
      'warehouseId': warehouseId,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'details': details ?? {},
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      logId: map['logId'] ?? '',
      type: map['type'] ?? '',
      action: map['action'] ?? '',
      companyId: map['companyId'] ?? '',
      warehouseId: map['warehouseId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      details: Map<String, dynamic>.from(map['details'] ?? {}),
    );
  }
}
