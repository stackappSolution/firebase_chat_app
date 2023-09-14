import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
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
  late Stream<Duration?> streamDuration;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    player.playerStateStream.listen((state) {
      isPlay.value =  state.playing;
      update();
    });

    player.durationStream.listen((event) {
      duration = event!;
      update();
    });

    player.positionStream.listen((event) {
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
