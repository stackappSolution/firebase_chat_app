import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:just_audio/just_audio.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/acccount_controller.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/pages/chating_page/attachment/attachment_screen.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../app/app/utills/toast_util.dart';
import '../../../modal/send_message_model.dart';
import '../../../service/auth_service.dart';
import '../../../service/database_service.dart';
import 'package:video_player/video_player.dart';

class AttachmentViewModel {
  AttachmentScreen? attachmentScreen;
  final textController = TextEditingController();
  Map<String, dynamic> argument = {};
  dynamic selectedImage = "";
  CroppedFile? croppedFile;
  late VideoPlayerController videoPlayerController;
  Future<void>? initializeVideoPlayer;

  ChatingPageController? chatController;
  bool isLoading = false;
  bool isVideo = false;
  String? fileSizes;

  //final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double sliderValue = 0.0;

  Duration duration = const Duration();
  Duration position = const Duration();

  RxBool isAudioPlay = false.obs;
  Duration audioDuration = Duration.zero;
  Duration audioPosition = Duration.zero;
  late Stream<Duration?> streamDuration;
  final audioPlayer = AudioPlayer();

  AttachmentViewModel(this.attachmentScreen) {
    Future.delayed(
      const Duration(milliseconds: 0),
      () {
        chatController = Get.find<ChatingPageController>();
      },
    );
  }

  void stopVideoPlayback() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void imageCrop(BuildContext context, AttachmentController controller) async {
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
      fileSize(selectedImage);
      controller.update();
    } else {
      logs("Please select Image");
    }
  }

  void imageButtonTap(AttachmentController controller) {
    onSendMessage("image", controller, "");
  }

  void videoButtonTap(AttachmentController controller) {
    onSendMessage("video", controller, "");
  }

  void documentButtonTap(AttachmentController controller, extension) {
    onSendMessage("doc", controller, extension);
  }

  void audioButtonTap(AttachmentController controller) {
    onSendMessage("audio", controller, "");
  }

  onSendMessage(
      String msgType, AttachmentController controller, extension) async {
    chatController!.durationList = chatController!.durationList.toList();
    chatController!.durationList.add(Duration.zero);
    chatController!.positionList = chatController!.positionList.toList();
    chatController!.positionList.add(Duration.zero);
    chatController!.isPlayingList = chatController!.isPlayingList.toList();
    chatController!.isPlayingList.add(false);

    if (await isFileLarge(File(selectedImage), controller) == false) {
      if (msgType == "image") {
        DatabaseService.uploadThumb(File(argument["thumbnail"]),controller).then((thumb) {
          DatabaseService.uploadImage(File(selectedImage), controller)
              .then((value) {
            logs('message---> $value');
            SendMessageModel sendMessageModel = SendMessageModel(
                type: msgType,
                members: argument['members'],
                message: value,
                thumb: thumb,
                sender: AuthService.auth.currentUser!.phoneNumber!,
                isGroup: false,
                text: textController.text.trim());
            DatabaseService.instance
                .addNewMessage( sendMessageModel);
          });
        },);



      }
      if (msgType == "video") {
        DatabaseService.uploadThumb(File(selectedImage), controller).then(
              (thumb) {
            logs("Image Thumb URL --- >  ${thumb}");
            DatabaseService.uploadVideo(File(selectedImage), controller)
                .then((value) {
              logs('message---> $value');
              SendMessageModel sendMessageModel = SendMessageModel(
                  type: msgType,
                  members: argument['members'],
                  message: value,
                  sender: AuthService.auth.currentUser!.phoneNumber!,
                  isGroup: false,
                  thumb: thumb,
                  text: textController.text.trim());
              DatabaseService.instance
                  .addNewMessage(sendMessageModel);
            });

          },
        );


      }
      if (msgType == "doc") {
        DatabaseService.uploadDoc(File(selectedImage), controller, extension)
            .then((value) {
          logs('message---> $value');
          SendMessageModel sendMessageModel = SendMessageModel(
              type: msgType,
              members: argument['members'],
              message: value,
              sender: AuthService.auth.currentUser!.phoneNumber!,
              isGroup: false,
              text: textController.text.trim());
          DatabaseService.instance
              .addNewMessage(sendMessageModel);
        });
      }

      if (msgType == "audio") {
        DatabaseService.uploadAudio(File(selectedImage), controller)
            .then((value) {
          logs('message---> $value');
          SendMessageModel sendMessageModel = SendMessageModel(
              type: msgType,
              members: argument['members'],
              message: value,
              sender: AuthService.auth.currentUser!.phoneNumber!,
              isGroup: false,
              text: textController.text.trim());
          DatabaseService.instance
              .addNewMessage(sendMessageModel);
        });
      }
    }
  }

  Future<bool> isFileLarge(File imageFile, controller) async {
    int fileSizeInBytes = await imageFile.length();

    double fileSizeInMB = (fileSizeInBytes / (1024 * 1024)).toDouble();

    if (fileSizeInMB < 2) {
      logs('Image is smaller than 2 MB.');
      return false;
    } else {
      ToastUtil.successToast("File is larger than 2 MB.");
      logs('Image is larger than 2 MB.');
      return true;
    }
  }

  Future fileSize(controller) async {
    int fileSizeInBytes = await File(selectedImage).length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    double fileSizeInKB = fileSizeInBytes / 1024;

    if (fileSizeInMB >= 1.0) {
      fileSizes = '${fileSizeInMB.toStringAsFixed(2)} MB';
    } else {
      fileSizes = '${fileSizeInKB.toStringAsFixed(2)} KB';
    }

    logs(fileSizes!);
    controller.update();
  }
}
