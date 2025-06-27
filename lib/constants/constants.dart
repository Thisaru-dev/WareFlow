import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kPrimaryColor = Color(0xFF3E78C6);
// Primary text (dark gray)
const Color kPrimaryTextColor = Color(0xFF333333);

// Accent (vibrant orange from Headspace theme)
const Color kAccentColor = Color(0xFFFE8244);

// Secondary (calm blue tone for contrast and buttons)
const Color kSecondaryColor = Color(0xFF3E78C6);

// Background (light peach)
const Color kBackgroundColor = Color.fromARGB(255, 248, 248, 249);

// Light gray for secondary text
const Color kSecondaryTextColor = Color.fromARGB(255, 82, 81, 81);

// Card background (typically white)
const Color kCardColor = Color(0xFFFFFFFF);

const kGradientBlue = LinearGradient(colors: [Colors.blue, Colors.white]);

var kButtonStyle = ButtonStyle(
  iconAlignment: IconAlignment.end,
  iconSize: WidgetStatePropertyAll(50.sp),
  backgroundColor: WidgetStatePropertyAll(kPrimaryColor),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
  ),
);

const kButtonTextStyle = TextStyle(
  fontSize: 14,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.bold,
);

var kPrimaryTextStyle = TextStyle(
  fontSize: 85.sp,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.bold,
);

const kSecondaryTextStyle = TextStyle(
  fontSize: 14,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.normal,
  color: kSecondaryTextColor,
);

var kInputTextStyle = TextStyle(fontSize: 45.sp, fontFamily: 'OpenSans');
var kInputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.r),
    borderSide: BorderSide(color: Colors.transparent, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.r),
    borderSide: BorderSide(color: Colors.red, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.r),
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.r),
    borderSide: BorderSide(color: Colors.red),
  ),
  filled: true,
  fillColor: Colors.grey[100],

  prefixIconColor: kPrimaryColor,
  hintText: "",
  hintStyle: TextStyle(
    color: Colors.grey[600],
    fontSize: 43.sp,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w500,
  ),
);

const kTitleTextStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.bold,
);

const kErrorTextStyle = TextStyle(
  color: Colors.red,
  fontStyle: FontStyle.italic,
);

var kTextFieldDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      spreadRadius: 1,
      blurRadius: 5,
      offset: Offset(0, 3), // horizontal, vertical offset
    ),
  ],
);
