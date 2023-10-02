import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/service/auth_service.dart';

import '../app/app/utills/app_utills.dart';
import '../pages/chating_page/attachment/attachment_screen.dart';

class AttachmentController extends GetxController {
  final userTable = FirebaseFirestore.instance.collection('users');
  final roomTable = FirebaseFirestore.instance.collection('room');

  AttachmentScreen? attachmentScreen;

  final player = AudioPlayer();

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  RxBool isPlay = false.obs;

  late Stream<Duration?> streamDuration;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    player.playerStateStream.listen((state) {
      isPlay.value = state.playing;
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

  Future<void> deleteCollection() async {
    final documents = await userTable
        .where('id', isEqualTo: AuthService.auth.currentUser!.uid)
        .get();
    for (final document in documents.docs) {
      await document.reference.delete();
    }
    goToIntroPage();
    logs("Delete Account");
  }

}
