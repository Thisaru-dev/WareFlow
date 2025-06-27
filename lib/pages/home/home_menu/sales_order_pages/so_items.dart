import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/so_item_provider.dart';

class SoItems extends StatefulWidget {
  const SoItems({super.key});

  @override
  State<SoItems> createState() => _SoItemsState();
}

class _SoItemsState extends State<SoItems> {
  @override
  Widget build(BuildContext context) {
    final String soId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Sales Order Items", style: kTitleTextStyle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<SoItemProvider>(
              builder: (
                BuildContext context,
                SoItemProvider soItemProvider,
                _,
              ) {
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('sales_orders')
                                .doc(soId)
                                .collection('items')
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
                          final items = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return GestureDetector(
                                onTap: () {
                                  //dialog box for quantity
                                  int quantity =
                                      soItemProvider
                                                  .soItems[item['itemId']]
                                                  ?.orderedQty ==
                                              null
                                          ? 1
                                          : soItemProvider
                                              .soItems[item['itemId']]!
                                              .orderedQty;
                                  final TextEditingController controller =
                                      TextEditingController(
                                        text:
                                            soItemProvider
                                                        .soItems[item['itemId']]
                                                        ?.orderedQty ==
                                                    null
                                                ? '1'
                                                : soItemProvider
                                                    .soItems[item['itemId']]
                                                    ?.orderedQty
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
                                              item['itemName'],
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
                                                    if (quantity > 1) {
                                                      quantity--;
                                                    }
                                                    controller.text =
                                                        quantity.toString();
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
                                                    decoration:
                                                        kInputDecoration,
                                                    style: kInputTextStyle,

                                                    onChanged:
                                                        (value) =>
                                                            quantity =
                                                                int.parse(
                                                                  value,
                                                                ),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                //increase button
                                                IconButton(
                                                  icon: Icon(Icons.add),
                                                  color: kPrimaryColor,
                                                  onPressed: () {
                                                    if (item['orderedQty'] >
                                                        quantity) {
                                                      quantity++;
                                                    }
                                                    controller.text =
                                                        quantity.toString();
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
                                              // print("qty: $quantity");
                                              soItemProvider.addItem(
                                                item['itemId'],
                                                item['itemName'],
                                                item['image'],
                                                quantity,
                                                item['unitPrice'],
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
                                }, //check only show need to be received items
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),

                                    child: ListTile(
                                      leading: Image(
                                        image: NetworkImage(item['image']),
                                        height: 50,
                                        width: 50,
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['itemName'],
                                            style: kPrimaryTextStyle.copyWith(
                                              fontSize: 35.sp,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            item['itemId'],
                                            style: kSecondaryTextStyle.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                      subtitle: Text(
                                        'LKR.${item['unitPrice'].toString()}',
                                        style: kSecondaryTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Qty to pack",
                                              style: kSecondaryTextStyle
                                                  .copyWith(fontSize: 12),
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  soItemProvider.soItems
                                                          .containsKey(
                                                            item['itemId'],
                                                          )
                                                      ? "+${soItemProvider.soItems[item['itemId']]!.orderedQty.toString()}"
                                                      : '',
                                                  style: kSecondaryTextStyle
                                                      .copyWith(
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  " / ${item['orderedQty'].toString()}",
                                                  style: kSecondaryTextStyle
                                                      .copyWith(fontSize: 12),
                                                ),
                                              ],
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
