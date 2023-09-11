import 'package:flutter/material.dart';
import 'package:signal/constant/color_constant.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox({super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tapped = !_tapped;
          widget.onChanged(_tapped);
        });
      },
      child: Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _tapped ? AppColorConstant.appYellowBorder : AppColorConstant.appWhite, // Change color when tapped
          border: Border.all(
            width: 1.0,
            color: _tapped ? AppColorConstant.appWhite :AppColorConstant.appBlack,
          ),
        ),
        child: Center(
          child: widget.value
              ? const Icon(
            Icons.check,
            size: 5,
            color: Colors.black,
          )
              : null,
        ),
      ),
    );
  }
}
