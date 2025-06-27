import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/returnable_item_provider.dart';

class PackageItemSelection extends StatefulWidget {
  const PackageItemSelection({super.key});

  @override
  State<PackageItemSelection> createState() => _PackageItemSelectionState();
}

class _PackageItemSelectionState extends State<PackageItemSelection> {
  //dialog box controllers
  final TextEditingController _returnQtyController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String packageId =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Return Items", style: kTitleTextStyle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<ReturnableItemProvider>(
              builder: (
                BuildContext context,
                ReturnableItemProvider returnableItemProvider,
                _,
              ) {
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('packages')
                                .doc(packageId)
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
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Enter Inspection Details",
                                          style: kTitleTextStyle.copyWith(
                                            fontSize: 40.sp,
                                          ),
                                        ),
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'item',
                                                style: kSecondaryTextStyle,
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Return Qty"),

                                                  //quantity text field
                                                  SizedBox(
                                                    width: 70,
                                                    height: 40,
                                                    child: TextField(
                                                      controller:
                                                          _returnQtyController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          kInputDecoration,
                                                      style: kInputTextStyle
                                                          .copyWith(
                                                            fontSize: 14,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              SizedBox(
                                                width: 400,
                                                child: TextField(
                                                  controller: _reasonController,
                                                  decoration: kInputDecoration
                                                      .copyWith(
                                                        hintText: "Reason",
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                              returnableItemProvider
                                                  .setSelectedItems(
                                                    item['itemId'],
                                                    item['itemName'],
                                                    item['image'],
                                                    item['orderedQty'],
                                                    int.tryParse(
                                                          _returnQtyController
                                                              .text,
                                                        ) ??
                                                        0,
                                                    _reasonController.text,
                                                    item['unitPrice'],
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
                                    // controller.clear();
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
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ReturnQty: ${returnableItemProvider.returnQty} ',

                                            style: kSecondaryTextStyle.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            'Reason: ${returnableItemProvider.reason}',
                                            style: kSecondaryTextStyle.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Text(
                                            //   returnableItemProvider
                                            //           .returnableItems
                                            //           .containsKey(
                                            //             item['itemId'],
                                            //           )
                                            //       ? "quantity: +${returnableItemProvider.returnableItems[item['itemId']]!.qualityIssuesQty.toString()}"
                                            //       : '',
                                            //   style: kSecondaryTextStyle
                                            //       .copyWith(
                                            //         color: kPrimaryColor,
                                            //         fontSize: 10,
                                            //         fontWeight: FontWeight.bold,
                                            //       ),
                                            // ),
                                            // Text(
                                            //   returnableItemProvider
                                            //           .returnableItems
                                            //           .containsKey(
                                            //             item['itemId'],
                                            //           )
                                            //       ? "quantity: +${returnableItemProvider.returnableItems[item['itemId']]!.returnedQty.toString()}"
                                            //       : '',
                                            //   style: kSecondaryTextStyle
                                            //       .copyWith(
                                            //         color: kPrimaryColor,
                                            //         fontSize: 10,
                                            //         fontWeight: FontWeight.bold,
                                            //       ),
                                            // ),
                                            // Text(
                                            //   returnableItemProvider
                                            //           .returnableItems
                                            //           .containsKey(
                                            //             item['itemId'],
                                            //           )
                                            //       ? "quantity: +${returnableItemProvider.returnableItems[item['itemId']]!.returnedQty.toString()}"
                                            //       : '',
                                            //   style: kSecondaryTextStyle
                                            //       .copyWith(
                                            //         color: kPrimaryColor,
                                            //         fontSize: 10,
                                            //         fontWeight: FontWeight.bold,
                                            //       ),
                                            // ),
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
