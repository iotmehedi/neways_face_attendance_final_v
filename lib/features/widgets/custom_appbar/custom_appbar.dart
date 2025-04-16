import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/utils/consts/app_colors.dart';
import '../../../main.dart';
import '../custom_toast/custom_toast.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? actionButtonOne;
  final String? fontFamily;
  final Color? appBarBackgroundColor, titleColor, backiconColor;
  final TextAlign? textAlign;
  final bool? isTextCenter;
  final IconData? actionButtonIcon;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.fontFamily,
    this.appBarBackgroundColor,
    this.titleColor,
    this.backiconColor,
    this.textAlign,
    this.isTextCenter,
    this.actionButtonOne,
    this.actionButtonIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: connectivityService.isConnected,
        builder: (context, isConnected, child) {

          return AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: appBarBackgroundColor ?? AppColorsList.slightWhite,
          centerTitle: isTextCenter ?? true,
          title: Text(
            title,
            textAlign: textAlign ?? TextAlign.center,
            style:GoogleFonts.podkova(
                letterSpacing: 0.2,
                color: titleColor ?? Colors.black,
                fontSize: 20.0,
                fontWeight:  FontWeight.w600,
              )
          ),
          leading: onBackPressed != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: isConnected ? onBackPressed : () {
                    errorToast1(
                        context: context,
                        msg: "Please check your internet connection",
                        color: Colors.grey,
                        iconColor: Colors.red,
                        headingTextColor: Colors.red,
                        valueTextColor: Colors.red);
                  },
            color: backiconColor ?? Colors.black,
            splashColor: Colors.transparent,
                )
              : null,
          actions: actionButtonOne != null ? [
            IconButton(onPressed: actionButtonOne, icon:  Icon(actionButtonIcon ?? Icons.logout))
          ] : [],
        );
      }
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
