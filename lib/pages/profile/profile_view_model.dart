import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/pages/profile/profile_screen.dart';

import '../../app/app/utills/app_utills.dart';
import '../../app/app/utills/validation.dart';

class ProfileViewModel {
  ProfileScreen? profileScreen;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String errorFirstName = "";
  bool isButtonActive = false;
  List? multipleImages;

  ProfileViewModel(this.profileScreen) {}

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

  profilePicTap(BuildContext context) async {
    await getPermission(context);
    // ignore: use_build_context_synchronously
  }

  showDialogs(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AppAlertDialog(
          title: AppText(StringConstant.choose),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.px),
              child: AppElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                buttonColor: AppColorConstant.appWhite,
                buttonHeight: 10,
                widget: AppText(
                  StringConstant.cancel,
                  color: AppColorConstant.appYellow,
                  fontSize: 15.px,
                ),
              ),
            )
          ],
          widget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    pickImageCamera();
                  },
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    size: 70.px,
                  )),
              IconButton(
                  onPressed: () {
                    pickImageGallery();
                  },
                  icon: Icon(
                    Icons.image,
                    size: 70.px,
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<void> getPermission(BuildContext context) async {
    final permissionStatus = await Permission.storage.status;
    final permissionStatus1 = await Permission.camera.status;
    if (permissionStatus.isDenied && permissionStatus1.isDenied) {
      await Permission.storage.request();
      await Permission.camera.request();

      if(permissionStatus.isGranted && permissionStatus1.isGranted)
        {
          // ignore: use_build_context_synchronously
          showDialogs(context);
        }

    } else if (permissionStatus.isPermanentlyDenied &&
        permissionStatus1.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      // ignore: use_build_context_synchronously
      showDialogs(context);
    }
  }

  Future<void> pickImageGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      multipleImages!.add(File(pickedFile.path));
    }
  }

  Future<void> pickImageCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      multipleImages!.add(File(pickedFile.path));
    }
  }
}
