import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/generated/l10n.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logs("Current Screen --> $runtimeType");

    return GetBuilder<ContactController>(
      init: ContactController(),
      initState: (state) {},
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: AppColorConstant.appWhite,

            )
        );
      },
    );
  }




  buildFloatingButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(
            elevation: 0.0,
            heroTag: 'calls',
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.px)),
            backgroundColor: AppColorConstant.appTheme,
            child: AppImageAsset(
                image: AppAsset.phonePlus, height: 25.px, width: 25.px),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
