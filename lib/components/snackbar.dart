import 'package:flutter/material.dart';

class Snackbar {
  static void success(BuildContext context, String msg) {
    _show(
      context,
      msg,
      backgroundColor: Colors.green.shade800,
      icon: Icons.check_circle,
    );
  }

  static void error(BuildContext context, String msg) {
    _show(
      context,
      msg,
      backgroundColor: Colors.redAccent.shade400,
      icon: Icons.error,
    );
  }

  static void info(BuildContext context, String msg) {
    _show(context, msg, backgroundColor: Colors.blueGrey, icon: Icons.info);
  }

  static void _show(
    BuildContext context,
    String msg, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
