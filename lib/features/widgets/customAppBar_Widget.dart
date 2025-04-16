// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/theme.dart';
import '../../core/services/theme_services.dart';
import '../../core/utils/consts/app_colors.dart';
import 'custom_elevatedButton/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.leadingWidget,
    this.isActionsNeed,
    this.appbarColor,
    this.title,
    this.actionIconOnPress,
    this.actionIconOnPress1,
    this.actionIconOnPress3,
    this.actionIcon,
    this.actionIconSize,
    this.actionIcon1,
    this.actionIconSize1,
    this.actionIcon3,
    this.actionIconSize3,
    this.needActionIconVisible,
  }) : super(key: key);
  final Widget? leadingWidget;
  final bool? isActionsNeed;
  final Color? appbarColor;
  final VoidCallback? actionIconOnPress;
  final VoidCallback? actionIconOnPress1;
  final Widget? title;
  final IconData? actionIcon;
  final IconData? actionIcon1;
  final double? actionIconSize;
  final double? actionIconSize1;
  final bool? needActionIconVisible;
  final VoidCallback? actionIconOnPress3;
  final IconData? actionIcon3;
  final double? actionIconSize3;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: appbarColor ?? AppColorsList.green1,
      elevation: 0,
      leading: leadingWidget,
      actions: isActionsNeed == true
          ? [
              Visibility(
                  visible: needActionIconVisible == true ? true : false,
                  child: IconButton(
                    onPressed: actionIconOnPress3,
                    icon: Icon(
                      actionIcon3,
                      size: actionIconSize3,
                    ),
                    color: Colors.white,
                  )),

              actionIcon != null
                  ? IconButton(
                      onPressed: actionIconOnPress,
                      icon: Icon(
                        actionIcon,
                        size: actionIconSize,
                      ),
                      color: Colors.white,
                    )
                  : SizedBox.shrink(),
              actionIcon1 != null
                  ? IconButton(
                      onPressed: actionIconOnPress1,
                      icon: Icon(
                        actionIcon1,
                        size: actionIconSize1,
                      ),
                      color: Colors.white,
                    )
                  : SizedBox.shrink(),
              // IconButton(
              //   onPressed: () {
              //     ThemeServices().switchTheme();
              //   },
              //   icon: Icon(
              //     Get.isDarkMode
              //         ? Icons.wb_sunny_outlined
              //         : Icons.nightlight_round_outlined,
              //   ),
              //   color: Get.isDarkMode ? Colors.orange : darkGreyClr,
              // ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
