import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:signal/modal/message.dart';

import 'package:signal/pages/chating_page/chating_page.dart';

import 'package:video_player/video_player.dart';
import '../pages/chating_page/chating_page_view_modal.dart';

class ChatingPageController extends GetxController {
  ChatingPage? chatingPage;
  ChatingPageViewModal chatingPageViewModal = ChatingPageViewModal();

  final player = AudioPlayer();
  VideoPlayerController? controller;

  RxBool isPlay = false.obs;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Message? message;




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    player.onPlayerStateChanged.listen((state) {
      message?.isPlaying =  state == PlayerState.playing;
      update();
    });

    player.onDurationChanged.listen((event) {
      duration = event;
      update();
    });

    player.onPositionChanged.listen((event) {
      position = event;
      update();
    });


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }
}
