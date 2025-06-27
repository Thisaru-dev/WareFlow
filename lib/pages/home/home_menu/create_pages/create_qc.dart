import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/grn_provider.dart';
import 'package:wareflow/providers/item_provider.dart';
import 'package:wareflow/providers/qc_provider.dart';

class CreateQc extends StatefulWidget {
  const CreateQc({super.key});

  @override
  State<CreateQc> createState() => _CreateQcState();
}

class _CreateQcState extends State<CreateQc> {
  final TextEditingController _grnController = TextEditingController();
  final TextEditingController _qcDateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  //dialog box controllers
  final TextEditingController _quantityIssuesController =
      TextEditingController();
  final TextEditingController _qualityIssuesController =
      TextEditingController();
  final TextEditingController _wrongItemsController = TextEditingController();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final _formKey = GlobalKey<FormState>();

  void clearAll() {
    _grnController.clear();
    _qcDateController.clear();
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<GrnProvider, QcProvider, ItemProvider>(
      builder: (
        BuildContext context,
        GrnProvider grnProvider,
        QcProvider qcProvider,
        ItemProvider itemProvider,
        _,
      ) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("Quality Check", style: kTitleTextStyle),
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
                                    controller: _grnController,
                                    readOnly: true,
                                    style: kInputTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                    decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.sticky_note_2,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      label: Text(
                                        "GRN",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/grnselection',
                                      ).then((_) {
                                        _grnController.text = grnProvider.grnId;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select the GRN";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: kTextFieldDecoration,
                                  child: TextFormField(
                                    controller: _qcDateController,
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
                                        "Inspection Date",
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
                                        _qcDateController.text = _selectedDate;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select the inspected date";
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
                                  Text(
                                    "Items",
                                    style: kSecondaryTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                              Divider(),

                              grnProvider.grnId.isNotEmpty
                                  ? StreamBuilder<QuerySnapshot>(
                                    stream:
                                        FirebaseFirestore.instance
                                            .collection('grns')
                                            .doc(grnProvider.grnId)
                                            .collection('items')
                                            .snapshots(),
                                    builder: (context, snapshot) {
                                      //error
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            "Something went wrong...",
                                          ),
                                        );
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      final grnItems = snapshot.data!.docs;
                                      final issues = qcProvider.issues;
                                      return ListView.builder(
                                        itemCount: grnItems.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final item = grnItems[index];
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Enter Inspection Issues",
                                                      style: kTitleTextStyle
                                                          .copyWith(
                                                            fontSize: 40.sp,
                                                          ),
                                                    ),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'item',
                                                            style:
                                                                kSecondaryTextStyle,
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Quantity issues",
                                                              ),

                                                              //quantity text field
                                                              SizedBox(
                                                                width: 70,
                                                                height: 40,
                                                                child: TextField(
                                                                  controller:
                                                                      _quantityIssuesController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      kInputDecoration,
                                                                  style: kInputTextStyle
                                                                      .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Quality issues",
                                                              ),

                                                              //quantity text field
                                                              SizedBox(
                                                                width: 70,
                                                                height: 40,
                                                                child: TextField(
                                                                  controller:
                                                                      _qualityIssuesController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      kInputDecoration,
                                                                  style: kInputTextStyle
                                                                      .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Wrong items",
                                                              ),

                                                              //quantity text field
                                                              SizedBox(
                                                                width: 70,
                                                                height: 40,
                                                                child: TextField(
                                                                  controller:
                                                                      _wrongItemsController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      kInputDecoration,
                                                                  style: kInputTextStyle
                                                                      .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    actions: [
                                                      //cancel button
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },

                                                        child: Text(
                                                          "Cancle",
                                                          style: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                      //confirm button
                                                      FilledButton(
                                                        onPressed: () {
                                                          qcProvider.addIssue(
                                                            item['itemId'],
                                                            int.tryParse(
                                                                  _quantityIssuesController
                                                                      .text,
                                                                ) ??
                                                                0,
                                                            int.tryParse(
                                                                  _qualityIssuesController
                                                                      .text,
                                                                ) ??
                                                                0,
                                                            int.tryParse(
                                                                  _wrongItemsController
                                                                      .text,
                                                                ) ??
                                                                0,
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
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
                                            },
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    child: Image(
                                                      image: NetworkImage(
                                                        item['image'],
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(
                                                    item['itemName'],
                                                    style: kPrimaryTextStyle
                                                        .copyWith(fontSize: 13),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 2,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'quality issues: ${issues.isNotEmpty ? issues[index].qualityIssueQty : 0} ',

                                                          style:
                                                              kSecondaryTextStyle
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                        ),
                                                        Text(
                                                          'quantity issues: ${issues.isNotEmpty ? issues[index].quantityIssueQty : 0}',
                                                          style:
                                                              kSecondaryTextStyle
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                        ),
                                                        Text(
                                                          'wrong items: ${issues.isNotEmpty ? issues[index].wrongItemsQty : 0}',
                                                          style:
                                                              kSecondaryTextStyle
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Divider(),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )
                                  : Text("select GRN first"),
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
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 195,
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        qcProvider.createQC(
                          poId: grnProvider.poId,
                          grnId: grnProvider.grnId,
                          qcStatus: 'REJECTED',
                          qcDate: DateTime.parse(_selectedDate),
                          qcNote: _noteController.text,
                        );
                        Snackbar.success(context, "Purchase Receive updated");
                      }
                      grnProvider.clearAll();
                      clearAll();
                    },
                    style: kButtonStyle.copyWith(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),

                    child: Text(
                      "Reject",
                      style: kButtonTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 50,
                  width: 195,
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        qcProvider.createQC(
                          poId: grnProvider.poId,
                          grnId: grnProvider.grnId,
                          qcStatus: 'APPROVED',
                          qcDate: DateTime.parse(_selectedDate),
                          qcNote: _noteController.text,
                        );
                        itemProvider.addItems(items: grnProvider.items);
                        itemProvider.updateItemsQty(warehouseId: "warehouse01");
                        Snackbar.success(context, "GRN updated");
                      }
                      grnProvider.clearAll();
                      clearAll();
                    },
                    style: kButtonStyle,

                    child: Text(
                      "Approve",
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
