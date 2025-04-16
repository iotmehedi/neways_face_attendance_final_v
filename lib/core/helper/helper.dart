import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double getWidth(BuildContext context) {
  return getDeviceInfo(context).size.width;
}

MediaQueryData getDeviceInfo(BuildContext context) {
  return MediaQuery.of(context);
}

Color dateColor(String allRemark) {
  // var remark = '';
  // for (var i = 0; i < allRemark.length; i++) {
  //   remark = allRemark[i];
  //   print(allRemark[i]);
  // }
  // print("all remark $allRemark");
  Color? colorText;
  // print("all remark n $remark");
  switch (allRemark) {
    case "1":
      colorText = Colors.red;
      break;
    case "2":
      colorText = Colors.green;
      break;
    case "3":
      colorText = Colors.blue;
      break;
    case "4":
      colorText = Colors.yellow;
      break;
    case "5":
      colorText = Colors.orange;
      break;
    default:
      colorText = Colors.black;
      break;
  }

  return colorText;
}

// Color getColorForRemark(String remark) {
//   switch (remark) {
//     case '1':
//       print("this is one");
//       return Colors.red;
//     case '2':
//       print("this is two");
//       return Colors.green;
//     case '3':
//       print("this is three");
//       return Colors.yellow;
//     default:
//       print("this is four");
//       return Colors.orange;
//   }
// }

Color color(String remark) {
  if (remark.contains("2")) {
    return Colors.red; // or any color you want for "2"
  } else if (remark.contains("4")) {
    return Colors.green; // or any color you want for "4"
  }
  return Colors.grey; // default color
}

