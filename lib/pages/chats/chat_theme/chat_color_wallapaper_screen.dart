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
  Color? chatBubbleColor;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      didChangeDependencies: (state) async {
        Future.delayed(const Duration(milliseconds: 0), () async {
          controller = Get.find<SettingsController>();
          chatBubbleColor = await getChatBubbleColor();
          logs('chatColor----> $chatBubbleColor');
          controller!.update();
        });
      },
      init: SettingsController(),
      initState: (state) async {
        Future.delayed(const Duration(milliseconds: 0), () async {
          controller = Get.find<SettingsController>();
          chatBubbleColor = await getChatBubbleColor();
          logs('chatColor----> $chatBubbleColor');
          controller!.update();
        });
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppbar(context),
          body: getBody(context),
        );
      },
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      title: AppText(
        S.of(context).chatColorAndWallpaper,
        color: Theme.of(context).colorScheme.primary,
      ),
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
        buildWallpaperThemeList(context),
      ],
    );
  }

  buildChatThemeList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
            onTap: () async {
              Get.toNamed(RouteHelper.getChatColorScreen());
            },
            title: AppText(S.of(context).chatColor,
                color: Theme.of(context).colorScheme.primary),
            trailing: Container(
              height: 20.px,
              width: 20.px,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: chatBubbleColor),
            )),
        ListTile(
          onTap: () {
            buildChatResetDialog(context);
          },
          title: AppText(S.of(context).resetChatColor,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  buildWallpaperThemeList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          onTap: () {
            Get.toNamed(RouteHelper.getChatWallpaperScreen());
          },
          title: AppText(S.of(Get.context!).setWallpaper,
              color: Theme.of(context).colorScheme.primary),
        ),
        ListTile(
          title: AppText(S.of(Get.context!).darkModeWallpaper,
              color: Theme.of(context).colorScheme.primary),
          trailing: Switch(
            value: false,
            onChanged: (value) {},
          ),
        ),
        ListTile(
          onTap: () {
            buildResetDialog(Get.context!);
          },
          title: AppText(S.of(Get.context!).resetWallpaper,
              color: Theme.of(context).colorScheme.primary),
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
          title: AppText(S.of(context).resetWallpaper),
          actions: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: AppText(S.of(context).cancel,
                    color: AppColorConstant.appYellow)),
            SizedBox(
              width: 20.px,
            ),
            InkWell(
              onTap: () {
                setStringValue(wallPaperColor,
                    const Color(0xFFFFFFFF).value.toRadixString(16));
                controller!.update();
                Get.back();
              },
              child: AppText(
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
          title: AppText(S.of(context).resetChatColor,
              color: Theme.of(context).colorScheme.primary),
          actions: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: AppText(S.of(context).cancel,
                    color: AppColorConstant.appYellow)),
            SizedBox(
              width: 20.px,
            ),
            InkWell(
              onTap: () {
                setStringValue(
                    chatColor, const Color(0xFFf69533).value.toRadixString(16));
                setStringValue(wallpaper, '');
                Get.back();
                Get.off(ChatColorWallpaperScreen());

                controller!.update();
              },
              child: AppText(
                S.of(context).reset,
                color: AppColorConstant.appYellow,
              ),
            )
          ],
        );
      },
    );
  }

  getChatBubbleColor() async {
    final colorCode = await getStringValue(chatColor);
    if (colorCode != null) {
      return Color(int.parse(colorCode, radix: 16));
    } else {
      return AppColorConstant.appYellow;
    }
  }
}
