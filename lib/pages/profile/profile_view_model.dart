import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/profile_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/home/home_screen.dart';
import 'package:signal/pages/profile/profile_screen.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/users_service.dart';

import '../../app/app/utills/app_utills.dart';
import '../../app/app/utills/toast_util.dart';
import '../../app/app/utills/validation.dart';
import '../../app/widget/app_image_assets.dart';
import '../../constant/app_asset.dart';
import '../../modal/user_model.dart';
import '../../service/notification_service.dart';

class ProfileViewModel {
  ProfileScreen? profileScreen;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String errorFirstName = "";
  bool isButtonActive = false;
  File? selectedImage;
  String? userProfilePicture;
  bool isLoading = false;
  bool isLoadingOnSave = false;
  Map<String, dynamic> parameter = {};
  ProfileController? controller;
  bool isProfileSubmitted = false;

  ProfileViewModel(this.profileScreen) {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        controller = Get.find<ProfileController>();
      },
    );
  }

  onChangedValue(value, GetxController controller, BuildContext context) {
    if (ValidationUtil.validateName(value)) {
      isButtonActive = true;
      errorFirstName = "";

      controller.update();
      logs("on change  ${ValidationUtil.validateName(value)}");
    } else {
      isButtonActive = false;
      errorFirstName = S.of(context).enterValidName;

      controller.update();
    }
  }

  onTapNext(context, GetxController controller) async {
    logs("NextTapped");
    controller.update();
    onSaveProfile();
    goToHomeScreen();
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
            title: AppText(S.of(context).choose,
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
                    S.of(context).cancel,
                    color: AppColorConstant.appYellow,
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
                              image: AppAsset.newCamera)),
                      Padding(
                        padding: EdgeInsets.only(top: 9.px),
                        child: AppText(
                          S.of(context).camera,
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
                            Get.back();
                          },
                          child: AppImageAsset(
                              height: 60.px,
                              color: AppColorConstant.appWhite,
                              image: AppAsset.gallery)),
                      Padding(
                        padding: EdgeInsets.only(top: 9.px),
                        child: AppText(
                          S.of(context).gallery,
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
      // ignore: use_build_context_synchronously
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
      uploadImageStorage(selectedImage!);
      logs(selectedImage.toString());
      controller.update();
    }
  }

  Future<void> pickImageCamera(GetxController controller) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      uploadImageStorage(selectedImage!);
      logs(selectedImage.toString());
      controller.update();
    }
  }

  uploadImageStorage(File filepath) async {
    isLoading = true;
    logs("load--> $isLoading");
    controller!.update();
    final storage = FirebaseStorage.instance
        .ref('profile')
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('profile.jpg');
    await storage.putFile(filepath);
    userProfilePicture = await storage.getDownloadURL();
    logs("profile------> $userProfilePicture");
    isLoading = false;
    logs("load--> $isLoading");
    controller!.update();
    return await storage.getDownloadURL();

  }

  Future<void> onSaveProfile() async {
    UserModel userModel = UserModel(
      id: FirebaseAuth.instance.currentUser?.uid,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      fcmToken: NotificationService.instance.fcmToken ?? '',
      photoUrl: userProfilePicture ?? '',
      phone: FirebaseAuth.instance.currentUser?.phoneNumber
          ?.trim()
          .replaceAll(' ', '```'),
      about: "Heyy!!! i am using ChatApp!!"
    );
    bool isUserAdded = await UsersService.instance.addUser(userModel);
    if (isUserAdded) {
      ToastUtil.successToast("Logged successfully");
      goToHomeScreen();
    }
    isProfileSubmitted = true;
  }
}
