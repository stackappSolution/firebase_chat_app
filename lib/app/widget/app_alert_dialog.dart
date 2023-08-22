import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final Widget? title;
  final Widget? widget;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;
  final EdgeInsetsGeometry? actionsPadding;
  final double? elevation;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsets insetPadding;

  const AppAlertDialog({
      this.shape,
      this.alignment,
      this.title,
      this.widget,
      this.actions,
      this.backgroundColor,
      this.titlePadding,
      this.titleTextStyle,
      this.actionsPadding,
      this.elevation,
      this.contentPadding,
      required this.insetPadding, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: widget,
        actionsPadding: actionsPadding,
        backgroundColor: backgroundColor,
        titlePadding: titlePadding,
        titleTextStyle: titleTextStyle,
        shape: shape,
        actions: actions,
        title: title,
        alignment: alignment,
        elevation: elevation,
        contentPadding: contentPadding,
        insetPadding: insetPadding);
  }
}
