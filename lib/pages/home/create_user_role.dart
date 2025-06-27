import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wareflow/models/user_role_modal.dart';
import '../../constants/constants.dart';

class CreateUserRolePage extends StatefulWidget {
  const CreateUserRolePage({super.key});

  @override
  State<CreateUserRolePage> createState() => _CreateUserRolePageState();
}

class _CreateUserRolePageState extends State<CreateUserRolePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roleController = TextEditingController();

  final Map<String, bool> _permissions = {
    'handle_permissions': false,
    'manage_inspections': false,
    'manage_inventory': false,
    'manage_packages': false,
    'manage_po': false,
    'manage_pr': false,
    'manage_so': false,
    'manage_users': false,
    'view_analytics': false,
    'view_logs': false,
    'view_reports': false,
  };

  bool _isLoading = false;

  Future<void> _createRole() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final newRole = RolePermission(
      roleName: _roleController.text.trim(),
      permissions: _permissions,
    );

    try {
      await FirebaseFirestore.instance
          .collection('roles')
          .doc(_roleController.text.trim())
          .set(newRole.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Role created successfully')),
      );
      _roleController.clear();
      setState(() {
        _permissions.updateAll((key, value) => false);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create User Role", style: kTitleTextStyle),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _roleController,
                      style: kInputTextStyle,
                      decoration: kInputDecoration.copyWith(
                        fillColor: Colors.grey.shade200,
                        labelText: 'Role Name',
                        prefixIcon: const Icon(Icons.badge_outlined),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter role name'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children:
                            _permissions.keys.map((permKey) {
                              return CheckboxListTile(
                                value: _permissions[permKey],
                                title: Text(
                                  permKey.replaceAll('_', ' ').toUpperCase(),
                                  style: kSecondaryTextStyle,
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _permissions[permKey] = val!;
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 50,
          child: FilledButton.icon(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _createRole,
            label:
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Role"),
            style: kButtonStyle,
          ),
        ),
      ),
    );
  }
}
