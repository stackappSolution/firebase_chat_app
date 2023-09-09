import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/acccount_controller.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/pages/chating_page/attachment/attachment_screen.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../service/auth_service.dart';
import '../../../service/database_service.dart';

class AttachmentViewModel {
  AttachmentScreen? attachmentScreen;
  Map<String, dynamic> argument = {};
  dynamic selectedImage = "";
  CroppedFile? croppedFile;
  String? imageURL;
  ChatingPageController? controller;
  bool isLoading=false;

  AttachmentViewModel(this.attachmentScreen){
    Future.delayed(const Duration(milliseconds: 0),() {
      controller= Get.find<ChatingPageController>();
    },);
  }



  imageCrop(BuildContext context, AttachmentController controller) async {
    if (selectedImage != null) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedImage,
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

      selectedImage = croppedFile!.path;
      controller.update();
    } else {
      logs("Please select Image");
    }
  }

  onSendMessage( msgType, AttachmentController controller) async {
    await uploadImage(File(selectedImage));
    DatabaseService().addNewMessage(
        type: msgType,
        members: argument['members'],
        massage: imageURL,
        sender: AuthService.auth.currentUser!.phoneNumber!,
        isGroup: false);
    logs('message---> $imageURL');

    controller.update();
  }

  uploadImage(File imageUrl) async {
    isLoading = true;
    logs("load--> $isLoading");
    controller!.update();
    final storage = FirebaseStorage.instance
        .ref('images')
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('sentImage.jpg');
    await storage.putFile(imageUrl);
    imageURL = await storage.getDownloadURL();
    logs("Image URL ------ > $imageURL");
    isLoading = false;
    logs("load--> $isLoading");
    controller!.update();
    Get.back();
  }



  imageButtonTap(AttachmentController controller) {
    onSendMessage(
      "image",
      controller,
    );
  }

}
