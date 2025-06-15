import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/utils/consts/app_colors.dart';

class CommonMethods{
  static showToast(String message, color) {
    Fluttertoast.showToast(
      msg: message,
      textColor: color,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 4,
      gravity: ToastGravity.TOP,
      backgroundColor: AppColorsList.red,
    );
  }
}