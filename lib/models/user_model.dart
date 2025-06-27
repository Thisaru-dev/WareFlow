// File: lib/models/user_model.dart
class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? companyId;
  final String? warehouseId;
  final String? role;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.companyId,
    this.warehouseId,
    this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      companyId: map['companyId'],
      warehouseId: map['warehouseId'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'companyId': companyId,
      'warehouseId': warehouseId,
      'role': role,
    };
  }
}
