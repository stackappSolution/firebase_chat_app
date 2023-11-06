import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_theme/chat_color_wallapaper_screen.dart';

import '../../../service/auth_service.dart';

// ignore: must_be_immutable
class WallpaperPreviewScreen extends StatelessWidget {
  WallpaperPreviewScreen({Key? key}) : super(key: key);

  SettingsController? controller;
  Color wallColorbackground = AppColorConstant.appTransparent;
  Map<String, dynamic> arguments = {};
  bool isLoading = false;
  final users = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      initState: (state) async {
        arguments = Get.arguments;
        logs('backgroundcolor-->$arguments');

        Future.delayed(
          const Duration(milliseconds: 100),
          () async {
            controller = Get.find<SettingsController>();
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

  Column getBody(BuildContext context) => Column(
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

   Widget buildPreview(BuildContext context) => (arguments['selectedItem'].toString().length>10)
        ? Container(
            height: Device.height * 0.75,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: FileImage(File(arguments['selectedItem'])))),
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
            color: Color(int.parse(arguments['selectedItem'], radix: 16)),
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

  Future<void> onSetWallpaper() async {
    if (arguments['selectedItem'].toString().length>10) {
      logs("its Image");

      uploadImage(File(arguments['selectedItem']));
      Get.back();
      Get.off(ChatColorWallpaperScreen());
    } else {
      logs("color is  ${arguments['selectedItem']}");

      updateColorFirestore(arguments['selectedItem']);
      Get.back();
      Get.off(ChatColorWallpaperScreen());
    }
  }

  Future<String> uploadImage(
    File url,
  ) async {
    final storage = FirebaseStorage.instance
        .ref('wallpaper')
        .child("images")
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('${DateTime.now()}wallpaper.jpg');

    final UploadTask uploadTask = storage.putFile(
      url, SettableMetadata(contentType: 'IMAGE'), // Specify the content type
    );
    await uploadTask.whenComplete(() {
      logs('File uploaded successfully');
    });
    storage.getDownloadURL().then(
      (value) {
        logs("image urll--> $value");
        updateImageFirestore(value);
      },
    );
    return await storage.getDownloadURL();
  }

  Future<void> updateImageFirestore(String photoUrl) async {
    logs("setWallpaperOrColor Entered --> Photo URL: $photoUrl");
    isLoading = true;

    try {
      final currentUser = AuthService.auth.currentUser;
      final userDocRef = users.doc(currentUser!.uid);
      await userDocRef.update({
        'colorCode': '',
      });
      await userDocRef.update({
        'wallpaper': photoUrl,
      });
      logs('Successfully updated wallpaper or color code');
      isLoading = false;
    } catch (e) {
      logs('Error updating wallpaper or color code: $e');
      isLoading = false;
    }
  }

  Future<void> updateColorFirestore(String? colorCode) async {
    logs("setWallpaperOrColor Entered -->  Color Code: $colorCode");
    isLoading = true;
    try {
      final currentUser = AuthService.auth.currentUser;
      final userDocRef = users.doc(currentUser!.uid);

      await userDocRef.update({
        'colorCode': colorCode,
      });
      await userDocRef.update({
        'wallpaper': '',
      });

      logs('Successfully updated wallpaper or color code');
      isLoading = false;
    } catch (e) {
      logs('Error updating wallpaper or color code: $e');
      isLoading = false;
    }
  }
}
