// ignore_for_file: file_names

import 'package:flutter/material.dart';

headingText({required String text, required Color color, required double fontSize, required FontWeight fontWeight}) {
  return Text(
    text,
    maxLines: 1,
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      letterSpacing: 0.2,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}

globalText({required String text, required Color color, required double fontSize, required FontWeight fontWeight}) {
  return Text(
    text,
    maxLines: 2,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}

globalText2({required String text, required Color color, required double fontSize, required FontWeight fontWeight}) {
  return Text(
    text,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}
