// import 'package:flutter/material.dart';
// import 'package:wareflow/constants/constants.dart';

// class ProgressiveIndicator {
//   static void show(BuildContext context, {String? message}) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent closing by tapping outside
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircularProgressIndicator(
//                   color: kPrimaryColor,
//                   backgroundColor: Colors.white,
//                 ),
//                 if (message != null) ...[
//                   const SizedBox(height: 16),
//                   Text(message, textAlign: TextAlign.center),
//                 ],
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   static void hide(BuildContext context) async {
//     //check if can pop the progressive indicator
//     await Future.delayed(Duration(microseconds: 100));
//     if (Navigator.canPop(context)) {
//       Navigator.of(context, rootNavigator: true).pop();
//     }
//   }
// }
