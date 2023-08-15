import 'package:flutter/material.dart';
import 'package:signal/constant/app_asset.dart';

class AppText extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final bool isAnimateText;

  const AppText(
    this.title, {
    Key? key,
    this.color,
    this.fontWeight,
    this.fontFamily = AppAsset.defaultFont,
    this.fontSize,
    this.textAlign,
    this.height,
    this.fontStyle,
    this.maxLines,
    this.overflow,
    this.decoration = TextDecoration.none,
    this.letterSpacing,
    this.isAnimateText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? Colors.black,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize ?? 16,
        height: height,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
