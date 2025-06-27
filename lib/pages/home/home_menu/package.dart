import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/permission_provider.dart';

class Package extends StatefulWidget {
  const Package({super.key});

  @override
  State<Package> createState() => _PackageState();
}

class _PackageState extends State<Package> {
  final _packageStream =
      FirebaseFirestore.instance.collection('packages').snapshots();
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
        title: Text("Package", style: kTitleTextStyle),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
        ],
      ),
      floatingActionButton:
          permissionProvider.hasPermission('manage_packages')
              ? FloatingActionButton(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/createpackage');
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
              stream: _packageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error on Stream');
                } else if (!snapshot.hasData) {
                  return Text('No data');
                }
                final packages = snapshot.data!.docs;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final package = packages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                          child: GestureDetector(
                            // onTap:
                            //     () => Navigator.pushNamed(
                            //       context,
                            //       '/podetails',
                            //       arguments: po['id'],
                            //     ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.white,
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
                                    // Header row with avatar and title
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.grey.shade100,
                                          child: Image.asset(
                                            "images/package.ico",
                                            scale: 1.5,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                package['packageId'],
                                                style: kPrimaryTextStyle
                                                    .copyWith(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    DateFormat(
                                                      'MMMM d, yyyy',
                                                    ).format(
                                                      DateTime.parse(
                                                        package['packageDate'],
                                                      ),
                                                    ),
                                                    style: kSecondaryTextStyle
                                                        .copyWith(
                                                          fontSize: 13,
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    package['soId'],
                                                    style: kSecondaryTextStyle
                                                        .copyWith(
                                                          fontSize: 13,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    // Status badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Package Status: ${package['packageStatus']}',
                                        style: kSecondaryTextStyle.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
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
