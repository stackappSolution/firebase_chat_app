import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app/app/utills/app_utills.dart';

class ContactController extends GetxController {
  RxBool isSearch = false.obs;

  bool get searchValue => isSearch.value;
  RxString filteredValue = ''.obs;
  bool isLoading = true;

  void setSearch(bool value) {
    isSearch.value = value;
    update();
  }

  void setFilterText(String value) {
    filteredValue.value = value;
    update();
  }

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
        .where('members', arrayContains: number)
        .snapshots();
  }
  getTimeStamp(id)
  async {
    final  data = await FirebaseFirestore.instance
        .collection("rooms")
        .doc(id)
        .collection("chats")
        .orderBy("timeStamp", descending: true)
        .limit(1)
        .get();
    final docs = data.docs;
    logs("time Stamp --- > ${docs[0]["timeStamp"]}");
  }
}

