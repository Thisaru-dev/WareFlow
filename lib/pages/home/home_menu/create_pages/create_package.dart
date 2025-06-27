import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/package_provider.dart';
import 'package:wareflow/providers/sales_order_provider.dart';
import 'package:wareflow/providers/so_item_provider.dart';

class CreatePackage extends StatefulWidget {
  const CreatePackage({super.key});

  @override
  State<CreatePackage> createState() => _CreatePackageState();
}

class _CreatePackageState extends State<CreatePackage> {
  final TextEditingController _packageIdController = TextEditingController();
  final TextEditingController _soController = TextEditingController();
  final TextEditingController _packageDateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final _formKey = GlobalKey<FormState>();
  void clearAll() {
    _soController.clear();
    _packageDateController.clear();
    _noteController.clear();
  }

  String generateShortId() {
    final rand = Random.secure();
    int no = rand.nextInt(9000) + 1000;
    return 'PACK-$no'; // e.g. PACK-A7G9X2
  }

  @override
  void initState() {
    super.initState();
    _packageIdController.text = generateShortId();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<SoItemProvider, SalesOrderProvider, PackageProvider>(
      builder: (
        BuildContext context,
        SoItemProvider soItemProvider,
        SalesOrderProvider salesOrderProvider,
        PackageProvider packageProvider,
        _,
      ) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("Create Package", style: kTitleTextStyle),
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
                                    controller: _packageIdController,
                                    readOnly: true,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.shopify,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _packageIdController.text =
                                              generateShortId();
                                        },
                                        icon: Icon(
                                          Icons.replay_outlined,
                                          size: 18,
                                        ),
                                      ),
                                      label: Text(
                                        "package ID",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                    //validate
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter package ID';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _soController,
                                    readOnly: true,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.star_purple500_sharp,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      label: Text(
                                        "Sales Order",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    //validate
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a Sales Order';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/soselection',
                                      ).then((_) {
                                        _soController.text =
                                            salesOrderProvider.soId;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _packageDateController,
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
                                        "Package Date",
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
                                        _packageDateController.text =
                                            _selectedDate;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select the issued date";
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
                                            '/soitems',
                                            arguments: salesOrderProvider.soId,
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
                                      if (soItemProvider.soItems.isNotEmpty) {
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
                                                    soItemProvider.clear();
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
                                itemCount: soItemProvider.soItems.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item =
                                      soItemProvider.soItems.values
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
                                          child: Text(
                                            'To Pack: ${item.orderedQty.toString()}',
                                            style: kSecondaryTextStyle.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,

                                          children: [
                                            IconButton(
                                              color: Colors.blueGrey,
                                              onPressed: () {
                                                soItemProvider.removeSingleItem(
                                                  item.itemId,
                                                );
                                              },
                                              icon: Icon(
                                                Icons.remove_circle,
                                                size: 20,
                                              ),
                                            ),
                                            IconButton(
                                              color: Colors.red,
                                              onPressed: () {
                                                soItemProvider.removeItem(
                                                  item.itemId,
                                                );
                                                Snackbar.info(
                                                  context,
                                                  "Item removed!",
                                                );
                                              },
                                              icon: Icon(
                                                Icons.highlight_remove,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
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
                    if (soItemProvider.soItems.isNotEmpty) {
                      packageProvider.addItem(soItemProvider.selectedItems);
                      packageProvider.createPackage(
                        packageId: _packageIdController.text,
                        soId: salesOrderProvider.soId,
                        warehouseId: salesOrderProvider.warehouseId,
                        companyId: salesOrderProvider.companyId,
                        createdBy: "",
                        packageDate: DateTime.parse(_selectedDate),
                        packageNote: _noteController.text,
                        packageStatus: "CREATED",
                      );
                      clearAll();
                      soItemProvider.clear();
                    } else {
                      Snackbar.error(
                        context,
                        "Please add items for packaging!",
                      );
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
