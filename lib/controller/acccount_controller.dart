import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/service/auth_service.dart';

import '../app/app/utills/app_utills.dart';

class AttachmentController extends GetxController {
  final userTable = FirebaseFirestore.instance.collection('users');
  final roomTable = FirebaseFirestore.instance.collection('room');

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
