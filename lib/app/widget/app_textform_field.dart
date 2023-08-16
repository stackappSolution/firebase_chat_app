import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  final String? lable;
  final String? suffixIcon;
  final GestureTapCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController textEditingController;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextStyle? style;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextInputType? keyboardType;
  final InputDecoration? decoration = const InputDecoration();
  final double? fontSize;

  const AppTextFormField(
      {super.key,
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
        this.hintText,
        this.lable,
        required this.textEditingController,
      });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.px,
      padding: EdgeInsets.only(left: 12.px, right: 10.px),
      decoration: BoxDecoration(
        color: AppColorConstant.appTheme.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.px),
        border:
            Border.all(color: AppColorConstant.appYellowBorder, width: 1.px),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.px),
            child: Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  lable!,
                  color: AppColorConstant.appYellow,
                  fontSize: 13.px,
                )),
          ),
          Expanded(
            child: TextFormField(
              onChanged: onChanged,
              controller: controller,
              decoration: decoration ??
                  InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: hintText,
                    labelText: labelText,
                    labelStyle: labelStyle,
                  ),
              keyboardType: keyboardType,
              validator: validator,
              inputFormatters: inputFormatters,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
          if (suffixIcon != null && suffixIcon!.isNotEmpty) ...[
            SizedBox(width: 12.px),
            InkWell(
                onTap: onSuffixTap,
                child: AppImageAsset(
                    image: suffixIcon, height: 22.px, width: 22.px)),
            SizedBox(width: 12.px),
          ]
        ],
      ),
    );
  }
}
