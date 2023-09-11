import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app/app/utills/app_utills.dart';

class ContactController extends GetxController {
  RxBool isSearch = false.obs;

  bool get searchValue => isSearch.value;
  RxString filteredValue = ''.obs;
  bool isLoading = true;

  final rooms = FirebaseFirestore.instance.collection("rooms");
  final users = FirebaseFirestore.instance.collection("users");

  void setSearch(bool value) {
    isSearch.value = value;
    update();
  }

  void setFilterText(String value) {
    filteredValue.value = value;
    update();
  }

  getLastMessage(id) {
    logs(id);
    return rooms
        .doc(id)
        .collection("chats")
        .orderBy("messageTimestamp", descending: true)
        .limit(1)
        .snapshots();
  }

  getUserName(number) {
    return users.where('phone', isEqualTo: number).snapshots();
  }

  getMyChatContactList(number) {
    return rooms.where('members', arrayContains: number).snapshots();
  }

  getTimeStamp(id) async {
    final data = await rooms
        .doc(id)
        .collection("chats")
        .orderBy("messageTimestamp", descending: true)
        .limit(1)
        .get();
    final docs = data.docs;
    logs("time Stamp --- > ${docs[0]["messageTimestamp"]}");
  }
}
