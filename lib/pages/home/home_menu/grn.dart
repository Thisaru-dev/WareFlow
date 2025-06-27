import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/permission_provider.dart';

class Grn extends StatefulWidget {
  const Grn({super.key});

  @override
  State<Grn> createState() => _GrnState();
}

class _GrnState extends State<Grn> {
  final _grnStream = FirebaseFirestore.instance.collection('grns').snapshots();

  void _deleteGrn(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete GRN'),
            content: Text('Are you sure you want to delete this GRN?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('grns').doc(docId).delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('GRN deleted')));
    }
  }

  void _editGrn(DocumentSnapshot grn) {
    Navigator.pushNamed(context, '/editgrn', arguments: grn);
  }

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
        title: Text("GRN", style: kTitleTextStyle),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
        ],
      ),
      floatingActionButton:
          permissionProvider.hasPermission('manage_po')
              ? FloatingActionButton(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/creategrn');
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
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'PO ID: ${grn['poId']}',
                                      style: kSecondaryTextStyle.copyWith(
                                        fontSize: 13,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const Divider(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            _buildStatusBadge(
                                              'GRN',
                                              grn['status'],
                                              Colors.blue,
                                            ),
                                            const SizedBox(width: 10),
                                            _buildStatusBadge(
                                              'QC',
                                              grn['qcStatus'],
                                              Colors.green,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () => _editGrn(grn),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed:
                                                  () => _deleteGrn(grn.id),
                                            ),
                                          ],
                                        ),
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

Widget _buildStatusBadge(String label, String value, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.6)),
    ),
    child: Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
