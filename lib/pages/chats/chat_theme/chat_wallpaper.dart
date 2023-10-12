import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

// ignore: must_be_immutable
class ChatWallpaperScreen extends StatelessWidget {
  ChatWallpaperScreen({Key? key}) : super(key: key);

  SettingsController? controller;
  Color? wallColor = AppColorConstant.darkBlue;
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    logs('wallcolor-->$wallColor');
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      initState: (state) {},
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
    return AppAppBar(backgroundColor:  Theme.of(context).colorScheme.background,
      title: AppText(S.of(context).chatColorAndWallpaper, fontSize: 20.px,color:  Theme.of(context).colorScheme.primary,),
    );
  }

  getBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildWallpaperFromCamera(context),
        SizedBox(
          height: 20.px,
        ),
        Divider(
          height: 2.px,
          color:  AppColorConstant.grey,
        ),
         Padding(
          padding: const EdgeInsets.all(12.0),
          child: AppText(S.of(context).presets,
              color:  Theme.of(context).colorScheme.primary, textAlign: TextAlign.start),
        ),
        buildWallpaperGridview(),
      ],
    );
  }

  buildWallpaperFromCamera(BuildContext context) {
    return ListTile(
      onTap: () {
        pickImageGallery();
      },
      title:  AppText(S.of(context).chooseFromPhotos,color:  Theme.of(context).colorScheme.primary,),
      leading:  Icon(Icons.image_outlined,color:  Theme.of(context).colorScheme.primary),
    );
  }

  buildWallpaperGridview() {
    List<Color> chatColors = [
      AppColorConstant.darkBlue,
      AppColorConstant.darkOrange,
      AppColorConstant.yellowGrey,
      AppColorConstant.darkGreen,
      AppColorConstant.teal,
      AppColorConstant.pinkPurple,
      AppColorConstant.greyPink,
      AppColorConstant.darkGrey,
      AppColorConstant.extraLightPurple,
      AppColorConstant.extraDarkOrange,
      AppColorConstant.pink,
      AppColorConstant.lightSky,
      AppColorConstant.purple,
      AppColorConstant.darkPink,
      AppColorConstant.grey,
    ];


    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(20.px),
        itemCount: chatColors.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 20.px, mainAxisSpacing: 20.px),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              wallColor = chatColors[index];
              logs('wallcolor-->$wallColor');
              // setStringValue(
              //     wallPaperColor, wallColor!.value.toRadixString(16));
              Get.toNamed(
                RouteHelper.getWallpaperPreviewScreen(),
              );
            },
            child: Container(
              height: 50.px,
              width: 50.px,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.px),
                color: chatColors[index],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> pickImageGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      logs('image pick-->${selectedImage.toString()}');
       // controller!.update();
      Get.toNamed(RouteHelper.getWallpaperPreviewScreen(),
          parameters: {'image': selectedImage!.path});
    }
  }

  // Future<void> chatWallColor()async {
  //   final users = FirebaseFirestore.instance.collection("users");
  //   String? colorCode = wallColor!.value.toRadixString(16);
  //   try {
  //     await users.doc(FirebaseAuth.instance.currentUser!.uid).update(colorCode as Map<Object, Object?>);
  //   } catch (e) {
  //     print('color not added');
  //   }
  // }
}
