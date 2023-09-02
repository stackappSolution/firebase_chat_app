import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app/app/utills/app_utills.dart';

class ContactController extends GetxController {
  getLastMessage(id) {
    return FirebaseFirestore.instance
        .collection("rooms")
        .doc(id)
        .collection("chats")
        .orderBy("timeStamp", descending: true)
        .limit(1)
        .snapshots();
  }

  getUserName(number) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('phone', isEqualTo:number)
        .snapshots();
  }

  getMyChatContactList(number) {

    return FirebaseFirestore.instance
        .collection('rooms')
    // .where('members', arrayContains: DatabaseService.auth.currentUser!.phoneNumber)
        .snapshots();
  }
}
