import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/utils/consts/app_colors.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText, lebelText;
  final TextEditingController? controller;
  final bool? obscureText, needObscureText, needPrefixIcon;
  final VoidCallback? onPress;
  final ValueChanged<String>? onChanged;
  final double? labelLeftPadding, borderRadiusValue, contentPaddingLeft, hintTextSize, suffixIconSize;
  final TextInputType? textInputType;
  final bool? readOnly, needPaddingTopOfHintText;
  final FocusNode? focusNode;
  final int? maxLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? focusBorderColor;
  const CustomTextfield(
      {super.key,
      required this.hintText,
      required this.lebelText,
      this.obscureText,
      this.onPress,
      this.onChanged,
      this.needObscureText,
        this.labelLeftPadding,
       this.controller,
        this.textInputType,
        this.readOnly,
        this.focusNode,
        this.maxLines,
        this.needPrefixIcon,
        this.prefixIcon,
        this.borderRadiusValue,
        this.contentPaddingLeft,
        this.hintTextSize,
        this.suffixIcon,
        this.suffixIconSize,
        this. needPaddingTopOfHintText,
        this. focusBorderColor,
      });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText ?? false,
      controller: controller,
      keyboardType: textInputType ?? TextInputType.text,
      readOnly: readOnly ?? false,
      focusNode: focusNode,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:  EdgeInsets.only(left: contentPaddingLeft ?? 34.0, top: needPaddingTopOfHintText == true ? 20 : 2 ),
          isDense: false,
          isCollapsed: false,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusBorderColor ?? HexColor("B1B1B1"), width: 2),
            borderRadius: BorderRadius.circular(borderRadiusValue ?? 10),
          ),
          filled: true,
          hintText: hintText,
          hintStyle:  TextStyle(
              fontSize: hintTextSize ?? 12,
              fontWeight: FontWeight.normal,
              fontFamily: "Podkova",

          color: HexColor("#888888")
          ),
          hintTextDirection: TextDirection.ltr,
          hintMaxLines: maxLines ?? 1,
          label: Text(
            lebelText,
            style:  TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "Podkova",
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          alignLabelWithHint: true,
          fillColor: HexColor("#FFFFFFF").withValues(alpha: 0.5),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusBorderColor ?? AppColorsList.green1, width: 2),
            borderRadius: BorderRadius.circular(borderRadiusValue ?? 10),
          ),
          // prefixIcon: needPrefixIcon == true ? Icon(prefixIcon, size: AppSizes.size14,) : SizedBox.shrink(),
          suffixIcon: needObscureText == true
              ? IconButton(
                  onPressed: onPress,
                  icon: Icon(
                    obscureText == false
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 22,
                    color: Colors.black.withOpacity(0.6),
                  ))
              : suffixIcon == null ? const SizedBox.shrink() : Icon(suffixIcon, size: suffixIconSize ?? 22, color: Colors.black.withValues(alpha: 0.6),),),
    );
  }
}
