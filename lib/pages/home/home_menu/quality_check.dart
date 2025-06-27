import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/permission_provider.dart';

class QualityCheck extends StatefulWidget {
  const QualityCheck({super.key});

  @override
  State<QualityCheck> createState() => _QualityCheckState();
}

class _QualityCheckState extends State<QualityCheck> {
  final _grnStream =
      FirebaseFirestore.instance
          .collection('grns')
          .where('qcStatus', whereIn: ['APPROVED', 'REJECTED'])
          .snapshots();

  @override
  Widget build(BuildContext context) {
    final permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Quality Check", style: kTitleTextStyle),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
        ],
      ),
      floatingActionButton:
          permissionProvider.hasPermission('manage_inspections')
              ? FloatingActionButton(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/createqc');
                },
                child: Icon(Icons.add),
              )
              : SizedBox(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: kPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: SizedBox(
                  width: 380,
                  height: 40,
                  // search bar
                  child: SearchBar(
                    controller: null,
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    leading: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search...",
                    elevation: WidgetStatePropertyAll(0),
                    surfaceTintColor: WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _grnStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error on Stream');
                } else if (!snapshot.hasData) {
                  return Text('No data');
                }
                final grns = snapshot.data!.docs;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: grns.length,
                      itemBuilder: (context, index) {
                        final grn = grns[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                          child: GestureDetector(
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 5,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // GRN ID & Date
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            grn['grnId'],
                                            style: kPrimaryTextStyle.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMMM d, yyyy').format(
                                            DateTime.parse(grn['grnDate']),
                                          ),
                                          style: kSecondaryTextStyle.copyWith(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    // PO ID
                                    Text(
                                      'PO ID: ${grn['poId']}',
                                      style: kSecondaryTextStyle.copyWith(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // Statuses
                                    Row(
                                      children: [
                                        _buildQCStatusBadge(
                                          'QC',
                                          grn['qcStatus'],
                                          Colors.green,
                                        ),
                                        const SizedBox(width: 10),
                                        // _buildQCStatusBadge(
                                        //   'Approval',
                                        //   grn['approval'],
                                        //   Colors.deepOrange,
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildQCStatusBadge(String label, String value, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      border: Border.all(color: color.withOpacity(0.6)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}
