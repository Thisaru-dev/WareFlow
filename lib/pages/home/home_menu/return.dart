import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/pages/home/home_menu/create_pages/create_purchase_return.dart';
import 'package:wareflow/pages/home/home_menu/create_pages/create_sales_return.dart';
import 'package:wareflow/providers/permission_provider.dart';

class Return extends StatefulWidget {
  const Return({super.key});

  @override
  State<Return> createState() => _ReturnState();
}

class _ReturnState extends State<Return> {
  final _returnStream =
      FirebaseFirestore.instance.collection('returns').snapshots();
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
        title: Text("Return", style: kTitleTextStyle),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 60,
        type: ExpandableFabType.up,
        childrenAnimation: ExpandableFabAnimation.none,

        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
        children: [
          permissionProvider.hasPermission('manage_po')
              ? ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (_, __, ___) =>
                              CreatePurchaseReturn(), // Your destination page
                      transitionDuration:
                          Duration.zero, // Disable all animations
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                style: kButtonStyle.copyWith(
                  iconAlignment: IconAlignment.start,
                ),
                icon: Icon(Icons.playlist_add, color: Colors.white),
                label: Text(
                  "Purchase Return",
                  style: kButtonTextStyle.copyWith(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              )
              : SizedBox(),

          permissionProvider.hasPermission("manage_so")
              ? ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (_, __, ___) =>
                              CreateSalesReturn(), // Your destination page
                      transitionDuration:
                          Duration.zero, // Disable all animations
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                style: kButtonStyle.copyWith(
                  iconAlignment: IconAlignment.start,
                ),
                icon: Icon(Icons.category, color: Colors.white),
                label: Text(
                  "Sales Return",
                  style: kButtonTextStyle.copyWith(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              )
              : SizedBox(),
        ],
      ),
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
              stream: _returnStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error on Stream');
                } else if (!snapshot.hasData) {
                  return Text('No data');
                }
                final returns = snapshot.data!.docs;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: returns.length,
                      itemBuilder: (context, index) {
                        final r = returns[index];
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
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.grey.shade100,
                                          child: Icon(
                                            Icons.rotate_90_degrees_ccw,
                                            size: 28,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                r['id'],
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
                                                        r['returnDate'],
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
                                                  Icon(
                                                    Icons.link,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    r['referenceId'],
                                                    style: kSecondaryTextStyle
                                                        .copyWith(
                                                          fontSize: 13,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      r['type'] ==
                                                              'Purchase Return'
                                                          ? Colors
                                                              .orange
                                                              .shade50
                                                          : Colors.blue.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  r['type'],
                                                  style: kSecondaryTextStyle
                                                      .copyWith(
                                                        fontSize: 13,
                                                        color:
                                                            r['type'] ==
                                                                    'Purchase Return'
                                                                ? Colors.orange
                                                                : Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/returnDetails',
                                            arguments: r['id'],
                                          );
                                        },
                                        icon: Icon(
                                          Icons.visibility_outlined,
                                          size: 16,
                                        ),
                                        label: Text(
                                          'View',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue.shade800,
                                          ),
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
