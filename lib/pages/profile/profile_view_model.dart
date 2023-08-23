import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/pages/profile/profile_screen.dart';
import 'package:signal/routes/app_navigation.dart';

import '../../app/app/utills/app_utills.dart';
import '../../app/app/utills/validation.dart';
import '../../app/widget/app_image_assets.dart';
import '../../constant/app_asset.dart';

class ProfileViewModel {
  ProfileScreen? profileScreen;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String errorFirstName = "";
  bool isButtonActive = false;
  File? selectedImage;

  ProfileViewModel(this.profileScreen);

  onChangedValue(value, GetxController controller) {
    if (ValidationUtil.validateName(value)) {
      isButtonActive = true;
      errorFirstName = "";

      controller.update();
      logs("on change  ${ValidationUtil.validateName(value)}");
    } else {
      isButtonActive = false;
      errorFirstName = StringConstant.enterValidName;

      controller.update();
    }
  }

  onTapNext(context) {
    goToHomeScreen();
    logs("NextTapped");
  }

  addProfileTap(BuildContext context, GetxController controller) async {
    await getPermission(context, controller);
    // ignore: use_build_context_synchronously
  }

  showDialogs(context, GetxController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AppAlertDialog(
            backgroundColor: AppColorConstant.blackOff,
            title: const AppText(StringConstant.choose,
                color: AppColorConstant.appWhite, fontWeight: FontWeight.bold),
            actions: [
              Padding(
                padding: EdgeInsets.only(
                    left: 80.px, top: 20.px, bottom: 10.px, right: 10.px),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: AppText(
                    StringConstant.cansel,
                    color: AppColorConstant.appTheme,
                    fontSize: 15.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
            insetPadding: EdgeInsets.zero,
            widget: SizedBox(
              height: 100.px,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            pickImageCamera(controller);
                            Navigator.pop(context);
                          },
                          child: AppImageAsset(
                              height: 60.px,
                              color: AppColorConstant.appWhite,
                              image: AppAsset.camera)),
                      Padding(
                        padding: EdgeInsets.only(top: 9.px),
                        child: AppText(
                          StringConstant.camera,
                          fontSize: 15.px,
                          color: AppColorConstant.appWhite,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            pickImageGallery(controller);
                            Navigator.pop(context);
                          },
                          child: AppImageAsset(
                              height: 60.px,
                              color: AppColorConstant.appWhite,
                              image: AppAsset.gallery)),
                      Padding(
                        padding: EdgeInsets.only(top: 9.px),
                        child: const AppText(
                          StringConstant.gallery,
                          fontSize: 15,
                          color: AppColorConstant.appWhite,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future<void> getPermission(
      BuildContext context, GetxController controller) async {
    // final permissionStatus = await Permission.storage.status;
    // final permissionStatus1 = await Permission.camera.status;

    await Permission.camera.request();
    await Permission.storage.request();
    logs(
        "permissionStorage ---- >${await Permission.storage.status.isGranted}");
    logs("permissionCamera ---- >${await Permission.camera.status.isGranted}");
    if (await Permission.camera.status.isGranted ||
        await Permission.storage.status.isGranted) {
      showDialogs(context, controller);
    } else {
      await Permission.storage.request();
      await Permission.camera.request();
    }
  }

  Future<void> pickImageGallery(GetxController controller) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      logs(selectedImage.toString());
      controller.update();
    }
  }

  Future<void> pickImageCamera(GetxController controller) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      controller.update();
    }
  }
}
