import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class NewMessageController extends GetxController {

  Future<bool> doesUserExist(String phoneNumber) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .get();
    return data.docs.isNotEmpty;
  }
}