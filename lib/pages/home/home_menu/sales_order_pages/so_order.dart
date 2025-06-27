import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/permission_provider.dart';
import 'package:wareflow/providers/sales_order_provider.dart';

class SoOrder extends StatefulWidget {
  const SoOrder({super.key});

  @override
  State<SoOrder> createState() => _SoOrderState();
}

class _SoOrderState extends State<SoOrder> {
  @override
  Widget build(BuildContext context) {
    final permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );
    final String soId = ModalRoute.of(context)!.settings.arguments as String;
    return Consumer<SalesOrderProvider>(
      builder: (
        BuildContext context,
        SalesOrderProvider salesOrderProvider,
        _,
      ) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("Sales Order", style: kTitleTextStyle),
            actions: [
              permissionProvider.hasPermission('manage_so')
                  ? IconButton(
                    onPressed: () {
                      salesOrderProvider.deleteSO(soId: soId);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete, size: 20),
                  )
                  : SizedBox(),
            ],
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //details card
                    SizedBox(
                      width: 400,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: StreamBuilder<DocumentSnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('sales_orders')
                                    .doc(soId)
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(
                                  child: Text(
                                    "Sales order not found or has been deleted.",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              final data =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Order ID and Status Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "#${data['id'] ?? ''}",
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
                                              data['status'] == 'APPROVED'
                                                  ? Colors.green.shade100
                                                  : data['status'] == 'PENDING'
                                                  ? Colors.orange.shade100
                                                  : Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          data['status'] ?? '',
                                          style: TextStyle(
                                            color:
                                                data['status'] == 'APPROVED'
                                                    ? Colors.green.shade800
                                                    : data['status'] ==
                                                        'PENDING'
                                                    ? Colors.orange.shade800
                                                    : Colors.red.shade800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Customer Name
                                  Text(
                                    "Customer",
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    data['customerName'] ?? '',
                                    style: kPrimaryTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Total Amount
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

                                  // Created Date
                                  Text(
                                    "Date",
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'MMM d, yyyy • h:mm a',
                                    ).format(DateTime.parse(data['createdAt'])),
                                    style: kPrimaryTextStyle.copyWith(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  data['status'] == 'APPROVED'
                                      ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: FilledButton(
                                          onPressed: () {},
                                          child: Text("Send Invoice"),
                                        ),
                                      )
                                      : SizedBox(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
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

                    StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('sales_orders')
                              .doc(soId)
                              .collection('items')
                              .snapshots(),
                      builder: (context, snapshot) {
                        //error
                        if (snapshot.hasError) {
                          return Center(child: Text("Something went wrong..."));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                              "",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
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
                                    backgroundColor: Colors.blue.shade50,
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
