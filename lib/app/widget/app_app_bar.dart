import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';

class AppAppBar extends PreferredSize {
  final double? appBarHeight;
  final String appbarTitle;
  final GestureTapCallback? onTapBack;

  AppAppBar({
    Key? key,
    this.appBarHeight,
    this.appbarTitle = 'LOGO',
    this.onTapBack,
    Widget? child,
    Size? preferredSize,
  }) : super(
          key: key,
          child: Container(),
          preferredSize: Size.fromHeight(appBarHeight ?? 160.px),
        );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AppImageAsset(image: AppAsset.appBar, height: appBarHeight, width: Device.width, fit: BoxFit.fill),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 20.px, left: 18.px, right: 18.px),
            child: Row(
              children: [
                AppImageAsset(image: AppAsset.drawerIcon, height: 16.px, width: 16.px),
                const Spacer(),
                AppText(appbarTitle, color: AppColorConstant.appWhite, fontSize: 18.px, fontWeight: FontWeight.w600),
                const Spacer(),
                AppImageAsset(image: AppAsset.drawerIcon, height: 16.px, width: 16.px),
              ],
            ),
          ),
        )
      ],
    );
  }
}
