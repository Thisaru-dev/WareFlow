import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/pages/home/home_view.dart';
import 'package:wareflow/pages/home/transactions_view.dart';
import 'package:wareflow/pages/home/more_view.dart';
import 'package:wareflow/pages/home/inventory_view.dart';

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [HomeView(), InventoryView(), LogsPage(), MorePage()],
      ),

      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey[550],
        iconSize: 28,
        selectedFontSize: 28.sp,
        unselectedFontSize: 28.sp,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,

        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: "Inventory",
            activeIcon: Icon(Icons.inventory),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_sharp),
            label: "Log",
            activeIcon: Icon(Icons.list_alt_sharp),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "More",
            activeIcon: Icon(Icons.more_horiz_outlined),
          ),
        ],
      ),
    );
  }
}
