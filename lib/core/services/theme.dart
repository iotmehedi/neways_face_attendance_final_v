// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Get.isDarkMode ? Colors.white : darkGreyClr
      )
    ),
    scaffoldBackgroundColor: Colors.white,
  );
  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkGreyClr,
    scaffoldBackgroundColor: darkGreyClr,
  );

  TextStyle get notificationScreenHeadingTextStyle => GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : darkGreyClr));

  TextStyle get notificationScreenSubHeadingTextStyle => GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Get.isDarkMode ? Colors.white : darkGreyClr));

  TextStyle get notificationScreenBodyTextStyle => GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Colors.white));

  TextStyle get homeScreenHeadingTextStyle => GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : darkGreyClr));

  TextStyle get homeScreenSubHeadingTextStyle => GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Get.isDarkMode ? Colors.white : darkGreyClr));

  TextStyle get taskTileHeadingTextStyle => GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white));

}
