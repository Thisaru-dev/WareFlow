import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/permission_provider.dart';

class PurchaseOrder extends StatefulWidget {
  const PurchaseOrder({super.key});

  @override
  State<PurchaseOrder> createState() => _PurchaseOrderState();
}

class _PurchaseOrderState extends State<PurchaseOrder> {
  final TextEditingController _searchController = TextEditingController();
  int? _filtered = 0;
  int? _sorted = 0;
  final _poStream =
      FirebaseFirestore.instance.collection('purchase_orders').snapshots();
  String poState = 'Issued';
  @override
  Widget build(BuildContext context) {
    final permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: Text("Purchase Order", style: kTitleTextStyle),
          actions: [
            //filter
            IconButton(
              onPressed: () {
                //showModel bottom sheet
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 350,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //title text
                            Text(
                              "Filter",
                              style: kPrimaryTextStyle.copyWith(
                                fontSize: 35.sp,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _filtered = 0;
                                    Navigator.pop(context);
                                  }),
                              child: ListTile(
                                title: Text(
                                  "All",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                trailing:
                                    _filtered == 0
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _filtered = 1;
                                    Navigator.pop(context);
                                  }),
                              child: ListTile(
                                title: Text(
                                  "Pending",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                trailing:
                                    _filtered == 1
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _filtered = 2;
                                    Navigator.pop(context);
                                  }),
                              child: ListTile(
                                title: Text(
                                  "Approved",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                trailing:
                                    _filtered == 2
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _filtered = 3;
                                    Navigator.pop(context);
                                  }),
                              child: ListTile(
                                title: Text(
                                  "Not Approved",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                trailing:
                                    _filtered == 3
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _filtered = 5;
                                    Navigator.pop(context);
                                  }),
                              child: ListTile(
                                title: Text(
                                  "Closed",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                trailing:
                                    _filtered == 5
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.filter_alt_outlined),
            ),
            //sort
            IconButton(
              onPressed: () {
                //showModel bottom sheet
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //title text
                            Text(
                              "Sort By",
                              style: kPrimaryTextStyle.copyWith(
                                fontSize: 35.sp,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _sorted = 0;
                                    Navigator.pop(context);
                                  }),
                              child: ListTile(
                                title: Text(
                                  "A to Z",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                trailing:
                                    _sorted == 0
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _sorted = 1;
                                    Navigator.pop(context);
                                  }),
                              child: ListTile(
                                title: Text(
                                  "Z to A",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                trailing:
                                    _sorted == 1
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _sorted = 2;
                                    Navigator.pop(context);
                                  }),
                              child: ListTile(
                                title: Text(
                                  "High to Low",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                trailing:
                                    _sorted == 2
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _sorted = 3;
                                    Navigator.pop(context);
                                  }),
                              child: ListTile(
                                title: Text(
                                  "Low to High",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                trailing:
                                    _sorted == 3
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.sort),
            ),
          ],
        ),
        floatingActionButton:
            permissionProvider.hasPermission('manage_po')
                ? FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/createpo');
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
                      controller: _searchController,
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
                stream: _poStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error on Stream');
                  } else if (!snapshot.hasData) {
                    return Text('No data');
                  }
                  final docs = snapshot.data!.docs;
                  List purchaseOrders =
                      docs.where((doc) {
                        final name =
                            doc['supplierName'].toString().toLowerCase();
                        final itemId = doc['id'].toString().toLowerCase();
                        final query = _searchController.text.toLowerCase();

                        return name.contains(query) || itemId.contains(query);
                      }).toList();
                  // sort the list
                  switch (_sorted) {
                    //A to Z
                    case 0:
                      purchaseOrders.sort((a, b) {
                        final nameA = a['supplierName']?.toString() ?? '';
                        final nameB = b['supplierName']?.toString() ?? '';
                        return nameA.compareTo(nameB);
                      });
                      break;

                    case 1:
                      //Z to A
                      purchaseOrders.sort((a, b) {
                        final nameA = a['supplierName']?.toString() ?? '';
                        final nameB = b['supplierName']?.toString() ?? '';
                        return nameB.compareTo(nameA);
                      });
                      break;
                    //high to low
                    case 2:
                      purchaseOrders.sort((a, b) {
                        final qtyA = (a['totalAmount'] ?? 0) as num;
                        final qtyB = (b['totalAmount'] ?? 0) as num;
                        return qtyB.compareTo(qtyA);
                      });
                      break;
                    //low to high
                    case 3:
                      purchaseOrders.sort((a, b) {
                        final qtyA = (a['totalAmount'] ?? 0) as num;
                        final qtyB = (b['totalAmount'] ?? 0) as num;
                        return qtyA.compareTo(qtyB);
                      });
                      break;
                  }
                  //filter the list
                  if (_filtered == 1) {
                    purchaseOrders =
                        purchaseOrders.where((so) {
                          final sts = so['status'] ?? '';
                          return sts == "PENDING";
                        }).toList();
                  }

                  if (_filtered == 2) {
                    purchaseOrders =
                        purchaseOrders.where((so) {
                          final sts = so['status'] ?? '';
                          return sts == "APPROVED";
                        }).toList();
                  }
                  if (_filtered == 3) {
                    purchaseOrders =
                        purchaseOrders.where((so) {
                          final sts = so['status'] ?? '';
                          return sts == "NOT APPROVED";
                        }).toList();
                  }
                  if (_filtered == 4) {
                    purchaseOrders =
                        purchaseOrders.where((so) {
                          final sts = so['status'] ?? '';
                          return sts == "CLOSED";
                        }).toList();
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: purchaseOrders.length,
                        itemBuilder: (context, index) {
                          final po = purchaseOrders[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 2,
                            ),
                            child: GestureDetector(
                              onTap:
                                  () => Navigator.pushNamed(
                                    context,
                                    '/podetails',
                                    arguments: po['id'],
                                  ),
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.blue.shade50,
                                          child: Image.asset(
                                            "images/in.ico", // Your PO icon
                                            scale: 2.5,
                                          ),
                                        ),
                                        title: Text(
                                          po['supplierName'] ?? '',
                                          style: kPrimaryTextStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Text(
                                            po['status'] ?? '',
                                            style: TextStyle(
                                              color:
                                                  (po['status'] == 'REJECTED')
                                                      ? Colors.redAccent
                                                      : (po['status'] ==
                                                          'APPROVED')
                                                      ? Colors.green.shade700
                                                      : Colors.grey.shade600,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'LKR ${po['totalAmount'].toString()}',
                                              style: kSecondaryTextStyle
                                                  .copyWith(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors
                                                            .blueGrey
                                                            .shade700,
                                                  ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              po['id'] ?? '',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            size: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            DateFormat('MMMM d, yyyy').format(
                                              DateTime.parse(
                                                po['expectedDate'],
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          Spacer(),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pushNamed(
                                                  context,
                                                  '/podetails', // Replace with your PO detail route
                                                  arguments: po['id'],
                                                ),
                                            child: Text(
                                              "View details >",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.blue.shade800,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
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
      ),
    );
  }
}
