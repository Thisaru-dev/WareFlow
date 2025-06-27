import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wareflow/components/snackbar.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/pages/authentication/functions/validate.dart';
import 'package:wareflow/services/auth_service.dart';

class SignInView extends StatefulWidget {
  final Function toggle;
  const SignInView({super.key, required this.toggle});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  bool isLoading = false;
  bool _isObscure = true;

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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Heading
                    Text(
                      "Welcome Back 👋",
                      style: kPrimaryTextStyle.copyWith(fontSize: 25),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Please sign in to continue",
                      style: kSecondaryTextStyle,
                    ),

                    SizedBox(height: 50.sp),

                    /// Email
                    TextFormField(
                      decoration: kInputDecoration.copyWith(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!value.contains('@')) return "Enter a valid email";
                        if (value.length < 5) return "Too short";
                        return null;
                      },
                      onChanged: (value) => setState(() => email = value),
                    ),
                    SizedBox(height: 20.sp),

                    /// Password
                    TextFormField(
                      obscureText: _isObscure,
                      decoration: kInputDecoration.copyWith(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            setState(() => _isObscure = !_isObscure);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) return "At least 6 characters";
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "Include at least 1 uppercase letter";
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => password = value),
                    ),

                    /// Forgot Password
                    SizedBox(height: 10.sp),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Forgot password flow
                        },
                        child: Text(
                          "Forgot Password?",
                          style: kSecondaryTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.sp),

                    /// Sign In Button
                    isLoading
                        ? const CircularProgressIndicator(color: kPrimaryColor)
                        : FilledButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);

                              if (Validator().validateEmail(email)) {
                                dynamic result = await _auth.signin(
                                  email.trim(),
                                  password.trim(),
                                );
                                if (result == null) {
                                  Snackbar.error(
                                    context,
                                    "Invalid email or password",
                                  );
                                }
                              } else {
                                Snackbar.error(
                                  context,
                                  "Please enter a valid email",
                                );
                              }

                              setState(() => isLoading = false);
                            }
                          },
                          style: kButtonStyle.copyWith(
                            minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, 120.h),
                            ),
                          ),
                          child: Text("Sign In", style: kButtonTextStyle),
                        ),

                    SizedBox(height: 30.sp),

                    /// OR Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1.2)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "or sign in with",
                            style: kSecondaryTextStyle,
                          ),
                        ),
                        const Expanded(child: Divider(thickness: 1.2)),
                      ],
                    ),

                    /// Google Sign In
                    SizedBox(height: 20.sp),
                    IconButton(
                      onPressed: () async {
                        setState(() => isLoading = true);
                        dynamic result = await _auth.signInWithGmail();
                        if (result == null) {
                          Snackbar.error(context, "Google sign-in failed");
                        }
                        setState(() => isLoading = false);
                      },
                      icon: Image.asset("images/Google.ico", scale: 2),
                    ),

                    /// Spacer
                    SizedBox(height: 50.sp),

                    /// Bottom Toggle to Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: kSecondaryTextStyle,
                        ),
                        GestureDetector(
                          onTap: () => widget.toggle(),
                          child: Text(
                            "Sign Up",
                            style: kSecondaryTextStyle.copyWith(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 35.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
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
