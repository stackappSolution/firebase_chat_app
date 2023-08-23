import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/routes/routes_helper.dart';

class WallpaperPreviewScreen extends StatelessWidget {
  WallpaperPreviewScreen({Key? key}) : super(key: key);

  SettingsController? controller;
  Color? wallColor;
  Map<String, dynamic> parameter = {};

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      initState: (state) async {
        parameter = Get.parameters;

        Future.delayed(
          const Duration(milliseconds: 100),
          () async {
            controller = Get.find<SettingsController>();
            wallColor = await getColorFromPreferences();
            //image = File(parameter['image']);
            controller!.update();
          },
        );
      },
      builder: (controller) {
        return Scaffold(
          appBar: getAppBar(),
          body: getBody(),
        );
      },
    );
  }

  getAppBar() {
    return AppAppBar(
      title: AppText('Preview', fontSize: 20.px),
    );
  }

  getBody() {
    return Column(
      children: [
        buildPreview(),
        Container(
          margin: EdgeInsets.all(12.px),
          alignment: Alignment.center,
          height: 35.px,
          width: 150.px,
          decoration: BoxDecoration(
              color: AppColorConstant.appWhite,
              borderRadius: BorderRadius.circular(12.px),
              border: Border.all(color: AppColorConstant.grey, width: 2.px)),
          child: InkWell(
              onTap: () {
                if (parameter['image'] != null) {
                  setStringValue('image', parameter['image']);
                  Get.offAndToNamed(RouteHelper.getChattingScreen(),parameters: {'image': parameter['image']});
                }

                Get.offAndToNamed(RouteHelper.getChattingScreen());
              },
              child: const AppText('Set Wallpaper')),
        ),
      ],
    );
  }

  buildPreview() {
    return (parameter['image'] != null)
        ? Container(
            height: 600.px,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File(parameter['image'])))),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(12.px),
                  alignment: Alignment.center,
                  height: 35.px,
                  width: 90.px,
                  decoration: BoxDecoration(
                    color: AppColorConstant.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.px),
                  ),
                  child: const AppText('Today'),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10.px),
                      height: 40.px,
                      width: 230.px,
                      decoration: BoxDecoration(
                          color: AppColorConstant.appWhite,
                          borderRadius: BorderRadius.circular(12.px)),
                      child: AppText(S.of(Get.context!).colorIsOnlyVisibleYou)),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10.px),
                      height: 40.px,
                      width: 230.px,
                      decoration: BoxDecoration(
                          color: AppColorConstant.grey,
                          borderRadius: BorderRadius.circular(12.px)),
                      child: AppText(
                        S.of(Get.context!).colorIsOnlyVisibleYou,
                        color: AppColorConstant.appWhite,
                      )),
                )
              ],
            ),
          )
        : Container(
            height: 600.px,
            width: double.infinity,
            color: wallColor,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(12.px),
                  alignment: Alignment.center,
                  height: 35.px,
                  width: 90.px,
                  decoration: BoxDecoration(
                    color: AppColorConstant.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.px),
                  ),
                  child: const AppText('Today'),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10.px),
                      height: 40.px,
                      width: 230.px,
                      decoration: BoxDecoration(
                          color: AppColorConstant.appWhite,
                          borderRadius: BorderRadius.circular(12.px)),
                      child: AppText(S.of(Get.context!).colorIsOnlyVisibleYou)),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10.px),
                      height: 40.px,
                      width: 230.px,
                      decoration: BoxDecoration(
                          color: AppColorConstant.grey,
                          borderRadius: BorderRadius.circular(12.px)),
                      child: AppText(
                        S.of(Get.context!).colorIsOnlyVisibleYou,
                        color: AppColorConstant.appWhite,
                      )),
                )
              ],
            ),
          );
  }

  Future<Color> getColorFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final colorCode = prefs.getString(wallPaperColor);
    if (colorCode != null) {
      return Color(int.parse(colorCode, radix: 16));
    } else {
      return Colors.black;
    }
  }
}
