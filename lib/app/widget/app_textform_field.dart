import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/constant/color_constant.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  final String? label;
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
  final BorderRadius? isborderRadius;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  const AppTextFormField({
    super.key,
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
    this.fontSize,
    this.isborderRadius,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      decoration: decoration ??
          InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColorConstant.appYellowBorder),
                borderRadius:
                    isborderRadius ?? BorderRadius.all(Radius.circular(11.px))),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(11.px)),
              borderSide: const BorderSide(
                color: AppColorConstant.appYellowBorder,
              ),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 2.px, horizontal: 15.px),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(11.px)),
              borderSide:
                  const BorderSide(color: AppColorConstant.appYellowBorder),
            ),
            hintText: hintText,
            labelText: labelText,
            labelStyle:
                const TextStyle(color: AppColorConstant.appYellowBorder),
            suffixIcon: suffixIcon,
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
