import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/constant/color_constant.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  final String? label;
  final String? suffixIcon;
  final GestureTapCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextStyle? style;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final double? fontSize;

  const AppTextFormField(
      {super.key,
        this.hintText,
        this.label,
        this.suffixIcon,
        this.onSuffixTap,
        this.onChanged,
        this.validator,
        this.inputFormatters,
        this.controller,
        this.style,
        this.labelText,
        this.labelStyle,
        this.keyboardType,
        this.decoration,
        this.fontSize});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      decoration: decoration ??
          InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                 const BorderSide(color: AppColorConstant.appTheme),
                borderRadius: BorderRadius.all(Radius.circular(11.px))),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(11.px)),
              borderSide:  const BorderSide(
                color: AppColorConstant.appTheme,
              ),
            ),
            contentPadding:
            EdgeInsets.symmetric(vertical: 2.px, horizontal: 15.px),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(11.px)),
              borderSide:
               const BorderSide(color: AppColorConstant.appTheme),
            ),
            hintText: hintText,
            labelText: labelText,
            labelStyle:
             const TextStyle(color: AppColorConstant.appTheme),
          ),
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}