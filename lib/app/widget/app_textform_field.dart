import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  final String leble;
  final String? suffixIcon;
  final GestureTapCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;


  final TextEditingController textEditingController;

  const AppTextFormField(
      {super.key,
      this.hintText,
      required this.textEditingController,
      this.suffixIcon,
      this.onSuffixTap,
      required this.leble, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.px,
      padding: EdgeInsets.only(left: 12.px, right: 10.px),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColorConstant.appWhite,
        borderRadius: BorderRadius.circular(10.px),
        border: Border.all(color: AppColorConstant.appYellowBorder, width: 1.px),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.px),
            child: Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  leble,
                  color: AppColorConstant.appYellow,
                  fontSize: 13.px,
                )),
          ),
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              onChanged:onChanged ,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
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
