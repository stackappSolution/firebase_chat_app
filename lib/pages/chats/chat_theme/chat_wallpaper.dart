import 'dart:io';

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

class ChatWallpaperScreen extends StatelessWidget {
  ChatWallpaperScreen({Key? key}) : super(key: key);

  SettingsController? controller;
  Color? wallColor = AppColorConstant.darkBlue;
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      initState: (state) {},
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(Get.context!).colorScheme.background,
          appBar: getAppbar(),
          body: getBody(),
        );
      },
    );
  }

  getAppbar() {
    return AppAppBar(
      title: AppText(S.of(Get.context!).chatColorAndWallpaper, fontSize: 20.px),
    );
  }

  getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildWallpaperFromCamera(),
        SizedBox(
          height: 20.px,
        ),
        Divider(
          height: 2.px,
          color: AppColorConstant.grey,
        ),
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: AppText('Presets',
              color: AppColorConstant.appBlack, textAlign: TextAlign.start),
        ),
        buildWallpaperGridview(),
      ],
    );
  }

  buildWallpaperFromCamera() {
    return ListTile(
      onTap: () {
        pickImageGallery();
      },
      title: const AppText('Choose from photos'),
      leading: const Icon(Icons.image_outlined),
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
      AppColorConstant.appWhite,
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
              setStringValue(
                  wallPaperColor, wallColor!.value.toRadixString(16));

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

  Future<void> pickImageGallery( ) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      logs(selectedImage.toString());
      // controller!.update();
      Get.toNamed(RouteHelper.getWallpaperPreviewScreen(),parameters: {'image': selectedImage!.path});
    }
  }
}
