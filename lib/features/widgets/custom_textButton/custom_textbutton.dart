import 'package:flutter/material.dart';
import '../../../main.dart';
import '../custom_elevatedButton/custom_text.dart';
import '../custom_toast/custom_toast.dart';

class CustomTextbutton extends StatelessWidget {
  final VoidCallback onPress;
  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  const CustomTextbutton({
    super.key,
    required this.onPress,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: connectivityService.isConnected,
        builder: (context, isConnected, child) {

          return TextButton(
          onPressed: isConnected? onPress : () {
            errorToast1(
                context: context,
                msg: "Please check your internet connection",
                color: Colors.grey,
                iconColor: Colors.red,
                headingTextColor: Colors.red,
                valueTextColor: Colors.red);
          },
          child: CustomSimpleText(
            text: text,
            color: textColor ?? Colors.black,
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize ?? 16,
            textAlignment: TextAlign.center,
          ),
        );
      }
    );
  }
}
