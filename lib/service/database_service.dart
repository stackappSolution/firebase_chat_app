import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/acccount_controller.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/modal/message.dart';
import 'package:signal/modal/send_message_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modal/first_message_model.dart';

class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  String documentId = '';
  static FirebaseAuth auth = FirebaseAuth.instance;
  static bool isLoading = false;

  //================================addNewMessage============================

  void addNewMessage(
      {SendMessageModel? sendMessageModel,
      FirstMessageModel? firstMessageModel}) async {
    addChatMessage(sendMessageModel!);

    bool isFirst = await checkFirst(firstMessageModel!.members!);

    if (isFirst) {
      DocumentReference doc =
          await FirebaseFirestore.instance.collection('rooms').add({
        'id': '',
        'members': firstMessageModel.members,
        'isGroup': firstMessageModel.isGroup,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      await doc.update({'id': doc.id});

      if (firstMessageModel.isGroup == true) {
        await doc.update({'id': doc.id});
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(doc.id)
            .update({
          'groupProfile': firstMessageModel.profile,
          'groupName': firstMessageModel.groupName,
          'createdBy': firstMessageModel.createdBy,
        }).then((value) =>
                Get.offAllNamed(RouteHelper.getChattingScreen(), arguments: {
                  'isGroup': true,
                  'groupName': firstMessageModel.groupName!,
                  'members': firstMessageModel.members,
                }));
      }
      addChatMessage(sendMessageModel);
    }
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

  void addChatMessage(
    SendMessageModel sendMessageModel, {
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

    MessageModel messageModel = MessageModel(
        messageStatus: false,
        message: sendMessageModel.message,
        isSender: true,
        messageTimestamp: DateTime.now().millisecondsSinceEpoch,
        messageType: sendMessageModel.type,
        sender: sendMessageModel.sender);

    FirebaseFirestore.instance
        .collection('rooms')
        .doc(querySnapshot.docs.first.id)
        .collection('chats')
        .add(messageModel.toJson());
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

  Future<QuerySnapshot<Map<String, dynamic>>> getChatRoomId(
      List<dynamic> conversationId) async {
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

  //========================== Upload Audio on Storage =================================

  static String audioURL = "";

  static Future<String> uploadAudio(
      File url, ChatingPageController controller) async {
    isLoading = true;
    controller.update();

    final storage = FirebaseStorage.instance
        .ref('chat')
        .child("audio")
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('sentAudio.mp3');
    await storage.putFile(url);
    isLoading = false;
    controller.update();
    logs("isLoading-----${isLoading}");
    return await storage.getDownloadURL();
  }

  static String imageURL = "";

  static Future<String> uploadImage(
      File imageUrl, AttachmentController controller) async {
    isLoading = true;
    controller.update();
    logs("isLoading-----${isLoading}");
    final storage = FirebaseStorage.instance
        .ref('chat')
        .child("images")
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('sentImage.jpg');
    await storage.putFile(imageUrl);
    isLoading = false;
    controller.update();
    logs("isLoading-----${isLoading}");
    Get.back();
    return await storage.getDownloadURL();
  }

//=== markMessageAsSeen =====================================//

  void markMessagesAsSeen(String chatRoomId, String receiverId) {
    FirebaseFirestore.instance
        .collection("rooms")
        .doc(chatRoomId)
        .collection("chats")
        .where('sender', isEqualTo: receiverId)
        .where("messageStatus", isEqualTo: false)
        .get()
        .then((value) {
      List<String> messageIds = [];
      for (var doc in value.docs) {
        messageIds.add(doc.id);
      }

      for (var element in messageIds) {
        FirebaseFirestore.instance
            .collection('rooms')
            .doc(chatRoomId)
            .collection('chats')
            .doc(element)
            .update({'messageStatus': true}).then((value) {
          print("massage upgraded");
        });
        print("value-----------> ${value.docs.length}");
      }
    });
  }

  //===========getChatDoc===================================================

  getChatDoc(List<dynamic> members) async {
    final snapshots = await FirebaseFirestore.instance
        .collection('rooms')
        .where('members', isEqualTo: members)
        .get();

    return snapshots;
  }

  static String videoURL = "";

  static Future<String> uploadVideo(File url, controller) async {
    isLoading = true;
    controller.update();
    final storage = FirebaseStorage.instance
        .ref('chat')
        .child("video")
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('sentVideo.mp4');
    await storage.putFile(url);
    isLoading = false;
    controller.update();
    logs("isLoading-----${isLoading}");
    Get.back();
    return await storage.getDownloadURL();
  }

//==================== file Upload =====================//

  static String docURL = "";

  static Future<String> uploadDoc(File url, controller) async {
    isLoading = true;
    controller.update();
    final storage = FirebaseStorage.instance
        .ref('chat')
        .child("doc")
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('sentDoc.pdf');
    await storage.putFile(url);
    isLoading = false;
    controller.update();
    logs("isLoading-----${isLoading}");
    Get.back();
    return await storage.getDownloadURL();
  }
}
