import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/supplier_provider.dart';

class SupplierView extends StatefulWidget {
  const SupplierView({super.key});

  @override
  State<SupplierView> createState() => _SupplierViewState();
}

class _SupplierViewState extends State<SupplierView> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Suppliers", style: kTitleTextStyle),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: SafeArea(
        child: Column(
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
                    hintText: "Search name or ID",
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
                //consumer
                child: Consumer<SupplierProvider>(
                  builder: (
                    BuildContext context,
                    SupplierProvider supplierProvider,
                    Widget? child,
                  ) {
                    return StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('suppliers')
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
                        final supplier = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: supplier.length,
                          itemBuilder: (context, index) {
                            final sup = supplier[index];
                            return GestureDetector(
                              onTap: () {
                                supplierProvider.setSelectedSupplier(
                                  sup['supplierId'],
                                  sup['supplierName'],
                                  sup['email'],
                                  sup['address'],
                                  sup['contact'],
                                );
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: ListTile(
                                title: Text(
                                  sup['supplierName'],
                                  style: kPrimaryTextStyle.copyWith(
                                    fontSize: 36.sp,
                                  ),
                                ),
                                subtitle: Text(
                                  "ID: ${sup['supplierId']}",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      sup['address'],
                                      style: kSecondaryTextStyle.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    selectedIndex == index
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
