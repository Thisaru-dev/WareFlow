import 'package:flutter/material.dart';
import 'package:wareflow/services/item_service.dart';

class ItemsAdd extends StatefulWidget {
  const ItemsAdd({super.key});

  @override
  State<ItemsAdd> createState() => _ItemsAddState();
}

class _ItemsAddState extends State<ItemsAdd> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _supplierIdController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(hintText: "id"),
              ),
              TextFormField(
                controller: _imgController,
                decoration: InputDecoration(hintText: "image"),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "name"),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(hintText: "qnt"),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(hintText: "price"),
              ),
              TextFormField(
                controller: _supplierIdController,
                decoration: InputDecoration(hintText: "supId"),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(hintText: "category"),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: "description"),
              ),
              FilledButton(
                onPressed: () {
                  ItemService().createNewItem(
                    id: _idController.text,
                    img: _imgController.text,
                    name: _nameController.text,
                    quantity: int.parse(_quantityController.text),
                    price: double.parse(_priceController.text),
                    supplierId: _supplierIdController.text,
                    category: _categoryController.text,
                    description: _descriptionController.text,
                    companyId: 'COM-001',
                    lowStockThreshold: 10,
                    warehouseQuantities: {'warehouse01': 10, 'warehouse02': 5},
                  );
                },
                child: Text("save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
