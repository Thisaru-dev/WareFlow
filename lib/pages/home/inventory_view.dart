import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/pages/home/inventory_pages/category_view.dart';
import 'package:wareflow/pages/home/inventory_pages/register_item_view.dart';
import 'package:wareflow/pages/home/manage_items.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final _itemsStream =
      FirebaseFirestore.instance.collection('items').snapshots();
  final TextEditingController _searchController = TextEditingController();
  int? _filtered = 0;
  int? _sorted = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F4F6FB"),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Inventory", style: kTitleTextStyle),
        actions: [
          //filter
          IconButton(
            onPressed: () {
              //showModel bottom sheet
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title text
                          Text(
                            "Filter",
                            style: kPrimaryTextStyle.copyWith(fontSize: 35.sp),
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
                                "In Stock",
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
                            style: kPrimaryTextStyle.copyWith(fontSize: 35.sp),
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
                    controller: _searchController,
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    leading: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search Item name, barcode...",
                    elevation: WidgetStatePropertyAll(0),
                    surfaceTintColor: WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    onChanged: (value) => setState(() {}),
                    trailing: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.qr_code_scanner, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _itemsStream,
                  builder: (context, snapshot) {
                    //error
                    if (snapshot.hasError) {
                      return Center(child: Text("Something went wrong..."));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    List items =
                        docs.where((doc) {
                          final name = doc['name'].toString().toLowerCase();
                          final itemId = doc['id'].toString().toLowerCase();
                          final query = _searchController.text.toLowerCase();

                          return name.contains(query) || itemId.contains(query);
                        }).toList();
                    // sort the list
                    switch (_sorted) {
                      //A to Z
                      case 0:
                        items.sort((a, b) {
                          final nameA = a['name']?.toString() ?? '';
                          final nameB = b['name']?.toString() ?? '';
                          return nameA.compareTo(nameB);
                        });
                        break;

                      case 1:
                        //Z to A
                        items.sort((a, b) {
                          final nameA = a['name']?.toString() ?? '';
                          final nameB = b['name']?.toString() ?? '';
                          return nameB.compareTo(nameA);
                        });
                        break;
                      //high to low
                      case 2:
                        items.sort((a, b) {
                          final qtyA = (a['quantity'] ?? 0) as num;
                          final qtyB = (b['quantity'] ?? 0) as num;
                          return qtyB.compareTo(qtyA);
                        });
                        break;
                      //low to high
                      case 3:
                        items.sort((a, b) {
                          final qtyA = (a['quantity'] ?? 0) as num;
                          final qtyB = (b['quantity'] ?? 0) as num;
                          return qtyA.compareTo(qtyB);
                        });
                        break;
                    }
                    //filter the list
                    if (_filtered == 1) {
                      items =
                          items.where((item) {
                            final qty = (item['quantity'] ?? 0) as num;
                            return qty > 0;
                          }).toList();
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final warehouseMap =
                            item['warehouseQuantities']
                                as Map<String, dynamic>?;

                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.shade100,
                              backgroundImage: NetworkImage(item['img']),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: kPrimaryTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${item['id']}',
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  'Category: ${item['category']}',
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'LKR ${item['price']}',
                                style: kSecondaryTextStyle.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Qty: ${warehouseMap?['warehouse01'] ?? 0}',
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                                // const SizedBox(height: 4),
                                // Text(
                                //   warehouseMap?['warehouse01'] > 0
                                //       ? "In Stock"
                                //       : "Out of Stock",
                                //   style: kSecondaryTextStyle.copyWith(
                                //     fontSize: 12,
                                //     fontWeight: FontWeight.bold,
                                //     color:
                                //         warehouseMap?['warehouse01'] > 0
                                //             ? Colors.green
                                //             : Colors.red,
                                //   ),
                                // ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, size: 20),
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => EditItemPage(
                                                itemId: item['id'],
                                              ),
                                        ),
                                      );
                                    } else if (value == 'delete') {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text('Delete Item'),
                                              content: const Text(
                                                'Are you sure you want to delete this item?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                      );

                                      if (confirm == true) {
                                        await FirebaseFirestore.instance
                                            .collection('items')
                                            .doc(item['id'])
                                            .delete();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Item deleted'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  itemBuilder:
                                      (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
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
            ),
            // Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
            // Text("No Items", style: TextStyle(color: Colors.grey)),
          ],
        ),
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
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (_, __, ___) =>
                          RegisterItemView(), // Your destination page
                  transitionDuration: Duration.zero, // Disable all animations
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            style: kButtonStyle.copyWith(iconAlignment: IconAlignment.start),
            icon: Icon(Icons.playlist_add, color: Colors.white),
            label: Text(
              "Register Item",
              style: kButtonTextStyle.copyWith(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (_, __, ___) => CategoryView(), // Your destination page
                  transitionDuration: Duration.zero, // Disable all animations
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            style: kButtonStyle.copyWith(iconAlignment: IconAlignment.start),
            icon: Icon(Icons.category, color: Colors.white),
            label: Text(
              "Add Category",
              style: kButtonTextStyle.copyWith(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
