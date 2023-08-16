import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logs("Current Screen --> $runtimeType");
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColorConstant.appWhite,
      appBar: getAppBar(),
          floatingActionButton: buildFloatingButton(),
    ));
  }

  getAppBar() {
    return AppAppBar(
      leading: Padding(
        padding: EdgeInsets.all(16.px),
        child: const AppImageAsset(
          image: AppAsset.person,
        ),
      ),
      title: AppText(AppLocalizations.of(Get.context!)!.calls,
          color: AppColorConstant.appBlack, fontSize: 20.px),
      actions: [
        Padding(
          padding: EdgeInsets.all(18.px),
          child: const AppImageAsset(image: AppAsset.search),
        ),
        Padding(
          padding: EdgeInsets.all(18.px),
          child: const AppImageAsset(image: AppAsset.popup),
        ),
      ],
    );
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
