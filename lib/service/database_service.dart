import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/modal/message.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {

  String documentId = '';
  static FirebaseAuth auth = FirebaseAuth.instance;


  //================================addNewMessage============================

  void addNewMessage({
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
        message: massage!, sender: sender!, members: members, type: type);
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

  void addChatMessages({
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
        .add(Message(
                message: message!,
                isSender: true,
                messageTimestamp: DateTime.now().millisecondsSinceEpoch,
                messageType: type!,
                sender: sender!)
            .toJson());
  }

  //=============================getChats====================================

  Stream<QuerySnapshot<Object?>> getChatStream(String id) {
    final Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(id)
        .collection('chats')
        .orderBy('messageTimestamp', descending: false)
        .snapshots();
    return chatStream;
  }



  //==============================getChatRoomId===============================

  Future<QuerySnapshot<Map<String, dynamic>>> getChatRoomId(List<dynamic> conversationId) async {
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

  //========================== Upload Image on Storage =================================

  static String imageURL = "";
  static uploadImage(File imageUrl) async {
    String imageURL = "";
    final storage = FirebaseStorage.instance
        .ref('images')
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('sentImage.jpg');
    await storage.putFile(imageUrl);
    imageURL = await storage.getDownloadURL();
    logs("Image URL ------ > $imageURL");
  }

 //========================== Upload Audio on Storage =================================

  static String audioURL = "";
  static uploadAudio(File url, controller) async {
    final storage = FirebaseStorage.instance
        .ref('audio')
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('sentAudio.mp3');
    await storage.putFile(url);
    audioURL = await storage.getDownloadURL();
    controller.update();
  }

}
