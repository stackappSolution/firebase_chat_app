import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app/app/utills/app_utills.dart';

class ChangePhoneController extends GetxController {
  getDocId(newPhoneNumber, oldPhoneNumber) {
    logs("${newPhoneNumber}");
    logs("${oldPhoneNumber}");

    FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: oldPhoneNumber)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs[0].id;

        logs('Document ID: $docId');

        FirebaseFirestore.instance.collection('users').doc(docId).update({
          'phone': newPhoneNumber,
        }).then((_) {
          logs('Phone number updated successfully');
        }).catchError((error) {
          logs('Error updating phone number: $error');
        });
      } else {
        logs('No user found with the old phone number');
      }
    }).catchError((error) {
      logs('Error searching for user: $error');
    });
  }
}
