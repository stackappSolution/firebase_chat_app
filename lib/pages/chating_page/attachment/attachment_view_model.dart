import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/acccount_controller.dart';
import 'package:signal/pages/chating_page/attachment/attachment_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../service/auth_service.dart';
import '../../../service/database_service.dart';

class AttachmentViewModel {
  AttachmentScreen? attachmentScreen;
  Map<String, dynamic> argument = {};
  dynamic selectedImage = "";
  CroppedFile? croppedFile;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = const Duration();
  Duration position = const Duration();

  AttachmentViewModel(this.attachmentScreen);

  imageButtonTap(AttachmentController controller) {
    onSendMessage(
      DatabaseService.imageURL,
      "image",
      controller,
    );
    Get.back;
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

  onSendMessage(message, msgType, AttachmentController controller) async {
    await DatabaseService.uploadImage(File(selectedImage));
    DatabaseService().addNewMessage(
        type: msgType,
        members: argument['members'],
        massage: message,
        sender: AuthService.auth.currentUser!.phoneNumber!,
        isGroup: false);
    logs('message---> $message');

    controller!.update();
  }



  void initAudioPlayer() {
    audioPlayer.onDurationChanged.listen((Duration duration) {
        duration = duration;
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
        position = position;
    });
  }

  void play(controller,path) async {
    logs("Audio Path --- ${path}");
    await audioPlayer.play(AssetSource(path));

      isPlaying = true;
    controller.update();

  }

  void pause(controller) async {
    await audioPlayer.pause();
      isPlaying = false;
    controller.update();

  }

}
