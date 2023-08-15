import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/constant/color_constant.dart';

class AppTextFormField extends StatelessWidget {
  final String hintText;
  final String? suffixIcon;
  final GestureTapCallback? onSuffixTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextInputType? keyboardType;
  final InputDecoration? decoration = const InputDecoration();
  final double fontSize;

  const AppTextFormField(
      {super.key,
        required this.hintText,
        this.suffixIcon,
        this.onSuffixTap,
        this.validator,
        this.inputFormatters,
        this.controller,
        this.style,
        this.onChanged,
        this.labelText,
        this.labelStyle,
        this.keyboardType,
        required InputDecoration decoration,
        required this.fontSize,

      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.px,
      padding: EdgeInsets.only(left: 12.px, right: 10.px),
      decoration: BoxDecoration(
        color: AppColorConstant.appTheme.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.px),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller:controller ,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                labelText:labelText,
                labelStyle: labelStyle,
              ),
              keyboardType: keyboardType,
              validator: validator,
              inputFormatters: inputFormatters,
              style:TextStyle(
                fontSize: fontSize,
              ),
              onChanged: onChanged,

            ),
          ),
          if (suffixIcon != null && suffixIcon!.isNotEmpty) ...[
            SizedBox(width: 12.px),
            InkWell(onTap: onSuffixTap, child: AppImageAsset(image: suffixIcon, height: 22.px, width: 22.px)),
            SizedBox(width: 12.px),
          ]
        ],
      ),
    );
  }
}
