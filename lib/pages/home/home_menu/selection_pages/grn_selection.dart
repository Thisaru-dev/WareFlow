import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/grn_provider.dart';

class GrnSelection extends StatefulWidget {
  const GrnSelection({super.key});

  @override
  State<GrnSelection> createState() => _GrnSelectionState();
}

class _GrnSelectionState extends State<GrnSelection> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Select GRN", style: kTitleTextStyle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<GrnProvider>(
              builder: (BuildContext context, GrnProvider grnProvider, _) {
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('grns')
                                .where('status', isEqualTo: 'APPROVED')
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
                          final grns = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: grns.length,
                            itemBuilder: (context, index) {
                              final grn = grns[index];
                              return GestureDetector(
                                onTap: () {
                                  grnProvider.setSelectedGRN(
                                    grnId: grn['grnId'],
                                    poId: grn['poId'],
                                    companyId: grn['companyId'],
                                    warehouseId: grn['warehouseId'],
                                    grnDate: DateTime.parse(grn['grnDate']),
                                    grnNote: grn['grnNote'],
                                    status: grn['status'],
                                    qcDate: DateTime.parse(grn['qcDate']),
                                    qcNote: grn['qcNote'],
                                    qcStatus: grn['qcStatus'],
                                    approvalDate: DateTime.parse(
                                      grn['approvalDate'],
                                    ),
                                  );
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                }, //check only show need to be received items
                                child: ListTile(
                                  title: Text(
                                    grn['grnId'],
                                    style: kPrimaryTextStyle.copyWith(
                                      fontSize: 36.sp,
                                    ),
                                  ),
                                  subtitle: Text(
                                    grn['grnDate'],
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        grn['poId'].toString(),
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
