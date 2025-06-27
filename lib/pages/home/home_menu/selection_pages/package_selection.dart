import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/package_provider.dart';

class PackageSelection extends StatefulWidget {
  const PackageSelection({super.key});

  @override
  State<PackageSelection> createState() => _PackageSelectionState();
}

class _PackageSelectionState extends State<PackageSelection> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    final String soId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Select Packages", style: kTitleTextStyle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<PackageProvider>(
              builder: (
                BuildContext context,
                PackageProvider packageProvider,
                _,
              ) {
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('packages')
                                .where('soId', isEqualTo: soId)
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
                          final packages = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: packages.length,
                            itemBuilder: (context, index) {
                              final package = packages[index];
                              return GestureDetector(
                                onTap: () {
                                  packageProvider.setSelectedPackages(
                                    packageId: package['packageId'],
                                    soId: package['soId'],
                                    companyId: package['companyId'],
                                    warehouseId: package['warehouseId'],
                                    createdBy: package['createdBy'],
                                    packageDate: DateTime.parse(
                                      package['packageDate'],
                                    ),
                                    packageNote: package['packageNote'],
                                    packageStatus: package['packageStatus'],
                                  );
                                }, //check only show need to be received items
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        child: Image(
                                          image: AssetImage("images/box.ico"),
                                          height: 30,
                                        ),
                                      ),
                                      title: Text(
                                        package['packageId'],
                                        style: kPrimaryTextStyle.copyWith(
                                          fontSize: 36.sp,
                                        ),
                                      ),
                                      subtitle: Text(
                                        package['packageDate'],
                                        style: kSecondaryTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      // trailing: Checkbox(
                                      //   value: true,
                                      //   onChanged: (bool? value) {
                                      //     setState(() {});
                                      //   },
                                      // ),
                                    ),
                                    Divider(),
                                  ],
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
