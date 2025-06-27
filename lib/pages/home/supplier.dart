import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/models/supplier_model.dart';

class SupplierManagementPage extends StatefulWidget {
  const SupplierManagementPage({super.key});

  @override
  State<SupplierManagementPage> createState() => _SupplierManagementPageState();
}

class _SupplierManagementPageState extends State<SupplierManagementPage> {
  final CollectionReference suppliersRef = FirebaseFirestore.instance
      .collection('suppliers');

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _contactCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();

  String? editingSupplierId;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _showSupplierDialog({SupplierModel? supplier}) {
    if (supplier != null) {
      editingSupplierId = supplier.supplierId;
      _nameCtrl.text = supplier.supplierName;
      _contactCtrl.text = supplier.contact;
      _emailCtrl.text = supplier.email;
      _addressCtrl.text = supplier.address;
    } else {
      editingSupplierId = null;
      _nameCtrl.clear();
      _contactCtrl.clear();
      _emailCtrl.clear();
      _addressCtrl.clear();
    }

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(supplier == null ? 'Add Supplier' : 'Edit Supplier'),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Supplier Name',
                      ),
                      validator:
                          (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _contactCtrl,
                      decoration: const InputDecoration(labelText: 'Contact'),
                      validator:
                          (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        final emailRegex = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        );
                        if (!emailRegex.hasMatch(val)) return 'Invalid email';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressCtrl,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator:
                          (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _saveSupplier,
                child: Text(supplier == null ? 'Add' : 'Update'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveSupplier() async {
    if (!_formKey.currentState!.validate()) return;

    final newSupplier = SupplierModel(
      supplierId: editingSupplierId ?? suppliersRef.doc().id,
      supplierName: _nameCtrl.text.trim(),
      contact: _contactCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    );

    try {
      await suppliersRef
          .doc(newSupplier.supplierId)
          .set(newSupplier.toMap(), SetOptions(merge: true));
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editingSupplierId == null
                ? 'Supplier added successfully'
                : 'Supplier updated successfully',
          ),
        ),
      );
    } catch (e) {
      // Handle errors here
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteSupplier(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Supplier'),
            content: const Text(
              'Are you sure you want to delete this supplier?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      await suppliersRef.doc(id).delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Supplier deleted')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: const Text('Supplier Management', style: kTitleTextStyle),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _showSupplierDialog(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: suppliersRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading suppliers'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No suppliers found.'));
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data()! as Map<String, dynamic>;
                final supplier = SupplierModel.fromMap(data);

                return ListTile(
                  title: Text(supplier.supplierName),
                  subtitle: Text('${supplier.contact}\n${supplier.email}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed:
                            () => _showSupplierDialog(supplier: supplier),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteSupplier(supplier.supplierId),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
