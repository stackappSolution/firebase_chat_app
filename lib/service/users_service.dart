import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/modal/transaction_model.dart';

import '../modal/notification_model.dart';
import '../modal/user_model.dart';
import 'auth_service.dart';

class UsersService {
  UsersService. _privateConstructor();

  static final UsersService instance = UsersService._privateConstructor();
  static final usersCollection = FirebaseFirestore.instance.collection('users');
  static final transactionCollection =
      FirebaseFirestore.instance.collection('transaction');

  //static final transactionCollection = FirebaseFirestore.instance.collection('transaction').doc(AuthService.auth.currentUser!.uid);
  static final notificationCollection = FirebaseFirestore.instance.collection('notification');

  //================================ notification ================================//

  Future<bool> notification(NotificationModel notificationModel) async {
    try {
      notificationCollection
          // .doc(AuthService.auth.currentUser!.uid)
          .doc()
          .set(notificationModel.toJson());
      return true;
    } on FirebaseException catch (e) {
      logs('Catch exception in addUser --> ${e.message}');
      return false;
    }
  }
  //================================ Get all notification ================================//

  Future<List<NotificationModel>> getAllNotifications() async {
    List<NotificationModel> notifications = [];

    try {
      String currentUserPhoneNumber = AuthService.auth.currentUser!.phoneNumber ?? '';

      QuerySnapshot querySnapshot = await notificationCollection.where('receiver', isEqualTo: currentUserPhoneNumber).get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        notifications.add(NotificationModel.fromJson(data));
        logs('Notification: $data');
      }

      return notifications;
    } on FirebaseException catch (e) {
      logs('Catch exception in getAllNotifications --> ${e.message}');
      return [];
    }
  }


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
    final snapshot = await usersCollection.where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber).get();
    final docSnapshot = await usersCollection.doc(snapshot.docs.first.id).get();
     List blockedUsersList = docSnapshot.data()!['blockedNumbers'];
    return blockedUsersList.contains(receiverNumber);
  }

  //==========================checkBlockedUser=================================

  Future<bool> isBlockedByReceiver(String receiverNumber) async {
    final snapshot = await usersCollection.where('phone', isEqualTo: receiverNumber).get();
    final docSnapshot = await usersCollection.doc(snapshot.docs.first.id).get();
     List isBlockedByReceiver = docSnapshot.data()!['blockedNumbers'];
    return isBlockedByReceiver.contains(AuthService.auth.currentUser!.phoneNumber);
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

  //================================ getwallpaper ================================//

  static Future<String>? getSinglebackgroundImage() async {
    final data = await  usersCollection
        .where('id', isEqualTo: AuthService.auth.currentUser!.uid)
        .limit(1)
        .get();

    return data.docs.first['wallpaper'];
  }

  static Future<String>? getSinglebubbleColor() async {
    final data = await  usersCollection
        .where('id', isEqualTo: AuthService.auth.currentUser!.uid)
        .limit(1)
        .get();

    return data.docs.first['bubbleColor'];
  }
  //============================= save transaction detail =====================//

  Future<void> saveTransactionToFirestore(TransactionsModel transaction) async {
    try {
      await transactionCollection.add({
        'userid':FirebaseAuth.instance.currentUser!.uid,
        'paymentId': transaction.paymentId,
        'status': transaction.status,
        'amount': transaction.amount,
        'time': transaction.time,
      });
      print('Transaction saved to Firestore.');
    } catch (e) {
      print('Error saving transaction to Firestore: $e');
    }
  }


  /// user id wise get transaction History

  Future<List<TransactionsModel>> getTransactionHistory() async {
    try {
      List<TransactionsModel> transactionModelList = [];
      QuerySnapshot userTransactionQuery = await transactionCollection
          .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      logs('userid-->${FirebaseAuth.instance.currentUser!.uid}');
      logs('Query result length --> ${userTransactionQuery.docs.length}');

      if (userTransactionQuery.docs.isNotEmpty) {
        for (QueryDocumentSnapshot element in userTransactionQuery.docs) {
          TransactionsModel transactionsModel = TransactionsModel.fromJson(
              element.data() as Map<String, dynamic>);
          logs('User History --> ${transactionsModel.toJson()}');
          transactionModelList.add(transactionsModel);
        }
      }
      return transactionModelList;
    } on FirebaseException catch (e) {
      logs('Catch exception in transaction History --> ${e.message}');
      return [];
    }
  }
   Future<String> getUserName(String number) async {
    final userData = await usersCollection
        .where('phone', isEqualTo: number)
        .limit(1)
        .get();

    return userData.docs[0]["firstName"];
  }

}
