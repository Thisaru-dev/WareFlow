import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/warehouse_provider.dart';

class WarehouseView extends StatefulWidget {
  const WarehouseView({super.key});

  @override
  State<WarehouseView> createState() => _WarehouseViewState();
}

class _WarehouseViewState extends State<WarehouseView> {
  String companyId = 'com-001';
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
        title: Text("Warehouses", style: kTitleTextStyle),
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
                child: Consumer<WarehouseProvider>(
                  builder: (
                    BuildContext context,
                    WarehouseProvider warehouseProvider,
                    Widget? child,
                  ) {
                    return StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('warehouses')
                              .where('companyId', isEqualTo: companyId)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text("Something went wrong..."));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final warehouses = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: warehouses.length,
                          itemBuilder: (context, index) {
                            final warehouse = warehouses[index];
                            return GestureDetector(
                              onTap: () {
                                warehouseProvider.setSelectedWarehouse(
                                  id: warehouse.id,
                                  name: warehouse['name'],
                                  location: warehouse['location'],
                                  address: warehouse['address'],
                                  contact: warehouse['contact'],
                                  companyId: warehouse['companyId'],
                                );
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: ListTile(
                                title: Text(
                                  warehouse['name'],
                                  style: kPrimaryTextStyle.copyWith(
                                    fontSize: 36.sp,
                                  ),
                                ),
                                subtitle: Text(
                                  "ID: ${warehouse.id}",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                                trailing:
                                    selectedIndex == index
                                        ? Icon(
                                          Icons.check_box,
                                          color: kPrimaryColor,
                                        )
                                        : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
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
