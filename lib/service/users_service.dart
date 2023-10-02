import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signal/app/app/utills/app_utills.dart';

import '../modal/user_model.dart';
import 'auth_service.dart';

class UsersService {
  UsersService._privateConstructor();

  static final UsersService instance = UsersService._privateConstructor();
  static final usersCollection = FirebaseFirestore.instance.collection('users');

  //==========================addUsers=======================================

  Future<List<UserModel>> getAllUsers() async {
    try {
      List<UserModel> userModelList = [];
      QuerySnapshot allUserQuery = await usersCollection.get();
      if (allUserQuery.docs.isNotEmpty) {
        for (QueryDocumentSnapshot element in allUserQuery.docs) {
          UserModel userModel =
              UserModel.fromJson(element.data() as Map<String, dynamic>);
          logs('Element data --> ${userModel.toJson()}');
          userModelList.add(userModel);
        }
      }
      return userModelList;
    } on FirebaseException catch (e) {
      logs('Catch exception in getAllUsers --> ${e.message}');
      return [];
    }
  }

  //================================ addUser ================================//

  Future<bool> addUser(UserModel userModel) async {
    try {
      usersCollection
          .doc(AuthService.auth.currentUser!.uid)
          .set(userModel.toJson());
      return true;
    } on FirebaseException catch (e) {
      logs('Catch exception in addUser --> ${e.message}');
      return false;
    }
  }

  //==========================checkBlockedUser=================================

  Future<bool> isBlockedByLoggedInUser(String receiverNumber) async {
    QuerySnapshot querySnapshot =
        await usersCollection.where('phone', isEqualTo: receiverNumber).get();
    final docSnapshot =
        await usersCollection.doc(querySnapshot.docs.first.id).get();
    final blockedUsersList =
        docSnapshot.data()!['blockedNumbers'] ?? <String>[];

    return blockedUsersList
        .contains(AuthService.auth.currentUser!.phoneNumber!);
  }

  //===========================blockUsers=====================================

  Future<void> blockUser(List<String> phoneNo, String receiver) async {
    QuerySnapshot querySnapshot = await usersCollection
        .where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber!)
        .get();

    usersCollection
        .doc(querySnapshot.docs.first.id)
        .update({'blockedNumbers': FieldValue.arrayUnion(phoneNo)});
  }

  //============================getBlockedUsersList===========================

  Future getBlockedUsers() async {
    QuerySnapshot querySnapshot = await usersCollection
        .where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber!)
        .get();
    final userDoc = usersCollection.doc(querySnapshot.docs.first.id);

    final userSnapshot = await userDoc.get();
    final blockedUsers = userSnapshot['blockedNumbers'];

    return blockedUsers;
  }

  //============================unBlockUser==================================

  Future<void> unblockUser(String unBlockedNumber) async {
    QuerySnapshot querySnapshot = await usersCollection
        .where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber!)
        .get();

    usersCollection.doc(querySnapshot.docs.first.id).update({
      'blockedNumbers': FieldValue.arrayRemove([unBlockedNumber]),
    });
  }

  //================================ getUsers ================================//

  static Stream<QuerySnapshot<Object?>> getUserStream() {
    return usersCollection
        .where('id', isEqualTo: AuthService.auth.currentUser!.uid)
        .limit(1)
        .snapshots();
  }
}
