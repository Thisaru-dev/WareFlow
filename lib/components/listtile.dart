import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';

class Listtile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const Listtile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: kPrimaryColor,
        ),
        child: Icon(icon, size: 20, color: Colors.white),
      ),
      title: Text(title, style: kTitleTextStyle.copyWith(fontSize: 14)),
      subtitle: Text(
        subtitle,
        style: kSecondaryTextStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.shade200,
        ),

        child: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
      ),
    );
  }
}
