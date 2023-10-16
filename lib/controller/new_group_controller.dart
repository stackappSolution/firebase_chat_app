import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app/app/utills/app_utills.dart';

class GroupController extends GetxController{

  final userTable = FirebaseFirestore.instance.collection('users');
  List userList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserPhoneList();
  }

  Future<bool> checkFirst(String receiver) async {
    QuerySnapshot userMessages = await FirebaseFirestore.instance
        .collection('rooms')
        .where('receiver', isEqualTo: receiver)
        .get();
    update();
    return userMessages.docs.isEmpty;
  }

  Future getUserPhoneList() async {
    if (userList.isEmpty) {
      final data = await userTable.where('phone').get();
      data.docs.forEach((element) {
        userList.add(element["phone"].toString().trim().removeAllWhitespace);
      });
      logs("getUserPhoneList=== $userList");
    }

  }
}