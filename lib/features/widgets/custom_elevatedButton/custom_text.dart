import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/consts/app_colors.dart';
class CustomMultilineText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;
  final TextAlign? alignment;
  final int? maxLine;
  const CustomMultilineText(
      {super.key,
      required this.text,
      this.fontWeight,
      this.color,
      this.fontSize,
      this.fontStyle,
      this.alignment,
      this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment ?? TextAlign.justify,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      textDirection: TextDirection.ltr,
      style: TextStyle(
          color: color ?? Theme.of(context).textTheme.displayLarge?.color,
          fontWeight:
              fontWeight ?? Theme.of(context).textTheme.displayLarge?.fontWeight,
          fontSize: fontSize ?? Theme.of(context).textTheme.displayLarge?.fontSize,
          fontStyle:
              fontStyle ?? Theme.of(context).textTheme.displayLarge?.fontStyle),
    );
  }
}

class CustomSimpleText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;
  final TextAlign? textAlignment;
  final TextDecoration? textDecoration;
  final TextOverflow? textOverFlow;

  const CustomSimpleText({
    super.key,
    required this.text,
    this.fontWeight,
    this.color,
    this.fontSize,
    this.fontStyle,
    this.textAlignment,
    this.textDecoration,
    this.textOverFlow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlignment ?? TextAlign.center,
      overflow: textOverFlow ?? TextOverflow.visible,
      style: GoogleFonts.roboto(
          fontWeight: fontWeight ?? FontWeight.w600,
          fontSize: fontSize ?? 16,
          color: color ?? Theme.of(context).colorScheme.onSurface,
        decoration: textDecoration,
      ),
    );
  }
}

class FieldTitleText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;
  final TextAlign? alignment;
  const FieldTitleText(
      {super.key,
      required this.text,
      this.fontWeight,
      this.color,
      this.fontSize,
      this.fontStyle,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment ?? TextAlign.start,
      style: TextStyle(
          color: color.toString().isEmpty
              ? AppColorsList.white
              : color,
          fontWeight:
              fontWeight ?? Theme.of(context).textTheme.displayLarge?.fontWeight,
          fontSize: fontSize ?? 18,
          fontStyle:
              fontStyle ?? Theme.of(context).textTheme.displayLarge?.fontStyle),
    );
  }
}
class CustomRichText extends StatelessWidget {
  final String title, heading;
  final Color? titleTextColor, headingTextColor;
  final double? headingFontSize, titleFontSIze;
  final FontWeight? titleFontWeight, headingFontWeight;
  final bool? fontFamily;
  final VoidCallback? onPress;
  const CustomRichText(
      {super.key,
        required this.title,
         this.titleTextColor,
        required this.heading,
        this.headingFontSize,
        this.headingTextColor,
        this.titleFontSIze,
        this.titleFontWeight,
        this.headingFontWeight, this.fontFamily,
        this.onPress
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: RichText(
        text: TextSpan(
          text: heading,
          style: GoogleFonts.inter(
              fontWeight: headingFontWeight ?? FontWeight.w600,
              fontSize: headingFontSize ?? 16,
              color: headingTextColor ?? Colors.black),
          children: <TextSpan>[
            const TextSpan(
              text: ' ',  // Adding a space between the two text spans
            ),
            TextSpan(
              text: title,
              style: GoogleFonts.inter(
                fontWeight: titleFontWeight ?? FontWeight.w600,
                fontSize: titleFontSIze ?? 16,
                color: titleTextColor ?? Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomRichThreeText extends StatelessWidget {
  final String title, heading, value;
  final Color? titleTextColor, headingTextColor, valueTextColor;
  final double? headingFontSize, titleFontSIze, valueFontSize;
  final FontWeight? titleFontWeight, headingFontWeight, valueFontWeight;
  const CustomRichThreeText(
      {super.key,
        required this.title,
        this.titleTextColor,
        required this.heading,
        this.headingFontSize,
        this.headingTextColor,
        this.titleFontSIze,
        this.titleFontWeight,
        this.headingFontWeight,
        required this.value,
        this.valueFontSize,
        this.valueFontWeight,
        this.valueTextColor
      });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: heading,
        style: GoogleFonts.poppins(
            fontWeight: headingFontWeight ?? FontWeight.w600,
            fontSize: headingFontSize ?? 16,
            color: headingTextColor ?? Colors.black),
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: GoogleFonts.poppins(
                fontWeight: titleFontWeight ?? FontWeight.w600,
                fontSize: titleFontSIze ?? 16,
                color: titleTextColor ?? Colors.black),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(
                fontWeight: valueFontWeight ?? FontWeight.w600,
                fontSize: valueFontSize ?? 16,
                color: valueTextColor ?? Colors.black),
          ),
        ],
      ),
    );
  }
}

