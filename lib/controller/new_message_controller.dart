import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app/app/utills/app_utills.dart';

class NewMessageController extends GetxController {
  RxBool isSearch = false.obs;

  bool get searchValue => isSearch.value;
  RxString filteredValue = ''.obs;

  void setSearch(bool value) {
    isSearch.value = value;
    update();
  }

  void setFilterText(String value) {
    filteredValue.value = value;
    update();
  }

  Future<bool> doesUserExist(String phoneNumber) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .get();
    return data.docs.isNotEmpty;
  }
}
