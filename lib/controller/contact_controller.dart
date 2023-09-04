import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:signal/service/network_connectivity.dart';


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
}

