
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:video_player/video_player.dart';
import '../pages/chating_page/chating_page_view_modal.dart';

class ChatingPageController extends GetxController {
  ChatingPage? chatingPage;
  ChatingPageViewModal chatingPageViewModal = ChatingPageViewModal();
  AudioPlayer player = AudioPlayer();
  RxBool isPlay = false.obs;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    player.onPlayerStateChanged.listen((state) {
      isPlay.value = state == PlayerState.playing;
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





}
