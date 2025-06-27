import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    String greet = "Good morning";
    String name = "Thisaru Kalpana";
    String role = "Admin";
    String id = "emp001";
    String warehouse = "Colombo Hub";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 300.h,
        width: screenWidth,
        decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.color,
          image: DecorationImage(
            image: AssetImage("images/background_1.jpg"),
            fit: BoxFit.fill,
            opacity: .3,
          ),
          borderRadius: BorderRadius.circular(30.sp),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 221, 221, 221),
              offset: Offset(2.5, 2.5),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greet, style: TextStyle(fontSize: 35.sp)),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 50.sp, color: Colors.black),
                  ),
                  Text("ID: $id", style: TextStyle(fontSize: 30.sp)),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Container(
                    // height: 60.h,
                    // width: 150.h,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          role,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Container(
                    // height: 30,

                    // width: 110,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          warehouse,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
