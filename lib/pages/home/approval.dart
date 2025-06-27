import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/services/approval_service.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approvals", style: kTitleTextStyle),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildApprovalList('PENDING'),
          _buildApprovalList('APPROVED'),
          _buildApprovalList('REJECTED'),
        ],
      ),
    );
  }

  Widget _buildApprovalList(String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApprovalService().fetchApprovalsByStatus(status),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No $status approvals."));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final type = item['type'];
              final doc = item['doc'] as DocumentSnapshot;

              String title = '';
              String subtitle = '';

              switch (type) {
                case 'GRN':
                  title = 'GRN #${doc['grnId']}';
                  subtitle = 'PoId: ${doc['poId']}';
                  break;
                case 'SalesOrder':
                  title = 'Sales Order #${doc['id']}';
                  subtitle = 'Customer: ${doc['customerName']}';
                  break;
                case 'PurchaseOrder':
                  title = 'Purchase Order #${doc['id']}';
                  subtitle = 'Supplier: ${doc['supplierName']}';
                  break;
                default:
                  title = 'Unknown Type';
                  subtitle = '';
              }

              return Card(
                child: ListTile(
                  leading: Icon(Icons.assignment, color: Colors.orange),
                  title: Text(
                    title,
                    style: kPrimaryTextStyle.copyWith(fontSize: 14),
                  ),
                  subtitle: Text(subtitle),
                  trailing:
                      status == 'PENDING'
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                onPressed:
                                    () => _handleApproval(type, doc.id, true),
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed:
                                    () => _handleApproval(type, doc.id, false),
                              ),
                            ],
                          )
                          : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleApproval(
    String type,
    String docId,
    bool isApproved,
  ) async {
    await FirebaseFirestore.instance
        .collection(_getCollectionName(type))
        .doc(docId)
        .update({
          'status': isApproved ? 'APPROVED' : 'REJECTED',
          'approvalDate': DateTime.now().toIso8601String(),
        });
    setState(() {});
  }

  String _getCollectionName(String type) {
    switch (type) {
      case 'GRN':
        return 'grns';
      case 'SalesOrder':
        return 'sales_orders';
      case 'PurchaseOrder':
        return 'purchase_orders';
      default:
        return '';
    }
  }
}
