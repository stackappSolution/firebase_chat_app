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
import '../../app/app/utills/app_utills.dart';
import '../../app/app/utills/validation.dart';

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
    logs("NextTapped");
  }

  profilePicTap(BuildContext context, GetxController controller) async {
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

                ))
          ],
          widget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 30.px),
                child: IconButton(
                    onPressed: () {
                      pickImageCamera(controller);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: AppColorConstant.appWhite,
                      size: 70.px,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(right: 30.px),
                child: IconButton(
                    onPressed: () {
                      pickImageGallery(controller);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.image,
                      color: AppColorConstant.appWhite,
                      size: 70.px,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getPermission(
      BuildContext context, GetxController controller) async {
    final permissionStatus = await Permission.storage.status;
    final permissionStatus1 = await Permission.camera.status;
    if (permissionStatus.isDenied && permissionStatus1.isDenied) {
      await Permission.storage.request();
      await Permission.camera.request();
      if (permissionStatus.isGranted && permissionStatus1.isGranted) {
        // ignore: use_build_context_synchronously
        showDialogs(context, controller);
      }
      if (permissionStatus.isDenied && permissionStatus1.isDenied) {
        await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied &&
        permissionStatus1.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      // ignore: use_build_context_synchronously
      showDialogs(context, controller);
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
