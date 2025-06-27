import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wareflow/constants/constants.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  final List<String> logTypes = const [
    'package',
    'purchase_order',
    'sales',
    'return',
    'dispatch',
  ];

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'created':
        return Colors.green.shade100;
      case 'updated':
        return Colors.orange.shade100;
      case 'deleted':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: logTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Logs', style: kTitleTextStyle),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs:
                logTypes
                    .map(
                      (type) => Tab(
                        text:
                            "${type[0].toUpperCase()}${type.substring(1)} Logs",
                      ),
                    )
                    .toList(),
          ),
        ),
        body: TabBarView(
          children:
              logTypes.map((type) {
                return StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('logs')
                          .where('type', isEqualTo: type)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading logs'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No logs found'));
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final data = docs[i].data() as Map<String, dynamic>;
                        final createdAt =
                            (data['createdAt'] as Timestamp).toDate();
                        final formattedDate = DateFormat(
                          'MMM d, yyyy • h:mm a',
                        ).format(createdAt);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.event_note,
                              color: Colors.blue,
                            ),
                            title: Text(
                              "Action: ${data['action'] ?? 'N/A'}",
                              style: kPrimaryTextStyle.copyWith(fontSize: 15),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Log ID: ${data['logId'] ?? 'N/A'}"),
                                Text(
                                  "Created By: ${data['createdBy']?.isEmpty == true ? 'System' : data['createdBy']}",
                                ),
                                Text("Date: $formattedDate"),
                                if (data['soId'] != null)
                                  Text("Related SO: ${data['soId']}"),
                                Text(
                                  "Warehouse: ${data['warehouseId'] ?? 'N/A'}",
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _getActionColor(data['action'] ?? ''),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                data['action'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
