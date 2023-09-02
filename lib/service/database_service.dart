


import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {



 static  FirebaseAuth auth = FirebaseAuth.instance;
  // DocumentReference<Map<String, dynamic>> users = FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(AuthService.auth.currentUser?.uid);
  //
  // Future<String?> addUser(
  //     {
  //       required String phone,
  //     }) async {
  //   try {
  //     users.set({
  //       'id': AuthService.auth.currentUser?.uid,
  //       'phone': phone,
  //
  //     });
  //     return 'sucess';
  //   } catch (e) {
  //     return 'Error adding user';
  //   }
  // }
}

