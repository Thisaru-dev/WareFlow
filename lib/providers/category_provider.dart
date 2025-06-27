import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _categoryId = '';
  final String _categoryName = '';
  final String _companyId = '';

  //getters
  String get categoryId => _categoryId;
  String get categoryName => _categoryName;
  String get companyId => _companyId;
  //create category
  /// Create a new category
  Future<void> createCategory({
    required String categoryId,
    required String categoryName,
    required String companyId,
  }) async {
    try {
      final docRef = _firestore.collection('categories').doc(categoryId);
      await docRef.set({
        'categoryId': categoryId,
        'categoryName': categoryName,
        'companyId': companyId,
      });
    } catch (e) {
      debugPrint("Error creating category: $e");
    }
  }

  /// Update an existing category
  Future<void> updateCategory({
    required String categoryId,
    required String categoryName,
  }) async {
    try {
      final docRef = _firestore.collection('categories').doc(categoryId);
      await docRef.update({'categoryName': categoryName});
    } catch (e) {
      debugPrint("Error updating category: $e");
    }
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      final docRef = _firestore.collection('categories').doc(categoryId);
      await docRef.delete();
    } catch (e) {
      debugPrint("Error deleting category: $e");
    }
  }

  /// Stream categories by company ID
  Stream<List<Map<String, dynamic>>> getCategoriesByCompany(String companyId) {
    return _firestore
        .collection('categories')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => doc.data()..['docId'] = doc.id)
                  .toList(),
        );
  }

  /// Stream of categories for a given company ID
  Stream<List<Map<String, dynamic>>> getCategoryStream(String companyId) {
    return _firestore
        .collection('categories')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                data['docId'] = doc.id; // Include Firestore document ID
                return data;
              }).toList(),
        );
  }
}
