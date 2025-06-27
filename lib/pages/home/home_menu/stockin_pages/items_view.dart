import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/stock_in_item_provider.dart';

class ItemView extends StatefulWidget {
  const ItemView({super.key});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    final String supplierId =
        ModalRoute.of(context)!.settings.arguments as String;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Items", style: kTitleTextStyle),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add_box_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.qr_code_scanner)),
        ],
      ),
      body: SafeArea(
        //consumer
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
                  width: screenWidth,

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
                    child: SizedBox(
                      width: 330,
                      height: 40,

                      child: SearchBar(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        leading: Icon(Icons.search, color: Colors.grey),
                        hintText: "Search name, barcode, category",
                        elevation: WidgetStatePropertyAll(0),
                        surfaceTintColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        hintStyle: WidgetStatePropertyAll(
                          TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('items')
                              .where('supplierId', isEqualTo: supplierId)
                              .snapshots(),
                      builder: (context, snapshot) {
                        //error
                        if (snapshot.hasError) {
                          return Center(child: Text("Something went wrong..."));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final items = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return GestureDetector(
                              onTap: () {
                                //dialog box for quantity
                                int quantity =
                                    stockInItemProvider
                                                .items[item.id]
                                                ?.quantity ==
                                            null
                                        ? 1
                                        : stockInItemProvider
                                            .items[item.id]!
                                            .quantity;
                                final TextEditingController controller =
                                    TextEditingController(
                                      text:
                                          stockInItemProvider
                                                      .items[item.id]
                                                      ?.quantity ==
                                                  null
                                              ? '1'
                                              : stockInItemProvider
                                                  .items[item.id]
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
                                                  current++;
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
                                              item.id,
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
                                          item.id,
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
                                                    .containsKey(item.id)
                                                ? "+${stockInItemProvider.items[item.id]!.quantity.toString()}"
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
              ],
            );
          },
        ),
      ),
    );
  }
}
