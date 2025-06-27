import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/sales_order_provider.dart';

class SoSelection extends StatefulWidget {
  const SoSelection({super.key});

  @override
  State<SoSelection> createState() => _SoSelectionState();
}

class _SoSelectionState extends State<SoSelection> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Select Sales Order", style: kTitleTextStyle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<SalesOrderProvider>(
              builder: (
                BuildContext context,
                SalesOrderProvider salesOrderProvider,
                _,
              ) {
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('sales_orders')
                                .snapshots(),
                        builder: (context, snapshot) {
                          //error
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Something went wrong..."),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final salesOrders = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: salesOrders.length,
                            itemBuilder: (context, index) {
                              final so = salesOrders[index];
                              return GestureDetector(
                                onTap: () {
                                  salesOrderProvider.setSelectedSO(
                                    soId: so['id'],
                                    customerId: so['customerId'],
                                    customerName: so['customerName'],
                                    createdBy: so['createdBy'],
                                    companyId: so['companyId'],
                                    warehouseId: so['warehouseId'],
                                    createdAt: DateTime.parse(so['createdAt']),
                                    expectedDate: DateTime.parse(
                                      so['expectedDate'],
                                    ),
                                    notes: so['notes'],
                                    status: so['status'],
                                    totalAmount: so['totalAmount'],
                                    approvaldate: DateTime.parse(
                                      so['approvalDate'],
                                    ),
                                  );
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                }, //check only show need to be received items
                                child: ListTile(
                                  title: Text(
                                    so['id'],
                                    style: kPrimaryTextStyle.copyWith(
                                      fontSize: 36.sp,
                                    ),
                                  ),
                                  subtitle: Text(
                                    so['createdAt'],
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        so['totalAmount'].toString(),
                                        style: kSecondaryTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      selectedIndex == index
                                          ? Icon(
                                            Icons.check_box,
                                            color: kPrimaryColor,
                                          )
                                          : Icon(
                                            Icons.check_box_outline_blank,
                                            color: Colors.blueGrey,
                                          ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
