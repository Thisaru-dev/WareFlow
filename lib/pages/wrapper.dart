import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/models/user_model.dart';
import 'package:wareflow/pages/authentication/auth_wrapper.dart';
import 'package:wareflow/pages/company_setup_view.dart';
import 'package:wareflow/pages/home/base.dart';
import 'package:wareflow/providers/permission_provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final permissionProvider = Provider.of<PermissionProvider>(context);
    if (user == null) {
      return AuthWrapper();
    } else if (user.companyId == null || user.companyId!.isEmpty) {
      return CompanySetupView();
    } else {
      permissionProvider.loadRolePermission(user.uid);
      return Base();
    }
    // return AuthWrapper();
  }
}
