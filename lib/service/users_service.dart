
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signal/app/app/utills/app_utills.dart';

import '../modal/user_model.dart';
import 'auth_service.dart';

class UsersService {
  static final users = FirebaseFirestore.instance.collection('users');
  static String userName = "  ";
  static String lastName = "  ";
  static String photoUrl = "";

  //==========================addUsers=======================================

  Future<String?> addUser(
      {required String firstName,
      String? lastName,
      required String photo,
      required String phone,
      required String fcmToken}) async {
    try {
      users.doc(AuthService.auth.currentUser!.uid).set(User(
              firstName: firstName,
              lastName: lastName!,
              id: AuthService.auth.currentUser!.uid,
              phone: phone,
              fcmToken: fcmToken,
              photoUrl: photo)
          .toJson());
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  //================================getUsers================================

  static Stream<QuerySnapshot<Object?>> getUserStream() {
    final Stream<QuerySnapshot> usersStream = users
        .where('id', isNotEqualTo: AuthService.auth.currentUser?.uid)
        .snapshots();
    return usersStream;
  }

  //==========================checkBlockedUser=================================

  Future<bool> isBlockedByLoggedInUser(String receiverNumber) async {
    QuerySnapshot querySnapshot =
        await users.where('phone', isEqualTo: receiverNumber).get();
    final docSnapshot = await users.doc(querySnapshot.docs.first.id).get();
    final blockedUsersList =
        docSnapshot.data()!['blockedNumbers'] ?? <String>[];

    return blockedUsersList
        .contains(AuthService.auth.currentUser!.phoneNumber!);
  }

  //===========================blockUsers=====================================

  Future<void> blockUser(List<String> phoneNo, String receiver) async {
    QuerySnapshot querySnapshot = await users
        .where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber!)
        .get();

    users
        .doc(querySnapshot.docs.first.id)
        .update({'blockedNumbers': FieldValue.arrayUnion(phoneNo)});
  }

  //============================getBlockedUsersList===========================

  Future<List<String>> getBlockedUsers() async {
    QuerySnapshot querySnapshot = await users
        .where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber!)
        .get();
    final userDoc = users.doc(querySnapshot.docs.first.id);

    final userSnapshot = await userDoc.get();
    final blockedUsers = userSnapshot['blockedNumbers'];

    return blockedUsers;
  }

  //============================unBlockUser==================================

  Future<void> unblockUser(String unBlockedNumber) async {
    QuerySnapshot querySnapshot = await users
        .where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber!)
        .get();

    users.doc(querySnapshot.docs.first.id).update({
      'blockedNumbers': FieldValue.arrayRemove([unBlockedNumber]),
    });
  }

  static Future getUserData() async {
    final data = await users
        .where('id', isEqualTo: AuthService.auth.currentUser!.uid).limit(1)
        .get();
    userName = data.docs[0]["firstName"];
    photoUrl = data.docs[0]["photoUrl"];
    lastName = data.docs[0]["lastName"];
    logs("current User Name  ---- $userName");
    logs("current photoUrl  ---- $photoUrl");

  }
}
