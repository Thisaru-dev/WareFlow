import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/services/auth_service.dart';

class CompanySetupView extends StatefulWidget {
  const CompanySetupView({super.key});

  @override
  State<CompanySetupView> createState() => _CompanySetupViewState();
}

class _CompanySetupViewState extends State<CompanySetupView> {
  final AuthService _auth = AuthService();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _joinCodeController = TextEditingController();

  String companyName = "";

  @override
  void dispose() {
    _companyNameController.dispose();
    _joinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Setup your Organization",
                style: kPrimaryTextStyle.copyWith(fontSize: 25),
              ),
              const SizedBox(height: 10),
              Text(
                "Create a new company or Join to an existing company",
                style: kSecondaryTextStyle.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 30),

              /// Company name input
              TextFormField(
                controller: _companyNameController,
                onChanged: (value) => setState(() => companyName = value),
                decoration: kInputDecoration.copyWith(
                  prefixIcon: const Icon(Icons.home),
                  hintText: "Organization name",
                ),
              ),
              const SizedBox(height: 15),

              /// Create Company Button
              SizedBox(
                width: 400,
                height: 60,
                child: TextButton.icon(
                  onPressed: () async {
                    if (_companyNameController.text.isNotEmpty) {
                      await _auth.createCompany(companyName);

                      await Navigator.pushNamed(context, '/base');
                    }
                  },
                  style: kButtonStyle.copyWith(
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                    iconColor: const WidgetStatePropertyAll(Colors.white),
                    iconAlignment: IconAlignment.start,
                    iconSize: const WidgetStatePropertyAll(30),
                  ),
                  label: Text(
                    "Create Company",
                    style: kButtonTextStyle.copyWith(fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "OR",
                      style: kSecondaryTextStyle.copyWith(color: Colors.grey),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 40),

              /// Join Code Input
              TextFormField(
                controller: _joinCodeController,
                decoration: kInputDecoration.copyWith(
                  prefixIcon: const Icon(Icons.key),
                  hintText: "Invitation Code",
                ),
              ),
              const SizedBox(height: 15),

              /// Join Company Button
              SizedBox(
                width: 400,
                height: 60,
                child: TextButton.icon(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    final code = _joinCodeController.text.trim();

                    if (user == null || code.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid user or code')),
                      );
                      return;
                    }

                    try {
                      final snapshot =
                          await FirebaseFirestore.instance
                              .collection('invitations')
                              .where('code', isEqualTo: code)
                              .where('email', isEqualTo: user.email)
                              .get();

                      if (snapshot.docs.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Invalid or expired invitation code.',
                            ),
                          ),
                        );
                        return;
                      }

                      final invitation = snapshot.docs.first;
                      final data = invitation.data();
                      final role = data['role'];
                      final companyId = data['companyId'];
                      final warehouseId = data['warehouseId'];

                      // Update the user document with role, companyId, warehouseId
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({
                            'role': role,
                            'companyId': companyId,
                            'warehouseId': warehouseId,
                          });

                      // Mark invitation as used (no timestamp)
                      await invitation.reference.update({
                        'status': 'used',
                        'joinedUserId': user.uid,
                      });

                      _joinCodeController.text.isNotEmpty
                          ? Navigator.pushReplacementNamed(context, '/base')
                          : null;
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to join company.'),
                        ),
                      );
                    }
                  },
                  style: kButtonStyle.copyWith(
                    backgroundColor: const WidgetStatePropertyAll(
                      Colors.blueGrey,
                    ),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                    iconColor: const WidgetStatePropertyAll(Colors.white),
                    iconAlignment: IconAlignment.start,
                    iconSize: const WidgetStatePropertyAll(30),
                  ),
                  label: Text(
                    "Join Company",
                    style: kButtonTextStyle.copyWith(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
