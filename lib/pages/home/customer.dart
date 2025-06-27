import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/models/customer_model.dart';

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({super.key});

  @override
  State<CustomerManagementPage> createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  final CollectionReference customersRef = FirebaseFirestore.instance
      .collection('customers');

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _contactCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _orgIdCtrl = TextEditingController();

  String? editingCustomerId;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _contactCtrl.dispose();
    _addressCtrl.dispose();
    _orgIdCtrl.dispose();
    super.dispose();
  }

  void _showCustomerDialog({CustomerModel? customer}) {
    if (customer != null) {
      editingCustomerId = customer.id;
      _nameCtrl.text = customer.name;
      _emailCtrl.text = customer.email;
      _contactCtrl.text = customer.contact;
      _addressCtrl.text = customer.address;
      _orgIdCtrl.text = customer.organizationId;
    } else {
      editingCustomerId = null;
      _nameCtrl.clear();
      _emailCtrl.clear();
      _contactCtrl.clear();
      _addressCtrl.clear();
      _orgIdCtrl.clear();
    }

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(customer == null ? 'Add Customer' : 'Edit Customer'),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name'),
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
                      controller: _contactCtrl,
                      decoration: const InputDecoration(labelText: 'Contact'),
                      validator:
                          (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _addressCtrl,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator:
                          (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _orgIdCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Organization ID',
                      ),
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
                onPressed: _saveCustomer,
                child: Text(customer == null ? 'Add' : 'Update'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    final customer = CustomerModel(
      id: editingCustomerId ?? customersRef.doc().id,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      contact: _contactCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      organizationId: _orgIdCtrl.text.trim(),
    );

    try {
      await customersRef
          .doc(customer.id)
          .set(customer.toMap(), SetOptions(merge: true));
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editingCustomerId == null
                ? 'Customer added successfully'
                : 'Customer updated successfully',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving customer: $e')));
    }
  }

  Future<void> _deleteCustomer(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Customer'),
            content: const Text(
              'Are you sure you want to delete this customer?',
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
      await customersRef.doc(id).delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Customer deleted')));
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
        title: const Text('Customer Management', style: kTitleTextStyle),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _showCustomerDialog(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: customersRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading customers'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return const Center(child: Text('No customers found.'));
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data()! as Map<String, dynamic>;
                final customer = CustomerModel.fromMap(data);

                return ListTile(
                  title: Text(customer.name),
                  subtitle: Text('${customer.contact}\n${customer.email}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed:
                            () => _showCustomerDialog(customer: customer),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCustomer(customer.id),
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
