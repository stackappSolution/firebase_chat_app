import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logs("Current Screen --> $runtimeType");
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColorConstant.appWhite,
          floatingActionButton: buildFloatingButton(),
    ));
  }


  buildFloatingButton() {
    return Column(mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding:  EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.px)),
            backgroundColor: AppColorConstant.appTheme,
            child:  AppImageAsset(image: AppAsset.phonePlus,height: 25.px,width: 25.px),
            onPressed: () {},
          ),
        ),

      ],
    );
  }

}
