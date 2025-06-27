import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:wareflow/constants/constants.dart';

class InviteUsers extends StatefulWidget {
  const InviteUsers({super.key});

  @override
  State<InviteUsers> createState() => _InviteUsersState();
}

class _InviteUsersState extends State<InviteUsers> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _warehouseController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  bool _isLoading = false;

  Future<void> _sendInvitation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await createInvitation(
        email: _emailController.text.trim(),
        role: _roleController.text.trim(),
        companyId: "COM-001",
        warehouseId: _warehouseController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invitation sent successfully!')),
      );

      _emailController.clear();
      _nameController.clear();
      _roleController.clear();
      _warehouseController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite User", style: kTitleTextStyle),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validatorMsg: 'Enter a valid email',
                          ),
                          _buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            validatorMsg: 'Enter name',
                          ),
                          _buildTextField(
                            controller: _roleController,
                            label: 'Role',
                            icon: Icons.badge_outlined,
                            validatorMsg: 'Enter role',
                          ),
                          _buildTextField(
                            controller: _warehouseController,
                            label: 'Warehouse ID',
                            icon: Icons.warehouse_outlined,
                            validatorMsg: 'Enter warehouse ID',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 400,
          height: 50,
          child: FilledButton.icon(
            icon: const Icon(Icons.send),
            onPressed: _isLoading ? null : _sendInvitation,
            style: kButtonStyle,
            label:
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                      "Send Invitation",
                      style: kButtonTextStyle.copyWith(fontSize: 14),
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorMsg,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: kInputTextStyle.copyWith(fontSize: 14, color: Colors.black87),
        decoration: kInputDecoration.copyWith(
          label: Text(label, style: kSecondaryTextStyle.copyWith(fontSize: 14)),
          prefixIcon: Icon(icon, size: 18, color: Colors.black),
          fillColor: Colors.grey.shade300,
        ),
        validator:
            (value) => value == null || value.isEmpty ? validatorMsg : null,
      ),
    );
  }
}

// === Invitation Function ===
Future<void> createInvitation({
  required String email,
  required String role,
  required String companyId,
  String? warehouseId,
}) async {
  final String code = (Random().nextInt(900000) + 100000).toString();

  final existingInvites =
      await FirebaseFirestore.instance
          .collection('invitations')
          .where('email', isEqualTo: email)
          .where('companyId', isEqualTo: companyId)
          .get();

  if (existingInvites.docs.isNotEmpty) {
    throw Exception('Invitation already exists for this email.');
  }

  await FirebaseFirestore.instance.collection('invitations').add({
    'email': email.trim(),
    'code': code,
    'companyId': companyId,
    'role': role,
    'warehouseId': warehouseId ?? '',
    'createdAt': FieldValue.serverTimestamp(),
  });

  final Email mail = Email(
    body:
        'Hi there,\n\nYou’ve been invited to join WareFlow.\n\nInvitation Code: $code\n\nOpen the app → Join with Code → Enter your code and register.\n\nBest regards,\nWareFlow Team',
    subject: 'You’ve Been Invited to WareFlow',
    recipients: [email],
    isHTML: false,
  );
  await FlutterEmailSender.send(mail);
}
