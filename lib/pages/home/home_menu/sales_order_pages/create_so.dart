import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/pdf/sales_order_pdf.dart';
import 'package:wareflow/pdf/save_and_open_pdf.dart';
import 'package:wareflow/providers/customer_provider.dart';
import 'package:wareflow/providers/sales_order_provider.dart';
import 'package:wareflow/providers/stock_in_item_provider.dart';
import 'package:wareflow/providers/warehouse_provider.dart';

class CreateSo extends StatefulWidget {
  const CreateSo({super.key});

  @override
  State<CreateSo> createState() => _CreateSoState();
}

class _CreateSoState extends State<CreateSo> {
  final TextEditingController _soIdController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _edateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _expectedDeliveryDate;

  final user = FirebaseAuth.instance.currentUser;
  String companyId = 'pms123';

  void clearAll() {
    _customerController.clear();
    _notesController.clear();
    _expectedDeliveryDate = null;
  }

  String generateShortId() {
    final rand = Random.secure();
    int no = rand.nextInt(9000) + 1000;
    return 'SO-$no'; // e.g. SO-A7G9X2
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soIdController.text = generateShortId();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer4<
      StockInItemProvider,
      WarehouseProvider,
      CustomerProvider,
      SalesOrderProvider
    >(
      builder: (
        BuildContext context,
        StockInItemProvider stockInItemProvider,
        WarehouseProvider warehouseProvider,
        CustomerProvider customerProvider,
        SalesOrderProvider salesOrderProvider,
        _,
      ) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("New Sales Order", style: kTitleTextStyle),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 1,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _soIdController,
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
                                          _soIdController.text =
                                              generateShortId();
                                        },
                                        icon: Icon(
                                          Icons.replay_outlined,
                                          size: 18,
                                        ),
                                      ),
                                      label: Text(
                                        "Sales Order ID",
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
                                    controller: _customerController,
                                    readOnly: true,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.person,
                                        size: 18,
                                        color: kPrimaryTextColor,
                                      ),
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      label: Text(
                                        "Customer",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: kPrimaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    //validate
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a customer';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/customerSelection',
                                      ).then((_) {
                                        _customerController.text =
                                            customerProvider.customerName;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _notesController,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.note_alt,
                                        size: 18,
                                        color: kPrimaryTextColor,
                                      ),
                                      label: Text(
                                        "Notes",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: kPrimaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15),
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _edateController,
                                    readOnly: true,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.date_range,
                                        size: 18,
                                        color: kPrimaryTextColor,
                                      ),
                                      label: Text(
                                        "Expected Delivery Date",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: kPrimaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a expected delivery date';
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      setState(() {
                                        _expectedDeliveryDate = DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(picked!);
                                        _edateController.text =
                                            _expectedDeliveryDate!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 1,
                        color: Colors.white,
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
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/inventoryitems',
                                        );
                                      },
                                      label: Text("Add Item"),
                                      icon: Icon(Icons.add_circle_rounded),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "Items",
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  TextButton.icon(
                                    onPressed: () {
                                      if (stockInItemProvider
                                          .items
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
                                                    stockInItemProvider.clear();
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
                              stockInItemProvider.items.isNotEmpty
                                  ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: stockInItemProvider.items.length,
                                    itemBuilder: (context, index) {
                                      final selectedItem =
                                          stockInItemProvider.items.values
                                              .toList()[index];
                                      return Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              child: Image(
                                                image: NetworkImage(
                                                  selectedItem.img,
                                                ),
                                              ),
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  selectedItem.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: kPrimaryTextStyle
                                                      .copyWith(fontSize: 13),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  selectedItem.id,
                                                  style: kSecondaryTextStyle
                                                      .copyWith(fontSize: 12),
                                                ),
                                                SizedBox(height: 5),
                                              ],
                                            ),
                                            subtitle: Text(
                                              'LKR.${selectedItem.price.toString()} x ${selectedItem.quantity}',
                                              style: kSecondaryTextStyle
                                                  .copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: kPrimaryColor,
                                                  ),
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    stockInItemProvider
                                                        .removeSingleItem(
                                                          selectedItem.id,
                                                        );
                                                  },
                                                  icon: Icon(
                                                    Icons.remove_circle,
                                                    size: 20,
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    stockInItemProvider
                                                        .removeItem(
                                                          selectedItem.id,
                                                        );
                                                    Snackbar.info(
                                                      context,
                                                      "Item removed!",
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.highlight_remove,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                        ],
                                      );
                                    },
                                  )
                                  : Text("No items"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount : LKR.${stockInItemProvider.totalAmount}",
                      style: kSecondaryTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Total Qty : ${stockInItemProvider.totalQty}",
                      style: kSecondaryTextStyle.copyWith(fontSize: 13),
                    ),
                  ],
                ),
                Spacer(),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (stockInItemProvider.selectedItems.isNotEmpty) {
                          //set items
                          salesOrderProvider.addItem(
                            stockInItemProvider.selectedItems,
                          );
                          //create SO
                          await salesOrderProvider.submitSO(
                            soId: _soIdController.text,
                            customerId: customerProvider.customerId,
                            customerName: customerProvider.customerName,
                            createdBy: user!.uid,
                            companyId: companyId,
                            warehouseId: "111",
                            expectedDate: DateTime.parse(
                              _expectedDeliveryDate ?? '${DateTime.now()}',
                            ),
                            notes: _notesController.text,
                          );
                          final soPdf = await SalesOrderPdf.generateInvoicePdf(
                            soId: _soIdController.text,
                            organizationName: "PMS",
                            organizationEmail: "pms123@gmail.com",
                            customerName: customerProvider.customerName,
                            dueDate: DateTime.parse(_edateController.text),
                            items: stockInItemProvider.selectedItemsAsList,
                            taxRate: 0.1,
                          );

                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Purchase Order Created"),
                                content: Text(
                                  "What would you like to do next?",
                                ),
                                actions: [
                                  TextButton(
                                    style: kButtonStyle,
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                      SaveAndOpenPDF.openPdf(soPdf);
                                    },
                                    child: Text(
                                      "Open PDF",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  TextButton(
                                    style: kButtonStyle,
                                    onPressed: () async {
                                      Navigator.pop(context); // Close dialog

                                      final Email email = Email(
                                        body:
                                            "Dear ${customerProvider.customerName},\n\nThanks for your interest our service. please find our sales order attached with this mail.",
                                        subject:
                                            'Sales Order from PMS (Sales Order #: ${salesOrderProvider.soId})',
                                        recipients: [
                                          customerProvider.customerEmail,
                                        ],
                                        attachmentPaths: [
                                          SaveAndOpenPDF.pdfFile!,
                                        ],
                                        isHTML: false,
                                      );

                                      await FlutterEmailSender.send(email);

                                      //clear all
                                      clearAll();
                                      customerProvider.clearSelectedCustomer();
                                      warehouseProvider
                                          .clearSelectedWarehouse();
                                      stockInItemProvider.clear();

                                      Snackbar.success(
                                        context,
                                        "Email sent successfully!",
                                      );
                                    },
                                    child: Text(
                                      "Send Email",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Snackbar.error(
                            context,
                            "Please add items to purchase!",
                          );
                        }
                      }
                    },
                    style: kButtonStyle,
                    child: Text(
                      "Submit",
                      style: kButtonTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
