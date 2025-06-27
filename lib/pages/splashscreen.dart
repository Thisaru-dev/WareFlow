import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/appIcon/appIcon_2.png',
              height: 200,
            ), // Optional
            SizedBox(height: 20),
            Text("WareFlow"),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: kPrimaryColor,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
