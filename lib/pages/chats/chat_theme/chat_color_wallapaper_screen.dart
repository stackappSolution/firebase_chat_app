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
          appBar: getAppbar(),
          body: getBody(),
        );
      },
    );
  }

  getAppbar() {
    return AppAppBar(
      title: AppText(S.of(Get.context!).chatColorAndWallpaper),
    );
  }

  getBody() {
    return Column(
      children: [

        buildChatThemeList(),
        Divider(
          height: 2.px,
          color: AppColorConstant.grey,
        ),
        buildWallpaperThemeList(),
      ],
    );
  }

  buildChatThemeList() {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
            onTap: () {
              Get.offAndToNamed(RouteHelper.getChatColorScreen());
            },
            title: AppText(S.of(Get.context!).chatColor),
            trailing: Container(
              height: 20.px,
              width: 20.px,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColorConstant.appTheme),
            )),
        ListTile(
          title: AppText(S.of(Get.context!).resetChatColor),
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
          title: AppText(S.of(Get.context!).resetWallpaper),
        ),
      ],
    );
  }
}
