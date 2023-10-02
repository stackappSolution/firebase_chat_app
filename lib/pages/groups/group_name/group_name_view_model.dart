import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/groups/group_name/group_name_screen.dart';
import 'package:signal/service/auth_service.dart';

class GroupNameViewModel {
  GroupNameScreen? groupNameScreen;
  File? selectedImage;
  List membersList = [];
  List<String> mobileNo = [];
  bool isLoading = false;
  String userProfile = "";
  CroppedFile? croppedFile;

  TextEditingController groupNameController = TextEditingController();

  GroupNameViewModel(this.groupNameScreen);

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
                            pickImageCamera(context,controller);
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
                            pickImageGallery(context,controller);
                            Navigator.pop(context);
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

  Future<void> pickImageGallery(context,GetxController controller) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      imageCrop(context, controller);
      logs(selectedImage.toString());
      controller.update();
    }
  }

  Future<void> pickImageCamera( context,controller) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      imageCrop(context, controller);

      logs(selectedImage.toString());
      controller.update();
    }
  }

  void imageCrop( context,  controller) async {
    if (selectedImage != null) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedImage!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColorConstant.appWhite,
              toolbarWidgetColor: AppColorConstant.blackOff,
              initAspectRatio: CropAspectRatioPreset.original,
              activeControlsWidgetColor: AppColorConstant.appYellow,
              backgroundColor: AppColorConstant.appWhite,
              cropFrameColor: AppColorConstant.appYellow,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Crop Image',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      selectedImage = File(croppedFile!.path);
      uploadImage(selectedImage!, controller);

      controller.update();
    } else {
      logs("Please select Image");
    }
  }


  uploadImage(File imageUrl, GetxController controller) async {
    isLoading = true;
    logs("load--> $isLoading");
    controller.update();
    final storage = FirebaseStorage.instance
        .ref('Groups_Profile')
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('group.jpg');
    await storage.putFile(imageUrl);
    userProfile = await storage.getDownloadURL();
    logs("profile........ $userProfile");
    isLoading = false;
    logs("load--> $isLoading");
    controller.update();
  }
}
