import 'package:flutter/material.dart';
import 'package:neways_face_attendance_pro/core/utils/consts/app_sizes.dart';

import '../../../core/utils/consts/app_colors.dart';
import '../../../main.dart';
import '../custom_toast/custom_toast.dart';
import 'custom_text.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color? textColor, iconColor;
  final Color? hexColor; // Ensure hexColor is a Color, not a string
  final FontWeight? fontWeight;
  final VoidCallback? onPress;
  final String text;
  final bool? isIconNeed, isWantExpanded;
  final IconData? icon;
  final double? topRightRadius,
      bottomLeftRadius,
      topLeft,
      bottomRight,
      minimumWidthSize,
      maximumWidthSize,
      fontSize;
  final bool? loading;
  const CustomElevatedButton({
    super.key,
    this.textColor,
    this.onPress,
    this.hexColor,
    required this.text,
    this.bottomLeftRadius,
    this.topRightRadius,
    this.bottomRight,
    this.topLeft,
    this.fontWeight,
    this.icon,
    this.iconColor,
    this.maximumWidthSize,
    this.minimumWidthSize,
    this.isIconNeed,
    this.fontSize,
    this.loading,
    this.isWantExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: connectivityService.isConnected,
        builder: (context, isConnected, child) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: hexColor ??
                  AppColorsList.green, // This works if hexColor is a Color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(topRightRadius ?? 100),
                  bottomLeft: Radius.circular(bottomLeftRadius ?? 100),
                  topLeft: Radius.circular(topLeft ?? 100),
                  bottomRight: Radius.circular(bottomRight ?? 100),
                ),
              ),
            ),
            onPressed: isConnected
                ? onPress
                : () {
                    errorToast1(
                        context: context,
                        msg: "Please check your internet connection",
                        color: Colors.grey,
                        iconColor: Colors.red,
                        headingTextColor: Colors.red,
                        valueTextColor: Colors.red);
                  },
            child: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isIconNeed == true
                          ? Icon(
                              icon,
                              color: iconColor,
                            )
                          : SizedBox.shrink(),
                      isIconNeed == true
                          ? SizedBox(
                              width: 10,
                            )
                          : SizedBox.shrink(),
                      isWantExpanded == false
                          ? CustomSimpleText(
                              text: text,
                              color: textColor ?? Colors.white,
                              fontWeight: fontWeight ?? FontWeight.w500,
                              fontSize: fontSize ?? AppSizes.size16,
                              textAlignment: TextAlign.center,
                              // textOverFlow: TextOverflow.,
                            )
                          : Expanded(
                              child: CustomSimpleText(
                                text: text,
                                color: textColor ?? Colors.white,
                                fontWeight: fontWeight ?? FontWeight.w500,
                                fontSize: fontSize ?? AppSizes.size16,
                                textAlignment: TextAlign.center,
                                // textOverFlow: TextOverflow.,
                              ),
                            ),
                    ],
                  ),
          );
        });
  }
}
