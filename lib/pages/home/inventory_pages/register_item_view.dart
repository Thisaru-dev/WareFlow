import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/item_provider.dart';

class RegisterItemView extends StatefulWidget {
  const RegisterItemView({super.key});

  @override
  State<RegisterItemView> createState() => _RegisterItemViewState();
}

class _RegisterItemViewState extends State<RegisterItemView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemIdController = TextEditingController();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _lowStockThresholdController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController(
    text: "0.00",
  );
  final TextEditingController _quantityController = TextEditingController(
    text: "0",
  );

  String? selectedCategory;
  List<String> categories = [];

  String generateShortId() {
    final rand = Random.secure();
    int no = rand.nextInt(9000) + 1000;
    return 'IT-$no';
  }

  Future<void> fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    final fetchedCategories =
        snapshot.docs.map((doc) => doc['categoryName'] as String).toList();
    setState(() {
      categories = fetchedCategories;
      if (categories.isNotEmpty) selectedCategory = categories[0];
    });
  }

  @override
  void initState() {
    super.initState();
    _itemIdController.text = generateShortId();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Consumer<ItemProvider>(
      builder: (context, itemProvider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("Register Item", style: kTitleTextStyle),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        isWide
                            ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildBasicInfoSection()),
                                const SizedBox(width: 16),
                                Expanded(child: _buildStockSection()),
                              ],
                            )
                            : Column(
                              children: [
                                _buildBasicInfoSection(),
                                const SizedBox(height: 16),
                                _buildStockSection(),
                              ],
                            ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: _buildTextField(
                              controller: _descriptionController,
                              label: 'Description',
                              icon: Icons.notes_outlined,
                              maxLines: 3,
                            ),
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
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 350,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    itemProvider.createItem(
                      id: _itemIdController.text,
                      img:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3IsBvNSplVQxjC70dff2nXribddSqtcq9GA&s",
                      name: _itemnameController.text,
                      quantity: int.parse(_quantityController.text),
                      price: double.parse(_priceController.text),
                      supplierId: _supplierController.text,
                      category: selectedCategory!,
                      description: _descriptionController.text,
                      companyId: "COM-001",
                      lowStockThreshold: int.parse(
                        _lowStockThresholdController.text,
                      ),
                      warehouseQuantities: {
                        'warehouse01': int.parse(_quantityController.text),
                      },
                    );
                    _itemIdController.text = generateShortId();
                  }
                },
                style: kButtonStyle,
                child: Text(
                  "Save",
                  style: kButtonTextStyle.copyWith(fontSize: 14),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildTextField(
              controller: _itemIdController,
              label: 'Item ID',
              icon: Icons.qr_code_2,
              readOnly: true,
              onSuffixTap: () => _itemIdController.text = generateShortId(),
            ),
            _buildTextField(
              controller: _itemnameController,
              label: 'Item Name',
              icon: Icons.text_fields,
            ),
            _buildTextField(
              controller: _supplierController,
              label: 'Supplier',
              icon: Icons.factory_outlined,
            ),
            _buildDropdownField(),
          ],
        ),
      ),
    );
  }

  Widget _buildStockSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildTextField(
              controller: _priceController,
              label: 'Price',
              icon: Icons.attach_money,
              extraValidator: (value) {
                final price = double.tryParse(value ?? '');
                if (price == null || price < 0) {
                  return 'Price must be 0 or more';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _quantityController,
              label: 'Quantity',
              icon: Icons.countertops,
              extraValidator: (value) {
                final qty = int.tryParse(value ?? '');
                if (qty == null || qty < 0) {
                  return 'Quantity must be 0 or more';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _lowStockThresholdController,
              label: 'Low Stock Threshold',
              icon: Icons.warning_amber_outlined,
              extraValidator: (value) {
                final val = int.tryParse(value ?? '');
                if (val == null || val < 0) {
                  return 'Low stock threshold must be 0 or more';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onSuffixTap,
    int maxLines = 1,
    String? Function(String?)? extraValidator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        style: kInputTextStyle.copyWith(fontSize: 14, color: Colors.black87),
        keyboardType:
            (label == 'Price' ||
                    label == 'Quantity' ||
                    label == 'Low Stock Threshold')
                ? TextInputType.numberWithOptions(decimal: label == 'Price')
                : null,
        decoration: kInputDecoration.copyWith(
          fillColor: Colors.grey.shade300,
          label: Text(label, style: kSecondaryTextStyle.copyWith(fontSize: 14)),
          prefixIcon: Icon(icon, size: 18, color: Colors.black),
          suffixIcon:
              onSuffixTap != null
                  ? IconButton(
                    onPressed: onSuffixTap,
                    icon: const Icon(Icons.replay_outlined, size: 18),
                  )
                  : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (extraValidator != null) {
            return extraValidator(value);
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: kInputDecoration.copyWith(
          labelText: "Category",
          prefixIcon: Icon(Icons.category, color: Colors.black, size: 18),
        ),
        items:
            categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
        onChanged: (value) {
          setState(() => selectedCategory = value);
        },
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }
}
