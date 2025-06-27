import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/permission_provider.dart';
import 'package:wareflow/providers/purchase_order_provider.dart';

class PoOrder extends StatefulWidget {
  const PoOrder({super.key});

  @override
  State<PoOrder> createState() => _PoOrderState();
}

class _PoOrderState extends State<PoOrder> {
  @override
  Widget build(BuildContext context) {
    final permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );
    final String poId = ModalRoute.of(context)!.settings.arguments as String;

    return Consumer<PurchaseOrderProvider>(
      builder: (
        BuildContext context,
        PurchaseOrderProvider purchaseOrderProvider,
        _,
      ) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("Purchase Order", style: kTitleTextStyle),
            actions: [
              if (permissionProvider.hasPermission('manage_po'))
                IconButton(
                  onPressed: () {
                    purchaseOrderProvider.deletePO(poId: poId);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete, size: 20),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('purchase_orders')
                              .doc(poId)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        if (!snapshot.data!.exists) {
                          return Center(
                            child: Text(
                              "Purchase order not found.",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final DateTime date = DateTime.parse(data['createdAt']);
                        final String status = data['status'] ?? 'N/A';

                        return SizedBox(
                          width: 400,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "#${data['id']}",
                                        style: kPrimaryTextStyle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              status == 'ISSUED'
                                                  ? Colors.blue.shade100
                                                  : status == 'CLOSED'
                                                  ? Colors.green.shade100
                                                  : Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color:
                                                status == 'REJECTED'
                                                    ? Colors.redAccent
                                                    : status == 'APPROVED'
                                                    ? Colors.green.shade800
                                                    : Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Supplier",
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    data['supplierName'] ?? '',
                                    style: kPrimaryTextStyle.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Total Amount",
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "LKR ${data['totalAmount'].toStringAsFixed(2)}",
                                    style: kPrimaryTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Date",
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'MMM d, yyyy • h:mm a',
                                    ).format(date),
                                    style: kPrimaryTextStyle.copyWith(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    // Items Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Items",
                            style: kSecondaryTextStyle.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    // Items List
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('purchase_orders')
                              .doc(poId)
                              .collection('items')
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text("Something went wrong..."));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("No items found."));
                        }

                        final docs = snapshot.data!.docs;
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final doc = docs[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.green.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        'images/cubes.png',
                                        scale: 5,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    doc['itemName'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${doc['orderedQty']} x LKR.${doc['unitPrice']}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  trailing: Text(
                                    'LKR ${(doc['orderedQty'] * doc['unitPrice']).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
