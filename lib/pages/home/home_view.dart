import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/data/features_data.dart';
import 'package:wareflow/providers/permission_provider.dart';
import 'package:wareflow/services/auth_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthService _auth = AuthService();

  String displayName = "";
  String email = "";
  String photoURL = "";
  final controller = PageController();
  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  void _refreshUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final updatedUser = FirebaseAuth.instance.currentUser;

    setState(() {
      displayName = updatedUser?.displayName ?? '';
      // print(displayName);
      email = updatedUser?.email ?? '';
      photoURL = updatedUser?.photoURL ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissionProvider = Provider.of<PermissionProvider>(context);
    final allowedFeatures =
        FeaturesData().allFeatures
            .where(
              (feature) =>
                  permissionProvider.hasPermission(feature.permissionKey),
            )
            .toList();
    // double screenWidth = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Home", style: kTitleTextStyle),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: MultiLevelDrawer(
        backgroundColor: Colors.white,
        rippleColor: Colors.white,
        subMenuBackgroundColor: Colors.grey.shade100,
        divisionColor: Colors.white,
        header: SizedBox(
          height: size.height * 0.25,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  child:
                      photoURL.isNotEmpty
                          ? Image.network(photoURL)
                          : Image.asset(
                            "images/Businessman.ico",
                            width: 100,
                            height: 100,
                          ),
                ),
                SizedBox(height: 10),
                Text(
                  displayName,
                  style: kPrimaryTextStyle.copyWith(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
        children: [
          MLMenuItem(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.home),
            ),
            content: Text(
              "Home",
              style: kSecondaryTextStyle.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            onClick: () {
              Navigator.pushNamed(context, "/base");
            },
          ),
          MLMenuItem(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.shopping_cart),
            ),
            trailing: Icon(Icons.arrow_right),
            content: Text(
              "Inventory",
              style: kSecondaryTextStyle.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            onClick: () {},
            subMenuItems: [
              MLSubmenu(
                onClick: () {
                  Navigator.pushNamed(context, "/inventory");
                },
                submenuContent: Text(
                  "Items",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              MLSubmenu(
                onClick: () {
                  Navigator.pushNamed(context, "/category");
                },
                submenuContent: Text(
                  "Categories",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          MLMenuItem(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.shopify_sharp),
            ),
            content: Text(
              "Sales",
              style: kSecondaryTextStyle.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onClick: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondScreen()));
            },
            subMenuItems: [
              MLSubmenu(
                onClick: () {
                  Navigator.pushNamed(context, "/customer");
                },
                submenuContent: Text(
                  "Customers",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              MLSubmenu(
                onClick: () {
                  Navigator.pushNamed(context, "/salesorder");
                },
                submenuContent: Text(
                  "Sales Orders",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              MLSubmenu(
                onClick: () {
                  Navigator.pushNamed(context, "/package");
                },
                submenuContent: Text(
                  "Packages",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              MLSubmenu(
                onClick: () {
                  Navigator.pushNamed(context, "/dispatch");
                },
                submenuContent: Text(
                  "Dispatch",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          MLMenuItem(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.shopping_bag),
            ),
            trailing: Icon(Icons.arrow_right),
            content: Text(
              "Purchases",
              style: kSecondaryTextStyle.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            onClick: () {},
            subMenuItems: [
              MLSubmenu(
                onClick: () {},
                submenuContent: Text(
                  "Suppliers",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              MLSubmenu(
                onClick: () {
                  Navigator.pushNamed(context, "/purchaseorder");
                },
                submenuContent: Text(
                  "Purchase Orders",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              MLSubmenu(
                onClick: () {
                  Navigator.pushNamed(context, "/grn");
                },
                submenuContent: Text(
                  "GRN",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              MLSubmenu(
                onClick: () {
                  Navigator.pushNamed(context, "/qualitycheck");
                },
                submenuContent: Text(
                  "Quality Check",
                  style: kSecondaryTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          MLMenuItem(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.rotate_90_degrees_ccw),
            ),

            content: Text(
              "Returns",
              style: kSecondaryTextStyle.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),

            onClick: () {
              Navigator.pushNamed(context, "/return");
            },
          ),
          MLMenuItem(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.bar_chart_rounded),
            ),

            content: Text(
              "Reports",
              style: kSecondaryTextStyle.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),

            onClick: () {},
          ),
          MLMenuItem(
            content: Center(
              child: Text(
                "Signout",
                style: kSecondaryTextStyle.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onClick: () {
              AuthService().signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 📦 Stock In
                      Column(
                        children: [
                          Icon(
                            Icons.move_to_inbox,
                            color: Color.fromARGB(255, 105, 158, 211),
                            size: 28,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "In",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "132", // Replace with dynamic value
                            style: kPrimaryTextStyle.copyWith(fontSize: 25),
                          ),
                        ],
                      ),

                      Container(width: 1, height: 40, color: Colors.grey[300]),

                      // 🚚 Stock Out
                      Column(
                        children: [
                          Icon(
                            Icons.local_shipping,
                            color: Color.fromARGB(255, 212, 113, 113),
                            size: 28,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Out",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "89", // Replace with dynamic value
                            style: kPrimaryTextStyle.copyWith(fontSize: 25),
                          ),
                        ],
                      ),

                      Container(width: 1, height: 40, color: Colors.grey[300]),

                      // 📊 Total
                      Column(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            color: Color.fromARGB(255, 107, 211, 112),
                            size: 28,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "221", // Replace with dynamic value
                            style: kPrimaryTextStyle.copyWith(
                              fontSize: 25,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GridView.builder(
                    itemCount: quickActionsNames.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,

                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap:
                                () => Navigator.pushNamed(context, "/approval"),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orangeAccent,
                              ),

                              child: quickActionsIcons[index],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            quickActionsNames[index],
                            style: kPrimaryTextStyle.copyWith(fontSize: 11),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Order Management"),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: size.width,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/salesorder');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF1976D2),
                        image: DecorationImage(
                          image: AssetImage("images/background_1.jpg"),
                          fit: BoxFit.cover,
                          opacity: .2,
                        ),
                      ),
                      margin: EdgeInsets.all(5),

                      child: ListTile(
                        title: Text(
                          "Sales Order",
                          style: kPrimaryTextStyle.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Track and manage customer sales",
                          style: kSecondaryTextStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/delete-product.png',
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 5),
                SizedBox(
                  width: size.width,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/purchaseorder');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF1976D2),
                        image: DecorationImage(
                          image: AssetImage("images/background_1.jpg"),
                          fit: BoxFit.cover,
                          opacity: .2,
                        ),
                      ),
                      margin: EdgeInsets.all(5),

                      child: ListTile(
                        title: Text(
                          "Purchase Order",
                          style: kPrimaryTextStyle.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Create and manage supplier orders",
                          style: kSecondaryTextStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/add-product.png',
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Divider(),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Inventory Operations"),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: size.width,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/grn");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF1976D2),
                        image: DecorationImage(
                          image: AssetImage("images/background_2.jpg"),
                          fit: BoxFit.cover,
                          opacity: .3,
                        ),
                      ),
                      margin: EdgeInsets.all(5),

                      child: ListTile(
                        title: Text(
                          "GRN (Goods Received Note)",
                          style: kPrimaryTextStyle.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Log and verify received goods",
                          style: kSecondaryTextStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset('images/grn.ico', height: 45),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 5),
                SizedBox(
                  width: size.width,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/qualitycheck");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF1976D2),
                        image: DecorationImage(
                          image: AssetImage("images/background_2.jpg"),
                          fit: BoxFit.cover,
                          opacity: .3,
                        ),
                      ),
                      margin: EdgeInsets.all(5),

                      child: ListTile(
                        title: Text(
                          "Quality Check",
                          style: kPrimaryTextStyle.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Inspect and validate incoming items",
                          style: kSecondaryTextStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset('images/quality.ico', height: 45),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 5),
                SizedBox(
                  width: size.width,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/package");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF1976D2),
                        image: DecorationImage(
                          image: AssetImage("images/background_2.jpg"),
                          fit: BoxFit.cover,
                          opacity: .3,
                        ),
                      ),
                      margin: EdgeInsets.all(5),

                      child: ListTile(
                        title: Text(
                          "Package",
                          style: kPrimaryTextStyle.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Group items for distribution",
                          style: kSecondaryTextStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset('images/package.ico', height: 45),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 5),
                SizedBox(
                  width: size.width,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/dispatch");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF1976D2),
                        image: DecorationImage(
                          image: AssetImage("images/background_2.jpg"),
                          fit: BoxFit.cover,
                          opacity: .3,
                        ),
                      ),
                      margin: EdgeInsets.all(5),

                      child: ListTile(
                        title: Text(
                          "Dispatch",
                          style: kPrimaryTextStyle.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Prepare and send out packages",
                          style: kSecondaryTextStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset('images/dispatch.ico', height: 45),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),
                Divider(),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Return Handling"),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: size.width,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/return");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF1976D2),
                        image: DecorationImage(
                          image: AssetImage("images/background_3.jpg"),
                          fit: BoxFit.cover,
                          opacity: .4,
                        ),
                      ),
                      margin: EdgeInsets.all(5),

                      child: ListTile(
                        title: Text(
                          "Return",
                          style: kPrimaryTextStyle.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Handle purchase and sales returns",
                          style: kSecondaryTextStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset('images/return.ico', height: 45),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),
                Divider(),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Analytics and Reports"),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: size.width,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF1976D2),
                        image: DecorationImage(
                          image: AssetImage("images/background_3.jpg"),
                          fit: BoxFit.cover,
                          opacity: .4,
                        ),
                      ),
                      margin: EdgeInsets.all(5),

                      child: ListTile(
                        title: Text(
                          "Reports",
                          style: kPrimaryTextStyle.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "View analytics and performance summaries",
                          style: kSecondaryTextStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset("images/report.png", height: 45),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // greeting function
// String getGreeting() {
//   final hour = DateTime.now().hour;
//   if (hour < 12) {
//     return "Good Morning";
//   } else if (hour < 17) {
//     return "Good Afternoon";
//   } else {
//     return "Good Evening";
//   }
// }
List<Color> colors = [
  Color(0xFF388E3C),
  Color(0xFFF4511E),
  Color(0xFFD32F2F),
  Color(0xFF303F9F),
  Color(0xFF1976D2),
];
List<Widget> quickActionsIcons = [
  Icon(
    Icons.switch_access_shortcut_add_outlined,
    color: Colors.white,
    size: 30,
  ),
  Icon(Icons.notification_add, color: Colors.white, size: 30),
  Icon(Icons.swap_horizontal_circle_sharp, color: Colors.white, size: 30),
];
List<String> quickActionsNames = [
  "Approval",
  // "Category",
  // "Add items",
  "Notification",
  "Switch",
];
