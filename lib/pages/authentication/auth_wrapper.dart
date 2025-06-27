import 'package:flutter/material.dart';

import 'package:wareflow/pages/authentication/signin_view.dart';
import 'package:wareflow/pages/authentication/signup_view.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool signinPage = true;
  //toggle pages
  void switchPages() {
    setState(() {
      signinPage = !signinPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signinPage == true) {
      return SignInView(toggle: switchPages);
    } else {
      return SignUpView(toggle: switchPages);
    }
  }
}
