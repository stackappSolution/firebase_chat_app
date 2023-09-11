import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../app/app/utills/app_utills.dart';


class NewMessageController extends GetxController {
  RxBool isSearch = false.obs;
  List userList = [];

  bool get searchValue => isSearch.value;
  RxString filteredValue = ''.obs;
  final userTable = FirebaseFirestore.instance.collection('users');

  void setSearch(bool value) {
    isSearch.value = value;
    update();
  }

  void setFilterText(String value) {
    filteredValue.value = value;
    update();
  }

  Future<bool> doesUserExist(String phoneNumber) async {
    final data = await userTable.where('phone', isEqualTo: phoneNumber).get();

    return data.docs.isNotEmpty;
  }

  Future<bool> doesUserExist(String phoneNumber) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .get();
    return data.docs.isNotEmpty;
  }
}
  Future getUserPhoneList() async {
    final data = await userTable.where('phone').get();
    data.docs.forEach((element) {
      userList.add(element["phone"]);
    });
    logs("getUserPhoneList=== ${userList}");
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getProfile(String number) {
    return userTable.where('phone', isEqualTo: number).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>  getUserData(String number) {
    return userTable.where('phone').snapshots();
  }
}
