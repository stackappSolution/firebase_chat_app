import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app/app/utills/app_utills.dart';

class GroupController extends GetxController {

  Future<bool> checkFirst(String receiver) async {
    QuerySnapshot userMessages = await FirebaseFirestore.instance
        .collection('rooms')
        .where('receiver', isEqualTo: receiver)
        .get();
    update();
    return userMessages.docs.isEmpty;
  }

}
