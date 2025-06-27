import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PermissionProvider extends ChangeNotifier {
  // Internal state
  Map<String, bool> _permissions = {};

  // Getter
  Map<String, bool> get permissions => _permissions;

  // Load permissions from Firestore based on user's role
  Future<void> loadRolePermission(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!userDoc.exists) return;

      final String roleId = userDoc['role'];
      final roleDoc =
          await FirebaseFirestore.instance
              .collection('roles')
              .doc(roleId)
              .get();

      if (roleDoc.exists) {
        final data = roleDoc.data()!;
        _permissions = {
          for (var entry in data.entries)
            if (entry.value is bool) entry.key: entry.value,
        };
        notifyListeners();
      }
    } catch (e) {
      print('Error loading role permissions: $e');
    }
  }

  // Check if user has a specific permission
  bool hasPermission(String feature) => _permissions[feature] ?? false;
}
