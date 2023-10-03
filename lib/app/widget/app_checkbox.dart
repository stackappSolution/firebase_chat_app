import 'package:flutter/material.dart';
import 'package:signal/constant/color_constant.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  bool isTapped;

  CustomCheckbox(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.isTapped});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.isTapped
            ? AppColorConstant.appYellowBorder
            : AppColorConstant.appWhite, // Change color when tapped
        border: Border.all(
          width: 1.0,
          color: widget.isTapped
              ? AppColorConstant.appWhite
              : AppColorConstant.appBlack,
        ),
      ),
      child: Center(
          child: Icon(
        Icons.check,
        size: 5,
        color: Colors.black,
      )),
    );
  }
}
