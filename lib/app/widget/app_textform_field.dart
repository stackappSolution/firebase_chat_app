import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/constant/color_constant.dart';

class AppTextFormField extends StatelessWidget {
  final String hintText;
  final String? suffixIcon;
  final GestureTapCallback? onSuffixTap;

  final TextEditingController textEditingController;

  const AppTextFormField(
      {super.key, required this.hintText, required this.textEditingController, this.suffixIcon, this.onSuffixTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.px,
      padding: EdgeInsets.only(left: 12.px, right: 10.px),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColorConstant.appWhite,
        borderRadius: BorderRadius.circular(10.px),
        border: Border.all(color: AppColorConstant.appLightGrey, width: 1.px),
        boxShadow: AppColorConstant.appBoxShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
              ),
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
