import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/item_model.dart';

class EditItemPage extends StatefulWidget {
  final String itemId;

  const EditItemPage({super.key, required this.itemId});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final imgController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final supplierIdController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final thresholdController = TextEditingController();

  late ItemModel item;

  void fillControllers(ItemModel item) {
    nameController.text = item.name;
    imgController.text = item.img;
    quantityController.text = item.quantity.toString();
    priceController.text = item.price.toString();
    supplierIdController.text = item.supplierId;
    categoryController.text = item.category;
    descriptionController.text = item.description;
    thresholdController.text = item.lowStockThreshold.toString();
  }

  Future<void> updateItem() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance
        .collection('items')
        .doc(widget.itemId)
        .update({
          'name': nameController.text.trim(),
          'img': imgController.text.trim(),
          'quantity': int.parse(quantityController.text),
          'price': double.parse(priceController.text),
          'supplierId': supplierIdController.text.trim(),
          'category': categoryController.text.trim(),
          'description': descriptionController.text.trim(),
          'lowStockThreshold': int.parse(thresholdController.text),
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item updated')));
  }

  Future<void> deleteItem() async {
    await FirebaseFirestore.instance
        .collection('items')
        .doc(widget.itemId)
        .delete();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item deleted')));
    }
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        validator: (val) {
          if (val == null || val.trim().isEmpty) return 'Enter $label';
          if (type == TextInputType.number && double.tryParse(val) == null) {
            return 'Invalid number';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text(
                        "Are you sure you want to delete this item?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
              );
              if (confirm == true) deleteItem();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('items')
                .doc(widget.itemId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading item'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          item = ItemModel.fromMap(data);

          // Fill form fields once
          WidgetsBinding.instance.addPostFrameCallback((_) {
            fillControllers(item);
          });

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  buildTextField("Item Name", nameController),
                  buildTextField("Image URL", imgController),
                  buildTextField(
                    "Quantity",
                    quantityController,
                    type: TextInputType.number,
                  ),
                  buildTextField(
                    "Price",
                    priceController,
                    type: TextInputType.number,
                  ),
                  buildTextField("Supplier ID", supplierIdController),
                  buildTextField("Category", categoryController),
                  buildTextField(
                    "Description",
                    descriptionController,
                    maxLines: 3,
                  ),
                  buildTextField(
                    "Low Stock Threshold",
                    thresholdController,
                    type: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Update Item",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
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
