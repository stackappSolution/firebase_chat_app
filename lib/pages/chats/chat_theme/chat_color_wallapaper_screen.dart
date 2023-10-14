import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/users_service.dart';

// ignore: must_be_immutable
class ChatColorWallpaperScreen extends StatelessWidget {
  ChatColorWallpaperScreen({Key? key}) : super(key: key);

  SettingsController? controller;
   String? bubblColor;
  final users = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      didChangeDependencies: (state) async {
        Future.delayed(const Duration(milliseconds: 0), () async {
          controller = Get.find<SettingsController>();
          controller!.update();
        });
      },
      init: SettingsController(),
      initState: (state) async {
        Future.delayed(const Duration(milliseconds: 0), () async {
          controller = Get.find<SettingsController>();

          logs('chatColor----> $bubblColor');
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
              // decoration:
              //      BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
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
                resetwallpaper();
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
                resetbubblecolor();
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
  Future<void> resetbubblecolor() async {
    try {
      final currentUser = AuthService.auth.currentUser;
      final userDocRef = users.doc(currentUser!.uid);

      await userDocRef.update({
        'bubbleColor': "",
      });
      controller!.update();
      logs('Successfully updated wallpaper or color code');
    } catch (e) {
      logs('Error updating wallpaper or color code: $e');
    }
  }

  Future<void> resetwallpaper() async {
    try {
      final currentUser = AuthService.auth.currentUser;
      final userDocRef = users.doc(currentUser!.uid);

      await userDocRef.update({
        'wallpaper': "",
      });
      controller!.update();

      await userDocRef.update({
        'colorCode': "0x00000000",
      });
      controller!.update();
      logs('Successfully updated wallpaper or color code');
    } catch (e) {
      logs('Error updating wallpaper or color code: $e');
    }
  }

}
