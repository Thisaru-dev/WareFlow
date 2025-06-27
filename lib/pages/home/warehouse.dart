import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/models/warehouse_model.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String? _editingId;

  Future<void> _submit(String companyId) async {
    if (_formKey.currentState!.validate()) {
      final warehouse = WarehouseModel(
        id:
            _editingId ??
            FirebaseFirestore.instance.collection('warehouses').doc().id,
        name: _nameController.text,
        location: _locationController.text,
        address: _addressController.text,
        contact: _contactController.text,
        companyId: companyId,
      );

      await FirebaseFirestore.instance
          .collection('warehouses')
          .doc(warehouse.id)
          .set(warehouse.toMap());

      _clearFields();
    }
  }

  void _clearFields() {
    _nameController.clear();
    _locationController.clear();
    _addressController.clear();
    _contactController.clear();
    setState(() => _editingId = null);
  }

  void _delete(String id) {
    FirebaseFirestore.instance.collection('warehouses').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    final String companyId =
        "yourCompanyId"; // Replace with actual companyId from user context

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: const Text('Manage Warehouses', style: kTitleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: kInputDecoration.copyWith(hintText: "Name"),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Enter warehouse name' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _locationController,
                    decoration: kInputDecoration.copyWith(hintText: "Location"),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: kInputDecoration.copyWith(hintText: "Address"),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _contactController,
                    decoration: kInputDecoration.copyWith(hintText: "Contact"),
                  ),
                  SizedBox(height: 10),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 400,
                    height: 50,
                    child: ElevatedButton(
                      style: kButtonStyle,

                      onPressed: () => _submit(companyId),
                      child: Text(
                        _editingId == null
                            ? 'Add Warehouse'
                            : 'Update Warehouse',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('warehouses')
                        .where('companyId', isEqualTo: companyId)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No Data");
                  }

                  final warehouses = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: warehouses.length,
                    itemBuilder: (context, index) {
                      final warehouse = warehouses[index];
                      return ListTile(
                        title: Text(warehouse['name']),
                        subtitle: Text(warehouse['location']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                setState(() {
                                  _editingId = warehouse.id;
                                  _nameController.text = warehouse['name'];
                                  _locationController.text =
                                      warehouse['location'];
                                  _addressController.text =
                                      warehouse['address'];
                                  _contactController.text =
                                      warehouse['contact'];
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _delete(warehouse.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
