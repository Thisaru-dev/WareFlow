import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/stock_in_item_provider.dart';

class InventoryItems extends StatefulWidget {
  const InventoryItems({super.key});

  @override
  State<InventoryItems> createState() => _InventoryItemsState();
}

class _InventoryItemsState extends State<InventoryItems> {
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
        title: Text("Items", style: kTitleTextStyle),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
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
        child: Consumer<StockInItemProvider>(
          builder: (
            BuildContext context,
            StockInItemProvider stockInItemProvider,
            Widget? child,
          ) {
            return Column(
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
                            icon: Icon(
                              Icons.qr_code_scanner,
                              color: Colors.grey,
                            ),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final docs = snapshot.data!.docs;
                        List items =
                            docs.where((doc) {
                              final name = doc['name'].toString().toLowerCase();
                              final itemId = doc['id'].toString().toLowerCase();
                              final query =
                                  _searchController.text.toLowerCase();

                              return name.contains(query) ||
                                  itemId.contains(query);
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

                            return GestureDetector(
                              onTap: () {
                                //dialog box for quantity
                                int quantity =
                                    stockInItemProvider
                                                .items[item['id']]
                                                ?.quantity ==
                                            null
                                        ? 1
                                        : stockInItemProvider
                                            .items[item['id']]!
                                            .quantity;
                                final TextEditingController controller =
                                    TextEditingController(
                                      text:
                                          stockInItemProvider
                                                      .items[item['id']]
                                                      ?.quantity ==
                                                  null
                                              ? '1'
                                              : stockInItemProvider
                                                  .items[item['id']]
                                                  ?.quantity
                                                  .toString(),
                                    );

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Enter Quantity",
                                        style: kTitleTextStyle.copyWith(
                                          fontSize: 40.sp,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item['name'],
                                            style: kSecondaryTextStyle,
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //decrease button
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                color: kPrimaryColor,
                                                onPressed: () {
                                                  int current =
                                                      int.tryParse(
                                                        controller.text,
                                                      ) ??
                                                      1;
                                                  if (current > 1) {
                                                    current--;
                                                  }
                                                  controller.text =
                                                      current.toString();
                                                  setState(() {
                                                    quantity = current;
                                                  });
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              //quantity text field
                                              SizedBox(
                                                width: 70,
                                                height: 40,
                                                child: TextField(
                                                  controller: controller,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  decoration: kInputDecoration,
                                                  style: kInputTextStyle,

                                                  onChanged:
                                                      (value) => setState(() {
                                                        quantity = int.parse(
                                                          value,
                                                        );
                                                      }),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              //increase button
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                color: kPrimaryColor,
                                                onPressed: () {
                                                  int current =
                                                      int.tryParse(
                                                        controller.text,
                                                      ) ??
                                                      1;
                                                  if (current <
                                                      item['quantity']) {
                                                    current++;
                                                  }

                                                  controller.text =
                                                      current.toString();
                                                  setState(() {
                                                    quantity = current;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      actions: [
                                        //cancel button
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },

                                          child: Text(
                                            "Cancle",
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                        //confirm button
                                        FilledButton(
                                          onPressed: () {
                                            stockInItemProvider.addItem(
                                              item['id'],
                                              item['img'],
                                              item['name'],
                                              quantity,
                                              item['price'],
                                              item['supplierId'],
                                              item['category'],
                                              item['description'],
                                              item['companyId'],
                                              item['lowStockThreshold'],
                                              item['warehouseQuantities'],
                                            );
                                            Snackbar.success(
                                              context,
                                              "Item added successfully!",
                                            );
                                            Navigator.pop(context);
                                          },
                                          style: kButtonStyle,
                                          child: Text("Confirm"),
                                        ),
                                      ],
                                    );
                                  },
                                ).then((_) {
                                  controller.clear();
                                });
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ListTile(
                                    leading: Image(
                                      image: NetworkImage(item['img']),
                                      height: 50,
                                      width: 50,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: kPrimaryTextStyle.copyWith(
                                            fontSize: 35.sp,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          item['id'],
                                          style: kSecondaryTextStyle.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                    subtitle: Text(
                                      'LKR.${item['price'].toString()}',
                                      style: kSecondaryTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: 60,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Qty : ${item['quantity'].toString()}",
                                            style: kSecondaryTextStyle.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            stockInItemProvider.items
                                                    .containsKey(item['id'])
                                                ? "+${stockInItemProvider.items[item['id']]!.quantity.toString()}"
                                                : '',
                                            style: kSecondaryTextStyle.copyWith(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
            );
          },
        ),
      ),
    );
  }
}
