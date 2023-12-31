import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:signal/pages/chating_page/chating_page.dart';

import 'package:video_player/video_player.dart';
import '../app/app/utills/app_utills.dart';
import '../pages/chating_page/chating_page_view_modal.dart';

class ChatingPageController extends GetxController {
  ChatingPage? chatingPage;
  ChatingPageViewModal chatingPageViewModal = ChatingPageViewModal();
  final users = FirebaseFirestore.instance.collection("users");
  final rooms = FirebaseFirestore.instance.collection("rooms");

  final player = AudioPlayer();
  VideoPlayerController? controller;

  List<Duration> durationList = [];
  List<Duration> positionList = [];
  List isPlayingList = [];

  late Stream<Duration?> streamDuration;

  int index = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    player.playerStateStream.listen((event) async {
      if (event.processingState == ProcessingState.completed) {
        positionList[index] = const Duration(seconds: 0);
        isPlayingList = List.filled(100, false);
        update();
        player.stop();
        update();
      }
    });

    player.playerStateStream.listen((state) {
      isPlayingList[index] = state.playing;
      logs("play index --- > ${index}");
      update();
    });

    player.durationStream.listen((event) {
      durationList[index] = event!;
      update();
    });

    player.positionStream.listen((event) {
      positionList[index] = event;
      update();
    });
  }

  getUserFcmToken(number) async {
    final t = await users.where('phone', isEqualTo: number).get();
    final data = t.docs;
    return data.first["fcmToken"];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  getChatLength(members) {
    return rooms.where('members', isEqualTo: members).count().get();
  }

  getUserName(number) {
    return users.where('phone', isEqualTo: number).snapshots();
  }
}
