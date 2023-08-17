import 'package:flutter/material.dart';


class AppElevatedButton extends StatelessWidget {
  final Color buttonColor;
  final VoidCallback? onPressed;
  final Color fontColor;
  final double buttonHeight;
  final double? fontSize;
  final double? buttonRadius;
  final double buttonWidth;
  final bool isBorderShape;
  final String? buttonName;
  final Widget widget;

  const AppElevatedButton(
      {Key? key,
      this.onPressed,
      required this.buttonColor,
      required this.buttonHeight,
      this.buttonWidth = double.infinity,
      this.isBorderShape = false,
      this.buttonRadius,
      this.buttonName,
      this.fontSize,
      this.fontColor = Colors.white,
      required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          minimumSize:
              MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
          shape: isBorderShape
              ? MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius ?? 10),
                    side: BorderSide(color: buttonColor),
                  ),
                )
              : MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius ?? 20),
                  ),
                ),
          backgroundColor: MaterialStateProperty.all(buttonColor),
        ),
        child: widget);
  }
}
