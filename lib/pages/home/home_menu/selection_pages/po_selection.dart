import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/purchase_order_provider.dart';

class PoSelection extends StatefulWidget {
  const PoSelection({super.key});

  @override
  State<PoSelection> createState() => _PoSelectionState();
}

class _PoSelectionState extends State<PoSelection> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Select Purchase Order", style: kTitleTextStyle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<PurchaseOrderProvider>(
              builder: (
                BuildContext context,
                PurchaseOrderProvider purchaseOrderProvider,
                _,
              ) {
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('purchase_orders')
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
                          final purchaseOrders = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: purchaseOrders.length,
                            itemBuilder: (context, index) {
                              final po = purchaseOrders[index];
                              return GestureDetector(
                                onTap: () {
                                  purchaseOrderProvider.setSelectedPO(
                                    poId: po['id'],
                                    companyId: po['companyId'],
                                    warehouseId: po['warehouseId'],
                                    supplierId: po['supplierId'],
                                    supplierName: po['supplierName'],
                                    createdAt: DateTime.parse(po['createdAt']),
                                    createdBy: po['createdBy'],
                                    expectedDate: DateTime.parse(
                                      po['expectedDate'],
                                    ),
                                    status: po['status'],
                                    notes: po['notes'],
                                    approvalDate: DateTime.parse(
                                      po['approvalDate'],
                                    ),
                                  );
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                }, //check only show need to be received items
                                child: ListTile(
                                  title: Text(
                                    po['id'],
                                    style: kPrimaryTextStyle.copyWith(
                                      fontSize: 36.sp,
                                    ),
                                  ),
                                  subtitle: Text(
                                    po['createdAt'],
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        po['totalAmount'].toString(),
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
