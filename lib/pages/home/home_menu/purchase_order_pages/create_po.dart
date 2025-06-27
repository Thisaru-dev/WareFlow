import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/pdf/purchase_order_pdf.dart';
import 'package:wareflow/pdf/save_and_open_pdf.dart';
import 'package:wareflow/providers/purchase_order_provider.dart';
import 'package:wareflow/providers/stock_in_item_provider.dart';
import 'package:wareflow/providers/supplier_provider.dart';
import 'package:wareflow/providers/warehouse_provider.dart';

class CreatePo extends StatefulWidget {
  const CreatePo({super.key});

  @override
  State<CreatePo> createState() => _CreatePoState();
}

class _CreatePoState extends State<CreatePo> {
  final TextEditingController _warehouseController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedDate;
  final user = FirebaseAuth.instance.currentUser;
  String companyId = 'pms123';

  void clearAll() {
    _warehouseController.clear();
    _supplierController.clear();
    _dateController.clear();
    _notesController.clear();
    _selectedDate = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _warehouseController.dispose();
    // _supplierController.dispose();
    // _dateController.dispose();
    // _notesController.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer4<
      StockInItemProvider,
      WarehouseProvider,
      SupplierProvider,
      PurchaseOrderProvider
    >(
      builder: (
        BuildContext context,
        StockInItemProvider stockInItemProvider,
        WarehouseProvider warehouseProvider,
        SupplierProvider supplierProvider,
        PurchaseOrderProvider purchaseOrderProvider,
        _,
      ) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("New Purchase Order", style: kTitleTextStyle),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  DateFormat('MMMM d, yyyy').format(DateTime.now()),
                  style: kSecondaryTextStyle.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
                                    controller: _warehouseController,
                                    readOnly: true,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.warehouse,
                                        size: 18,
                                        color: kPrimaryTextColor,
                                      ),
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      label: Text(
                                        "Warehouse",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: kPrimaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    //validate
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a warehouse';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/warehouseSelection',
                                      ).then((_) {
                                        _warehouseController.text =
                                            warehouseProvider.warehouseName!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _supplierController,
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
                                        "Supplier",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: kPrimaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    //validate
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a supplier';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/supplierSelection',
                                      ).then((_) {
                                        _supplierController.text =
                                            supplierProvider
                                                .selectedSupplierName;
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
                                    controller: _dateController,
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
                                        "Delivery Date",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: kPrimaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a delivery date';
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
                                        _selectedDate = DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(picked!);
                                        _dateController.text = _selectedDate!;
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
                                        //check if not supplier
                                        if (supplierProvider
                                            .selectedSupplierId
                                            .isNotEmpty) {
                                          Navigator.pushNamed(
                                            context,
                                            '/itemsview',
                                            arguments:
                                                supplierProvider
                                                    .selectedSupplierId,
                                          );
                                        }
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
                          // Set items
                          purchaseOrderProvider.addItem(
                            stockInItemProvider.selectedItems,
                          );

                          // Create PO
                          await purchaseOrderProvider.submitPO(
                            supplierProvider.selectedSupplierId,
                            supplierProvider.selectedSupplierName,
                            user!.uid,
                            companyId,
                            DateTime.parse(_selectedDate!),
                            _notesController.text,
                            warehouseProvider.warehouseId!,
                          );

                          // Generate PDF
                          final poPdf =
                              await PurchaseOrderPdf.generatePurchaseOrderPdf(
                                purchaseOrderProvider.poId,
                                warehouseProvider.warehouseName!,
                                "thisarukalpana01@gmail.com",
                                supplierProvider.selectedSupplierName,
                                DateTime.now(),
                                supplierProvider.selectedSupplierAddress,
                                stockInItemProvider.selectedItems,
                                0.1,
                              );

                          // SaveAndOpenPDF.openPdf(poPdf); // Save for later reference

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
                                      SaveAndOpenPDF.openPdf(poPdf);
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
                                        subject:
                                            'Purchase Order #${purchaseOrderProvider.poId} from WareFlow',
                                        body: '''
Dear Supplier,

Please find attached the Purchase Order (PO) #${purchaseOrderProvider.poId} issued by WareFlow.

Kindly process the order and deliver the listed items to our specified location.

If you have any questions, feel free to contact us.

Best regards,  
WareFlow Team
''',
                                        recipients: [
                                          supplierProvider
                                              .selectedSupplierEmail,
                                        ],
                                        attachmentPaths: [
                                          SaveAndOpenPDF.pdfFile!,
                                        ],
                                        isHTML: false,
                                      );

                                      await FlutterEmailSender.send(email);

                                      // Clear all after sending email
                                      clearAll();
                                      supplierProvider.clearSelectedSupplier();
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
