class RolePermission {
  final String roleName;
  final Map<String, bool> permissions;

  RolePermission({required this.roleName, required this.permissions});

  Map<String, dynamic> toMap() {
    return {'role_name': roleName, ...permissions};
  }

  factory RolePermission.fromMap(Map<String, dynamic> map) {
    final permissions = Map<String, bool>.from(map)..remove('role_name');
    return RolePermission(
      roleName: map['role_name'] ?? '',
      permissions: permissions,
    );
  }
}
