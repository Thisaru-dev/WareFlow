import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/pages/authentication/functions/validate.dart';
import 'package:wareflow/services/auth_service.dart';

class SignUpView extends StatefulWidget {
  final Function toggle;
  const SignUpView({super.key, required this.toggle});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String photoURL = "";
  String displayName = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  bool _isObsecureP1 = true;
  bool _isObsecureP2 = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1000,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background_2.jpg"),
            fit: BoxFit.cover,
            opacity: .3,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Create Account",
                      style: kPrimaryTextStyle.copyWith(fontSize: 25),
                    ),
                    SizedBox(height: 20),

                    // Avatar upload (optional)
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                                photoURL.isNotEmpty
                                    ? NetworkImage(photoURL)
                                    : null,
                            child:
                                photoURL.isEmpty
                                    ? Icon(
                                      Icons.person,
                                      size: 45,
                                      color: Colors.grey.shade700,
                                    )
                                    : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.black87),
                            onPressed: () {
                              // TODO: Implement photo picker
                              Snackbar.info(
                                context,
                                "Photo picker not implemented",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Full Name
                    TextFormField(
                      decoration: kInputDecoration.copyWith(
                        hintText: "Full Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        if (value.length < 2) return "Too short";
                        return null;
                      },
                      onChanged: (val) => setState(() => displayName = val),
                    ),
                    SizedBox(height: 12),

                    // Email
                    TextFormField(
                      decoration: kInputDecoration.copyWith(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!value.contains('@')) return "Enter a valid email";
                        return null;
                      },
                      onChanged: (val) => setState(() => email = val),
                    ),
                    SizedBox(height: 12),

                    // Password
                    TextFormField(
                      obscureText: _isObsecureP1,
                      decoration: kInputDecoration.copyWith(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObsecureP1
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: kPrimaryColor,
                          ),
                          onPressed:
                              () => setState(
                                () => _isObsecureP1 = !_isObsecureP1,
                              ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) return "At least 6 characters";
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "Include an uppercase letter";
                        }
                        return null;
                      },
                      onChanged: (val) => setState(() => password = val),
                    ),
                    SizedBox(height: 12),

                    // Confirm Password
                    TextFormField(
                      obscureText: _isObsecureP2,
                      decoration: kInputDecoration.copyWith(
                        hintText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObsecureP2
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: kPrimaryColor,
                          ),
                          onPressed:
                              () => setState(
                                () => _isObsecureP2 = !_isObsecureP2,
                              ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm password";
                        }
                        if (value != password) return "Passwords do not match";
                        return null;
                      },
                      onChanged: (val) => setState(() => confirmPassword = val),
                    ),
                    SizedBox(height: 24),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 120.h,
                      child:
                          isLoading
                              ? Center(child: CircularProgressIndicator())
                              : FilledButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => isLoading = true);
                                    if (Validator().validateEmail(email)) {
                                      var result = await _auth.signup(
                                        email.trim(),
                                        confirmPassword.trim(),
                                        displayName,
                                        photoURL,
                                      );
                                      if (result == null) {
                                        Snackbar.error(
                                          context,
                                          "Email already exists",
                                        );
                                      }
                                    } else {
                                      Snackbar.error(
                                        context,
                                        "Invalid email format",
                                      );
                                    }
                                    setState(() => isLoading = false);
                                  }
                                },
                                style: kButtonStyle,
                                child: Text("Sign Up", style: kButtonTextStyle),
                              ),
                    ),
                    SizedBox(height: 24),

                    // Toggle to Sign In
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: kSecondaryTextStyle,
                        ),
                        GestureDetector(
                          onTap: () => widget.toggle(),
                          child: Text(
                            "Sign In",
                            style: kSecondaryTextStyle.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
