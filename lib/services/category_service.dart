import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/category_modal.dart';

class CategoryService {
  //referenece
  final docRef = FirebaseFirestore.instance.collection('categories');
  //create category
  Future<void> createCategory({
    required String categoryId,
    required String categoryName,
    required String companyId,
  }) async {
    final category = CategoryModal(
      categoryId: categoryId,
      categoryName: categoryName,
      companyId: companyId,
    );
    await docRef.doc(categoryId).set(category.toMap());
    print("new category created");
  }
}
