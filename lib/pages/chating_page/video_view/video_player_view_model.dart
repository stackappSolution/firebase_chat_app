// import 'dart:io';
//
// import 'package:signal/pages/chating_page/video_view/video_player_view.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../../app/app/utills/app_utills.dart';
//
// class VideoPlayerViewModel{
//
//   VideoPlayerView? videoPlayerView;
//   VideoPlayerViewModel(this.videoPlayerView);
//
//   Map<String,dynamic> argument={};
//   late VideoPlayerController videoPlayersControllers;
//   Future<void>? initializeVideoPlayer;
//   double sliderValue = 0.0;
//   String  fileSizes = "";
//   String videoPath = "";
//
//   // Future fileSize(controller) async {
//   //   int fileSizeInBytes = await File(videoPath).length();
//   //   double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
//   //   double fileSizeInKB = fileSizeInBytes / 1024;
//   //
//   //   if (fileSizeInMB >= 1.0) {
//   //     fileSizes = '${fileSizeInMB.toStringAsFixed(2)} MB';
//   //   } else {
//   //     fileSizes = '${fileSizeInKB.toStringAsFixed(2)} KB';
//   //   }
//   //
//   //   logs(fileSizes!);
//   //   controller.update();
//   // }
//
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
//   }
//
// }



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:just_audio/just_audio.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/acccount_controller.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/pages/chating_page/attachment/attachment_screen.dart';
import 'package:signal/pages/chating_page/video_view/video_player_view.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../app/app/utills/toast_util.dart';
import '../../../modal/send_message_model.dart';
import '../../../service/auth_service.dart';
import '../../../service/database_service.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewModel {
  VideoPlayerView? videoPlayerView;
  Map<String, dynamic> argument = {};
  dynamic videoFilePath = "";
  late VideoPlayerController videoPlayerController;
  Future<void>? initializeVideoPlayer;

  ChatingPageController? controller;
  bool isLoading = false;
  bool isVideo = false;
  String? fileSizes;

  //final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double sliderValue = 0.0;

  Duration duration = const Duration();
  Duration position = const Duration();

  late Stream<Duration?> streamDuration;

  VideoPlayerViewModel(this.videoPlayerView){}
  void stopVideoPlayback() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      videoPlayerController.dispose();
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }


  Future fileSize(controller, path) async {
    int fileSizeInBytes = await File(path).length();
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
