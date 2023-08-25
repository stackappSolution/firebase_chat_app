import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/routes/routes_helper.dart';

// ignore: must_be_immutable
class ChatColorWallpaperScreen extends StatelessWidget {
  ChatColorWallpaperScreen({Key? key}) : super(key: key);

  SettingsController? controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      didChangeDependencies: (state) {
        Future.delayed(
          const Duration(milliseconds: 100),
          () async {
            Future<String?> chatTheme = getStringValue(chatColor);
            String? result = await chatTheme;
            logs("default--> $result");
          },
        );
      },
      init: SettingsController(),
      initState: (state) {},
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColorConstant.appWhite,
          appBar: getAppbar(context),
          body: getBody(context),
        );
      },
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      title: AppText(S.of(context).chatColorAndWallpaper),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        buildChatThemeList(context),
        Divider(
          height: 2.px,
          color: AppColorConstant.grey,
        ),
        buildWallpaperThemeList(),
      ],
    );
  }

  buildChatThemeList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
            onTap: () {
              Get.toNamed(RouteHelper.getChatColorScreen());
            },
            title: AppText(S.of(context).chatColor),
            trailing: Container(
              height: 20.px,
              width: 20.px,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColorConstant.appYellow),
            )),
        ListTile(
          onTap: () {
            buildChatResetDialog(context);
          },
          title: AppText(S.of(context).resetChatColor),
        ),
      ],
    );
  }

  buildWallpaperThemeList() {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          onTap: () {
            Get.toNamed(RouteHelper.getChatWallpaperScreen());
          },
          title: AppText(S.of(Get.context!).setWallpaper),
        ),
        ListTile(
          title: AppText(S.of(Get.context!).darkModeWallpaper),
          trailing: Switch(
            value: false,
            onChanged: (value) {},
          ),
        ),
        ListTile(
          onTap: () {
            buildResetDialog(Get.context!);
          },
          title: AppText(S.of(Get.context!).resetWallpaper),
        ),
      ],
    );
  }

  buildResetDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20.px)),
          actionsPadding:
              EdgeInsets.symmetric(horizontal: 15.px, vertical: 15.px),
          backgroundColor: Theme.of(context).colorScheme.background,
          title:  AppText(S.of(context).resetWallpaper),
          actions: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child:
                     AppText(S.of(context).cancel, color: AppColorConstant.appYellow)),
            SizedBox(
              width: 20.px,
            ),
            InkWell(
              onTap: () {
                setStringValue(wallPaperColor,
                    const Color(0xFFFFFFFF).value.toRadixString(16));
                Get.back();
              },
              child:  AppText(
                S.of(context).reset,
                color: AppColorConstant.appYellow,
              ),
            )
          ],
        );
      },
    );
  }

  buildChatResetDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20.px)),
          actionsPadding:
              EdgeInsets.symmetric(horizontal: 15.px, vertical: 15.px),
          backgroundColor: Theme.of(context).colorScheme.background,
          title:  AppText(S.of(context).resetWallpaper),
          actions: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child:
                     AppText(S.of(context).cancel, color: AppColorConstant.appYellow)),
            SizedBox(
              width: 20.px,
            ),
            InkWell(
              onTap: () {
                setStringValue(
                    chatColor, const Color(0xFFf69533).value.toRadixString(16));
                setStringValue(wallpaper, '');
                Get.back();
              },
              child:  AppText(
                S.of(context).reset,
                color: AppColorConstant.appYellow,
              ),
            )
          ],
        );
      },
    );
  }
}
