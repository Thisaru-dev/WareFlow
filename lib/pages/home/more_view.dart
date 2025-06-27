import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  // Define your menu options here
  final List<_MoreMenuItem> menuItems = const [
    _MoreMenuItem(
      title: "Warehouse",
      icon: Icons.warehouse,
      routeName: '/warehouse',
      color: Color.fromARGB(255, 38, 138, 221),
    ),
    _MoreMenuItem(
      title: "Manage User Roles",
      icon: Icons.person,
      routeName: '/rolepermission',
      color: Color.fromARGB(40, 25, 18, 26),
    ),
    _MoreMenuItem(
      title: "Invite Users",
      icon: Icons.person_add,
      routeName: '/inviteusers',
      color: Color.fromARGB(255, 133, 38, 221),
    ),
    _MoreMenuItem(
      title: "Supplier Management",
      icon: Icons.local_shipping,
      routeName: '/supplier',
      color: Color.fromARGB(255, 221, 114, 38),
    ),
    _MoreMenuItem(
      title: "Reports",
      icon: Icons.bar_chart,
      routeName: '/reports',
      color: Color.fromARGB(255, 38, 138, 221),
    ),
    _MoreMenuItem(
      title: "Settings",
      icon: Icons.settings,
      routeName: '/settings',
      color: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More", style: kTitleTextStyle),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        itemCount: menuItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.pushNamed(context, item.routeName),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    item.color.withOpacity(0.9),
                    item.color.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: item.color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.25),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(item.icon, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MoreMenuItem {
  final String title;
  final IconData icon;
  final String routeName;
  final Color color;

  const _MoreMenuItem({
    required this.title,
    required this.icon,
    required this.routeName,
    required this.color,
  });
}
