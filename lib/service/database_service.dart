

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signal/pages/signin_pages/sign_in_view_model.dart';

class DatabaseService {
  Future<String?> addMobileNumber(
      {
        required String phoneNumber,
        required String countryCode,
      }) async {
    try {
      DocumentReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users').doc(AuthenticationHelper().user.uid);
          users.set(
          {
            'countryCode': countryCode,
            'phoneNumber': phoneNumber,


          });

      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<Object> getNumber(String email) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data;
    } catch (e) {
      return 'Error fetching user';
    }
  }
}