import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/dispatch_provider.dart';
import 'package:wareflow/providers/item_provider.dart';
import 'package:wareflow/providers/package_provider.dart';
import 'package:wareflow/providers/sales_order_provider.dart';

class CreateDispatch extends StatefulWidget {
  const CreateDispatch({super.key});

  @override
  State<CreateDispatch> createState() => _CreateDispatchState();
}

class _CreateDispatchState extends State<CreateDispatch> {
  final TextEditingController _dispatchIdController = TextEditingController();
  final TextEditingController _soController = TextEditingController();
  final TextEditingController _dispatchDateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  void clearAll() {
    _soController.clear();
    _dispatchDateController.clear();
    _noteController.clear();
    _selectedDate = null;
  }

  String generateShortId() {
    final rand = Random.secure();
    int no = rand.nextInt(9000) + 1000;
    return 'D-$no'; // e.g. D-A7G9X2
  }

  @override
  void initState() {
    super.initState();
    _dispatchDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
    _dispatchIdController.text = generateShortId();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<
      PackageProvider,
      DispatchProvider,
      SalesOrderProvider,
      ItemProvider
    >(
      builder: (
        BuildContext context,
        PackageProvider packageProvider,
        DispatchProvider dispatchProvider,
        SalesOrderProvider salesOrderProvider,
        ItemProvider itemProvider,
        _,
      ) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("Create Dispatch", style: kTitleTextStyle),
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
                                    controller: _dispatchIdController,
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
                                          _dispatchIdController.text =
                                              generateShortId();
                                        },
                                        icon: Icon(
                                          Icons.replay_outlined,
                                          size: 18,
                                        ),
                                      ),
                                      label: Text(
                                        "Dispatch ID",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                    //validate
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter dispatch ID';
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
                                        Icons.person,
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
                                    controller: _dispatchDateController,
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
                                        "Date",
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
                                        _dispatchDateController.text =
                                            _selectedDate!;
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
                                            '/packageselection',
                                            arguments: salesOrderProvider.soId,
                                          ),

                                      label: Text("Add Packages"),
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
                                    "packages",
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      if (packageProvider.packages.isNotEmpty) {
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
                                                "You want to remove all packages from the list?",
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
                                                    packageProvider.clearAll();
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
                                itemCount: packageProvider.packages.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final package =
                                      packageProvider.packages.values
                                          .toList()[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          child: Image(
                                            image: AssetImage('images/box.ico'),
                                          ),
                                        ),
                                        title: Text(
                                          package.packageId,
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
                                              // Text(
                                              //   'To Receive: ${item.receivedQty.toString()} ',
                                              //   style: kSecondaryTextStyle
                                              //       .copyWith(fontSize: 12),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        trailing: IconButton(
                                          color: Colors.red,
                                          onPressed: () {
                                            packageProvider.remove(
                                              package.packageId,
                                            );
                                          },
                                          icon: Icon(
                                            Icons.highlight_remove_rounded,
                                            size: 20,
                                          ),
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
                    if (packageProvider.packages.isNotEmpty) {
                      dispatchProvider.addPackages(
                        packageProvider.selectedPackages,
                      );

                      dispatchProvider.createDispatch(
                        dispatchId: _dispatchIdController.text,
                        companyId: 'COM-001',
                        warehouseId: 'WH-001',
                        soId: salesOrderProvider.soId,
                        dispatchDate: DateTime.parse(_selectedDate!),
                        dispatchStatus: 'DISPATCHED',
                        dispatchNote: _noteController.text,
                      );
                      itemProvider.decreaseQty(
                        packageIds: dispatchProvider.packageIds,
                        warehouseId: "warehouse01",
                      );
                      // itemProvider.decreaseQty(
                      //   packageIds: ,
                      //   warehouseId: ,
                      // );
                      //   grnProvider.addItem(poItemProvider.selectedItems);
                      //   grnProvider.createGrn(
                      //     grnId: _dispatchIdController.text,
                      //     poId: purchaseOrderProvider.poId,
                      //     companyId: 'COM-001',
                      //     warehouseId: 'WH-001',
                      //     grnDate: DateTime.parse(_selectedDate!),
                      //     grnNote: _noteController.text,
                      //     grnStatus: 'ISSUED',
                      //     qcDate: DateTime(0000, 00, 00),
                      //     qcNote: "",
                      //     qcStatus: 'PENDING',
                      //     approval: 'PENDING',
                      //     approvalDate: DateTime(0000, 00, 00),
                      //   );
                      clearAll();
                      packageProvider.clearAll();
                    } else {
                      Snackbar.error(
                        context,
                        "Please add packages to dispatch!",
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
