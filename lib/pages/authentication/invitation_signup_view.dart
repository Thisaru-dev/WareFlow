import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/pages/home/base.dart';

class InvitationSignupView extends StatefulWidget {
  const InvitationSignupView({super.key});

  @override
  State<InvitationSignupView> createState() => _InvitationSignupViewState();
}

class _InvitationSignupViewState extends State<InvitationSignupView> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign up", style: kPrimaryTextStyle),
              SizedBox(height: screenHeight * 0.05),

              TextField(
                decoration: kInputDecoration.copyWith(
                  hintText: "Name",
                  prefixIcon: Icon(Icons.person_2_outlined),
                ),
              ),
              TextField(
                decoration: kInputDecoration.copyWith(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(height: 10.sp),
              TextField(
                obscureText: true,
                decoration: kInputDecoration.copyWith(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              SizedBox(height: 10.sp),
              TextField(
                obscureText: true,
                decoration: kInputDecoration.copyWith(
                  hintText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock_person_outlined),
                ),
              ),

              SizedBox(height: 50.sp),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.scale,
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 200),
                      child: Base(),
                    ),
                  );
                },
                style: kButtonStyle.copyWith(
                  minimumSize: WidgetStatePropertyAll(
                    Size(screenWidth, screenHeight * 0.06),
                  ),
                ),
                child: Text("Sign up", style: kButtonTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
