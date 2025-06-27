import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';

class ManageCategoryPage extends StatefulWidget {
  const ManageCategoryPage({super.key});

  @override
  State<ManageCategoryPage> createState() => _ManageCategoryPageState();
}

class _ManageCategoryPageState extends State<ManageCategoryPage> {
  final TextEditingController _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _uuid = "";

  String? companyId = "COM-001";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCompanyId();
  }

  Future<void> fetchCompanyId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    final data = userDoc.data();
    if (data != null && data.containsKey('companyId')) {
      setState(() {
        companyId = data['companyId'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addCategory() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('categories').add({
        'categoryId': "",
        'categoryName': _categoryController.text.trim(),
        'companyId': companyId,
        'createdAt': DateTime.now().toIso8601String(),
      });
      _categoryController.clear();
      Navigator.pop(context);
    }
  }

  Future<void> _deleteCategory(String docId) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(docId)
        .delete();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add New Category"),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Category Name"),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Enter category name"
                            : null,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(onPressed: _addCategory, child: const Text("Add")),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (companyId == null) {
      return const Scaffold(body: Center(child: Text("Company not found.")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Categories", style: kTitleTextStyle),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading categories"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!.docs;

          if (categories.isEmpty) {
            return const Center(child: Text("No categories found"));
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final doc = categories[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.category),
                title: Text(data['categoryName']),
                subtitle: Text("ID: ${data['categoryId']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCategory(doc.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
