import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_theme/chat_color_wallapaper_screen.dart';
import 'package:signal/routes/routes_helper.dart';

// ignore: must_be_immutable
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

            controller!.update();
          },
        );
      },
      builder: (controller) {
        return Scaffold(
          appBar: getAppBar(context),
          body: getBody(context),
        );
      },
    );
  }

  getAppBar(BuildContext context) {
    return AppAppBar(
      title: AppText(S.of(context).preview, fontSize: 20.px),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        buildPreview(context),
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
              onTap: () => onSetWallpaper(),
              child: AppText(S.of(context).setWallpaper)),
        ),
      ],
    );
  }

  buildPreview(BuildContext context) {
    return (parameter['image'] != null)
        ? Container(
            height: Device.height * 0.75,
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
                  child: AppText(S.of(context).today),
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
                      child: AppText(S.of(context).colorIsOnlyVisibleYou)),
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
                        S.of(context).colorIsOnlyVisibleYou,
                        color: AppColorConstant.appWhite,
                      )),
                )
              ],
            ),
          )
        : Container(
            height: Device.height * 0.75,
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
                  child: AppText(
                    S.of(context).today,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                      child: AppText(
                        S.of(context).colorIsOnlyVisibleYou,
                        color: Theme.of(context).colorScheme.primary,
                      )),
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
                        S.of(context).colorIsOnlyVisibleYou,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                )
              ],
            ),
          );
  }

  Future<Color> getColorFromPreferences() async {
    final colorCode = await getStringValue(wallPaperColor);
    if (colorCode != null) {
      return Color(int.parse(colorCode, radix: 16));
    } else {
      return Colors.black;
    }
  }

  onSetWallpaper() {
    if (parameter['image'] != null) {
      setStringValue(wallpaper, parameter['image']);
      Get.back();
      Get.off(ChatColorWallpaperScreen());

      setStringValue(
          wallPaperColor, const Color(0xFFFFFFFF).value.toRadixString(16));
    } else {


      setStringValue(wallpaper, '');
      setStringValue(
          wallPaperColor, wallColor!.value.toRadixString(16));
      Get.back();
      Get.off(ChatColorWallpaperScreen());
    }
  }
}
