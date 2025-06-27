import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/grn_provider.dart';
import 'package:wareflow/providers/return_provider.dart';
import 'package:wareflow/providers/returnable_item_provider.dart';

class CreatePurchaseReturn extends StatefulWidget {
  const CreatePurchaseReturn({super.key});

  @override
  State<CreatePurchaseReturn> createState() => _CreatePurchaseReturnState();
}

class _CreatePurchaseReturnState extends State<CreatePurchaseReturn> {
  final TextEditingController _returnIdController = TextEditingController();
  final TextEditingController _grnController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  void clearAll() {
    _grnController.clear();
    _returnDateController.clear();
    _noteController.clear();
    _selectedDate = null;
  }

  String generateShortId() {
    final rand = Random.secure();
    int no = rand.nextInt(9000) + 1000;
    return 'PR-$no'; // e.g. PR-A7G9X2
  }

  @override
  void initState() {
    super.initState();
    _returnIdController.text = generateShortId();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ReturnableItemProvider, GrnProvider, ReturnProvider>(
      builder: (
        BuildContext context,
        ReturnableItemProvider returnableItemProvider,
        GrnProvider grnProvider,
        ReturnProvider returnProvider,
        _,
      ) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("Create Purchase Return", style: kTitleTextStyle),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _returnIdController,
                                    readOnly: true,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.style_sharp,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _returnIdController.text =
                                              generateShortId();
                                        },
                                        icon: Icon(
                                          Icons.replay_outlined,
                                          size: 18,
                                        ),
                                      ),
                                      label: Text(
                                        "Return ID",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                    //validate
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter return ID';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _grnController,
                                    readOnly: true,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.person,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      label: Text(
                                        "Returnable GRN",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    //validate
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a Returnable GRN';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/returnablegrnselection',
                                      ).then((_) {
                                        _grnController.text = grnProvider.grnId;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _returnDateController,
                                    readOnly: true,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.date_range,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      label: Text(
                                        "Return Date",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      setState(() {
                                        _selectedDate = DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(picked!);
                                        _returnDateController.text =
                                            _selectedDate!;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select the Return date";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _noteController,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.note,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      label: Text(
                                        "Notes",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Card(
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 355,
                                    child: OutlinedButton.icon(
                                      style: kButtonStyle.copyWith(
                                        textStyle: WidgetStatePropertyAll(
                                          kSecondaryTextStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        side: WidgetStatePropertyAll(
                                          BorderSide(color: kPrimaryColor),
                                        ),
                                        foregroundColor: WidgetStatePropertyAll(
                                          kPrimaryColor,
                                        ),
                                        iconAlignment: IconAlignment.start,
                                        iconColor: WidgetStatePropertyAll(
                                          kPrimaryColor,
                                        ),
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.white,
                                        ),
                                      ),
                                      onPressed:
                                          () => Navigator.pushNamed(
                                            context,
                                            '/returnableitemselection',
                                            arguments: grnProvider.grnId,
                                          ),

                                      label: Text("Add Item"),
                                      icon: Icon(Icons.add_circle_rounded),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Items",
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      if (returnableItemProvider
                                          .returnableItems
                                          .isNotEmpty) {
                                        //dialog box
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Are you sure?",
                                                style: kTitleTextStyle.copyWith(
                                                  fontSize: 40.sp,
                                                ),
                                              ),
                                              content: Text(
                                                "You want to remove all items from the list?",
                                                style: kSecondaryTextStyle
                                                    .copyWith(fontSize: 13),
                                              ),

                                              actions: [
                                                //no button
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },

                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                                //yes button
                                                FilledButton(
                                                  onPressed: () {
                                                    returnableItemProvider
                                                        .clear();
                                                    Navigator.pop(context);
                                                  },
                                                  style: kButtonStyle,
                                                  child: Text("Yes"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    label: Text(
                                      "Remove all",
                                      style: kSecondaryTextStyle.copyWith(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                              Divider(),

                              ListView.builder(
                                itemCount:
                                    returnableItemProvider
                                        .returnableItems
                                        .length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item =
                                      returnableItemProvider
                                          .returnableItems
                                          .values
                                          .toList()[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          child: Image(
                                            image: NetworkImage(item.image),
                                          ),
                                        ),
                                        title: Text(
                                          item.itemName,
                                          style: kPrimaryTextStyle.copyWith(
                                            fontSize: 13,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   'Received: ${item.receivedQty.toString()} / ${item.orderedQty.toString()}',
                                              //   style: kSecondaryTextStyle
                                              //       .copyWith(fontSize: 12),
                                              // ),
                                              Text(
                                                'quantity: ${item.returnQty.toString()} ',
                                                style: kSecondaryTextStyle
                                                    .copyWith(fontSize: 12),
                                              ),
                                              Text(
                                                'quality: ${item.reason.toString()} ',
                                                style: kSecondaryTextStyle
                                                    .copyWith(fontSize: 12),
                                              ),
                                              // Text(
                                              //   'wrong item: ${item.wrongItemsQty.toString()} ',
                                              //   style: kSecondaryTextStyle
                                              //       .copyWith(fontSize: 12),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        // trailing: Row(
                                        //   mainAxisSize: MainAxisSize.min,

                                        //   children: [
                                        //     IconButton(
                                        //       color: Colors.blueGrey,
                                        //       onPressed: () {
                                        //         returnableItemProvider
                                        //             .removeSingleItem(
                                        //               item.itemId,
                                        //             );
                                        //       },
                                        //       icon: Icon(
                                        //         Icons.remove_circle,
                                        //         size: 20,
                                        //       ),
                                        //     ),
                                        //     IconButton(
                                        //       color: Colors.red,
                                        //       onPressed: () {
                                        //         returnableItemProvider
                                        //             .removeItem(item.itemId);
                                        //         // Snackbar.info(
                                        //         //   context,
                                        //         //   "Item removed!",
                                        //         // );
                                        //       },
                                        //       icon: Icon(
                                        //         Icons.highlight_remove,
                                        //         size: 20,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (returnableItemProvider.returnableItems.isNotEmpty) {
                      returnProvider.addItem(
                        returnableItemProvider.selectedItems,
                      );
                      returnProvider.createReturn(
                        id: _returnIdController.text,
                        type: "purchase return",
                        companyId: 'COM-001',
                        warehouseId: 'WH-001',
                        referenceId: grnProvider.grnId,
                        createdBy: '',
                        returnDate: DateTime.parse(_selectedDate!),
                        note: _noteController.text,
                      );

                      clearAll();
                      returnableItemProvider.clear();
                    } else {
                      Snackbar.error(context, "Please add items to return!");
                    }
                  }
                },
                style: kButtonStyle,

                child: Text(
                  "Save",
                  style: kButtonTextStyle.copyWith(fontSize: 14),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
