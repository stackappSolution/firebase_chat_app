import 'package:flutter/material.dart';

import 'app_text.dart';

class AppButton extends StatelessWidget {
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? fontColor;
  final double height;
  final double ?width;
  final Widget? child;
  final Color color;
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final Gradient? gradient;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;
  final GestureTapCallback? onTap;
  final String? string;
  final bool stringChild;

  const AppButton(
      {super.key,
      required this.height,
       this.width,
      required this.color,
      this.shape = BoxShape.rectangle,
      this.child,
      this.borderRadius,
      this.border,
      this.gradient,
      this.margin,
      this.padding,
      this.alignment = Alignment.center,
      this.onTap,
      this.string,
      this.fontWeight,
      this.fontSize,
      this.fontColor,
      required this.stringChild});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            shape: shape,
            color: color,
            borderRadius: borderRadius,
            border: border,
            gradient: gradient),
        margin: margin,
        padding: padding,
        alignment: alignment,
        child: (stringChild == false)
            ? AppText(
               string!,
                fontWeight: fontWeight,
                fontSize: fontSize,
                color: fontColor,
              )
            : child,
      ),
    );
  }
}
