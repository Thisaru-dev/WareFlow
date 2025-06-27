class CategoryModal {
  final String categoryId;
  final String categoryName;
  final String companyId;

  CategoryModal({
    required this.categoryId,
    required this.categoryName,
    required this.companyId,
  });
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'companyId': companyId,
    };
  }

  factory CategoryModal.fromMap(Map<String, dynamic> map) {
    return CategoryModal(
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      companyId: map['companyId'] ?? '',
    );
  }
}
