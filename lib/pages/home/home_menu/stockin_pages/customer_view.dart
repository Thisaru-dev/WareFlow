import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/models/customer_model.dart';
import 'package:wareflow/providers/customer_provider.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
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
        title: Text("Customers", style: kTitleTextStyle),
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
                child: Consumer<CustomerProvider>(
                  builder: (
                    BuildContext context,
                    CustomerProvider customerProvider,
                    Widget? child,
                  ) {
                    return StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('customers')
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
                        final customers =
                            snapshot.data!.docs.map((doc) {
                              return CustomerModel.fromMap(
                                doc.data() as Map<String, dynamic>,
                              );
                            }).toList();
                        return ListView.builder(
                          itemCount: customers.length,
                          itemBuilder: (context, index) {
                            final customer = customers[index];
                            return GestureDetector(
                              onTap: () {
                                customerProvider.setSelectedCustomer(
                                  id: customer.id,
                                  name: customer.name,
                                  email: customer.email,
                                  contact: customer.contact,
                                  address: customer.address,
                                  organizationId: customer.organizationId,
                                );
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: ListTile(
                                title: Text(
                                  customer.name,
                                  style: kPrimaryTextStyle.copyWith(
                                    fontSize: 36.sp,
                                  ),
                                ),
                                subtitle: Text(
                                  "ID: ${customer.id}",
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
