import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/po_item_provider.dart';

class PoItems extends StatefulWidget {
  const PoItems({super.key});

  @override
  State<PoItems> createState() => _PoItemsState();
}

class _PoItemsState extends State<PoItems> {
  @override
  Widget build(BuildContext context) {
    final String poId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Purchase Order Items", style: kTitleTextStyle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<PoItemProvider>(
              builder: (
                BuildContext context,
                PoItemProvider poItemProvider,
                _,
              ) {
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('purchase_orders')
                                .doc(poId)
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
                          final allItems = snapshot.data!.docs;
                          final items =
                              allItems.where((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return (data['receivedQty'] ?? 0) <
                                    (data['orderedQty'] ?? 0);
                              }).toList();
                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item =
                                  items[index].data() as Map<String, dynamic>;
                              final orderedQty = item['orderedQty'] ?? 0;
                              final receivedQty = item['receivedQty'] ?? 0;
                              final remainingQty = orderedQty - receivedQty;
                              return GestureDetector(
                                onTap: () {
                                  //dialog box for quantity
                                  int quantity =
                                      poItemProvider
                                                  .poItems[item['itemId']]
                                                  ?.receivedQty ==
                                              null
                                          ? 1
                                          : poItemProvider
                                              .poItems[item['itemId']]!
                                              .receivedQty;
                                  final TextEditingController controller =
                                      TextEditingController(
                                        text:
                                            poItemProvider
                                                        .poItems[item['itemId']]
                                                        ?.receivedQty ==
                                                    null
                                                ? '1'
                                                : poItemProvider
                                                    .poItems[item['itemId']]
                                                    ?.receivedQty
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
                                                    if (remainingQty >
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
                                              poItemProvider.addItem(
                                                item['itemId'],
                                                item['itemName'],
                                                item['image'],
                                                item['orderedQty'],
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
                                              "Qty to receive",
                                              style: kSecondaryTextStyle
                                                  .copyWith(fontSize: 12),
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  poItemProvider.poItems
                                                          .containsKey(
                                                            item['itemId'],
                                                          )
                                                      ? "+${poItemProvider.poItems[item['itemId']]!.receivedQty.toString()}"
                                                      : '',
                                                  style: kSecondaryTextStyle
                                                      .copyWith(
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  " / ${(item['orderedQty'] - item['receivedQty']).toString()}",
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
