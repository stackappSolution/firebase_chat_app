import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:signal/pages/chating_page/chating_page.dart';

import 'package:video_player/video_player.dart';
import '../app/app/utills/app_utills.dart';
import '../pages/chating_page/chating_page_view_modal.dart';

class ChatingPageController extends GetxController {
  ChatingPage? chatingPage;
  ChatingPageViewModal chatingPageViewModal = ChatingPageViewModal();

  final player = AudioPlayer();
  VideoPlayerController? controller;

  List<Duration> durationList = [];
  List<Duration> positionList = [];
  List isPlayList = [];
  List playerList = [];

  late Stream<Duration?> streamDuration;

  int index = 0;

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //
  //   player.playerStateStream.listen((state) {
  //     isPlayList[index].value = state.playing;
  //     logs("play index --- > ${index}");
  //     update();
  //   });
  //
  //   player.durationStream.listen((event) {
  //     durationList[index] = event!;
  //     update();
  //   });
  //
  //   player.positionStream.listen((event) {
  //     positionList[index] = event;
  //     update();
  //   });
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }
}
