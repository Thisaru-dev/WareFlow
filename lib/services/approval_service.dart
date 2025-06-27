import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all approvals with status 'PENDING' from multiple collections
  Future<List<Map<String, dynamic>>> fetchApprovalsByStatus(
    String status,
  ) async {
    List<Map<String, dynamic>> allApprovals = [];

    // Fetch GRN approvals
    final grnSnapshot =
        await _firestore
            .collection('grns')
            .where('status', isEqualTo: status.toUpperCase())
            .get();

    for (var doc in grnSnapshot.docs) {
      allApprovals.add({'type': 'GRN', 'doc': doc});
    }

    // Fetch Purchase Order approvals
    final poSnapshot =
        await _firestore
            .collection('purchase_orders')
            .where('status', isEqualTo: status.toUpperCase())
            .get();

    for (var doc in poSnapshot.docs) {
      allApprovals.add({'type': 'PurchaseOrder', 'doc': doc});
    }

    // Fetch Sales Order approvals
    final soSnapshot =
        await _firestore
            .collection('sales_orders')
            .where('status', isEqualTo: status.toUpperCase())
            .get();

    for (var doc in soSnapshot.docs) {
      allApprovals.add({'type': 'SalesOrder', 'doc': doc});
    }

    return allApprovals;
  }

  Future<List<Map<String, dynamic>>> fetchAllPendingApprovals() {
    return fetchApprovalsByStatus('PENDING');
  }

  Future<List<Map<String, dynamic>>> fetchAllApprovedApprovals() {
    return fetchApprovalsByStatus('APPROVED');
  }

  Future<List<Map<String, dynamic>>> fetchAllRejectedApprovals() {
    return fetchApprovalsByStatus('REJECTED');
  }
}
