import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wareflow/constants/constants.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background_2.jpg"),
            fit: BoxFit.cover,
            opacity: .7,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Lottie.asset("images/lotties/firstView.json"),
            SizedBox(height: 0.h),

            Expanded(
              child: Column(
                children: [
                  Text(
                    "Hello!",
                    style: kPrimaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to ",
                        style: kPrimaryTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        "WareFlow",
                        style: kPrimaryTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  // Text("Hello", style: TextStyle(fontSize: 50.sp)),
                  SizedBox(height: screenHeight * .01),
                  Text(
                    "Smart Inventory & Order Management at Your Fingertips",
                    style: kSecondaryTextStyle,
                  ),

                  SizedBox(height: screenHeight * .05),

                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/wrapper');
                    },

                    icon: Icon(Icons.arrow_forward),
                    label: Text("      Get Started", style: kButtonTextStyle),

                    style: kButtonStyle.copyWith(
                      minimumSize: WidgetStatePropertyAll(
                        Size(screenWidth / 4, screenHeight * .06),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
