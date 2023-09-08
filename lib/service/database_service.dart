import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final users = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService.auth.currentUser?.uid);
  String documentId = '';
  static FirebaseAuth auth = FirebaseAuth.instance;

  //==========================addUsers=======================================

  Future<String?> addUser(
      {required String firstName,
      String? lastName,
      required String photo,
      required String phone,
      required String fcmToken}) async {
    try {
      users.set({
        'id': AuthService.auth.currentUser!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'photoUrl': photo,
        'phone': phone,
        'fcmToken': fcmToken,
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  //================================getUsers================================

  getUserStream() {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('id', isNotEqualTo: AuthService.auth.currentUser?.uid)
        .snapshots();
    return usersStream;
  }

  //================================addNewMessage============================

  addNewMessage({
    String? type,
    String? createdBy,
    String? profile,
    String? groupName,
    List<dynamic>? members,
    String? massage,
    String? sender,
    bool? isGroup,
  }) async {
    bool isFirst = await checkFirst(members!);

    if (isFirst) {
      DocumentReference doc =
          await FirebaseFirestore.instance.collection('rooms').add({
        'id': '',
        'members': members,
        'isGroup': isGroup,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      await doc.update({'id': doc.id});

      if (isGroup == true) {
        await doc.update({'id': doc.id});
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(doc.id)
            .update({
          'groupProfile': profile,
          'groupName': groupName,
          'createdBy': createdBy,
        }).then((value) =>
                Get.offAllNamed(RouteHelper.getChattingScreen(), arguments: {
                  'isGroup': true,
                  'groupName': groupName!,
                  'members': members,
                }));
      }
      addChatMessages(
          members: members, message: massage, sender: sender, type: type);
    }

    addChatMessages(
        message: massage, sender: sender, members: members, type: type);
  }

  //==========================checkFirstMessage===========================

  Future<bool> checkFirst(List<dynamic> members) async {
    QuerySnapshot userMessages = await FirebaseFirestore.instance
        .collection('rooms')
        .where('members', isEqualTo: members)
        .get();

    return userMessages.docs.isEmpty;
  }

  //===============================addChatMessage=============================

  addChatMessages({
    String? type,
    List<dynamic>? members,
    String? message,
    String? sender,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('members', isEqualTo: members)
        .get();

    logs(querySnapshot.docs.first.id);

    logs(querySnapshot.docs.first.id);

    FirebaseFirestore.instance
        .collection('rooms')
        .doc(querySnapshot.docs.first.id)
        .collection('chats')
        .add({
      'message': message,
      'sender': sender,
      'timeStamp': DateTime.now().millisecondsSinceEpoch,
      'messageType': type,
    });
  }

  //=============================getChats====================================

  getChatStream(String id) {
    final Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(id)
        .collection('chats')
        .orderBy('timeStamp', descending: false)
        .snapshots();
    return chatStream;
  }

  //===========================blockUsers=====================================

  Future<void> blockUser(List<dynamic> phoneNo, String receiver) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber!)
        .get();

    FirebaseFirestore.instance
        .collection('users')
        .doc(querySnapshot.docs.first.id)
        .update({'blockedNumbers': FieldValue.arrayUnion(phoneNo)});
  }

  //============================getBlockedUsersList===========================

  Future<List<dynamic>> getBlockedUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber!)
        .get();
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(querySnapshot.docs.first.id);

    final userSnapshot = await userDoc.get();
    final blockedUsers = userSnapshot['blockedNumbers'];

    return blockedUsers;
  }

  //============================unBlockUser==================================

  Future<void> unblockUser(String unBlockedNumber) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: AuthService.auth.currentUser!.phoneNumber!)
        .get();

    FirebaseFirestore.instance
        .collection('users')
        .doc(querySnapshot.docs.first.id)
        .update({
      'blockedNumbers': FieldValue.arrayRemove([unBlockedNumber]),
    });
  }

  //==============================getChatRoomId===============================

  getChatRoomId(List<dynamic> conversationId) async {
    final snapshots = await FirebaseFirestore.instance
        .collection('rooms')
        .where('members', isEqualTo: conversationId)
        .get();
    return snapshots;
  }

  //==========================checkBlockedUser=================================

  Future<bool> isBlockedByLoggedInUser(String receiverNumber) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: receiverNumber)
        .get();
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(querySnapshot.docs.first.id)
        .get();
    final blockedUsersList =
        docSnapshot.data()!['blockedNumbers'] ?? <String>[];
    return blockedUsersList
        .contains(AuthService.auth.currentUser!.phoneNumber!);
  }






}
