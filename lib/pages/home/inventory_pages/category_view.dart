import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/providers/category_provider.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? editingDocId;

  String generateShortId() {
    final rand = Random.secure();
    int no = rand.nextInt(9000) + 1000;
    return 'CAT-$no';
  }

  @override
  void initState() {
    super.initState();
    _categoryIdController.text = generateShortId();
  }

  void clearForm() {
    _categoryIdController.text = generateShortId();
    _categoryNameController.clear();
    editingDocId = null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        return Scaffold(
          backgroundColor: HexColor("#F4F6FB"),
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: Text("Manage Item Categories", style: kTitleTextStyle),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            decoration: kTextFieldDecoration,
                            child: TextFormField(
                              controller: _categoryIdController,
                              readOnly: true,
                              style: kInputTextStyle.copyWith(fontSize: 14),
                              decoration: kInputDecoration.copyWith(
                                prefixIcon: Icon(
                                  Icons.label,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _categoryIdController.text =
                                        generateShortId();
                                  },
                                  icon: Icon(Icons.refresh),
                                ),
                                label: Text(
                                  "Category ID",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Required'
                                          : null,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: kTextFieldDecoration,
                            child: TextFormField(
                              controller: _categoryNameController,
                              style: kInputTextStyle.copyWith(fontSize: 14),
                              decoration: kInputDecoration.copyWith(
                                prefixIcon: Icon(
                                  Icons.category,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  "Category Name",
                                  style: kSecondaryTextStyle.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Required'
                                          : null,
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (editingDocId == null) {
                                    await categoryProvider.createCategory(
                                      categoryId: _categoryIdController.text,
                                      categoryName:
                                          _categoryNameController.text,
                                      companyId: "COM-001",
                                    );
                                  } else {
                                    await categoryProvider.updateCategory(
                                      // docId: editingDocId!,
                                      categoryId: _categoryIdController.text,
                                      categoryName:
                                          _categoryNameController.text,
                                    );
                                  }
                                  clearForm();
                                }
                              },
                              icon: Icon(
                                editingDocId == null ? Icons.add : Icons.edit,
                              ),
                              label: Text(
                                editingDocId == null
                                    ? "Add Category"
                                    : "Update Category",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: categoryProvider.getCategoryStream("COM-001"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final categories = snapshot.data ?? [];
                          return ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    category['categoryName'] ?? 'Unnamed',
                                  ),
                                  subtitle: Text(category['categoryId'] ?? ''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _categoryIdController.text =
                                                category['categoryId'];
                                            _categoryNameController.text =
                                                category['categoryName'];
                                            editingDocId = category['docId'];
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          await categoryProvider.deleteCategory(
                                            category['docId'],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
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
            ),
          ),
        );
      },
    );
  }
}
