import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final Widget title;
  final Widget? widget;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;
  final EdgeInsetsGeometry? actionsPadding;

  const AppAlertDialog(
      {super.key,
        this.shape,
        this.alignment,
        required this.title,
        this.actions,
        this.backgroundColor,
        this.titlePadding,
        this.titleTextStyle,
        this.actionsPadding,  this.widget});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: actionsPadding,
      backgroundColor: backgroundColor,
      titlePadding: titlePadding,
      titleTextStyle: titleTextStyle,
      shape: shape,
      actions: actions,
      title: title,
      alignment: alignment,
    );
  }}
