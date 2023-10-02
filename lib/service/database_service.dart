import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/acccount_controller.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/modal/message.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../modal/first_message_model.dart';

class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static bool isLoading = false;
  static int downloadPercentage = 0;

  //================================addNewMessage============================

  void addNewMessage(sendMessageModel) async {
    logs("database-----> ${sendMessageModel!.message}");

    bool isFirst = await checkFirst(sendMessageModel!.members!);
    if (true) {
      logs("msg----> ${sendMessageModel.message}");
      addChatMessage(sendMessageModel);
    }
    if (isFirst) {
      addChatMessage(sendMessageModel);

      DocumentReference doc = await FirebaseFirestore.instance.collection('rooms').add({
        'id': '',
        'members': sendMessageModel!.members,
        'isGroup': sendMessageModel!.isGroup,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      await doc.update({'id': doc.id});

      if (sendMessageModel!.isGroup == true) {
        await doc.update({'id': doc.id});
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(doc.id)
            .update({
          'groupProfile': sendMessageModel.profile,
          'groupName': sendMessageModel.groupName ?? "Give Group Name",
          'createdBy': sendMessageModel.createdBy,
        }).then((value) {
          Get.offAllNamed(RouteHelper.getChattingScreen(), arguments: {
            'isGroup': true,
            'groupName': sendMessageModel.groupName!,
            'members': sendMessageModel.members,
          });
        },);
      }
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

  void addChatMessage(sendMessageModel) async {
    logs("Members---${sendMessageModel.members}");

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('members', isEqualTo: sendMessageModel.members)
        .get();

    logs("ref Id ---- >${querySnapshot.docs.length.toString()}");

    MessageModel messageModel = MessageModel(
        messageStatus: false,
        message: sendMessageModel.message,
        isSender: true,
        messageTimestamp: DateTime.now().millisecondsSinceEpoch,
        messageType: sendMessageModel.type,
        sender: sendMessageModel.sender,
        text: sendMessageModel.text,
        thumb: sendMessageModel.thumb);

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
      File url, AttachmentController controller) async {
    isLoading = true;
    controller.update();

    final storage = FirebaseStorage.instance
        .ref('chat')
        .child("audio")
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('${DateTime.now()}sentDoc.mp3');

    final UploadTask uploadTask = storage.putFile(
      url,
      SettableMetadata(contentType: 'AUDIO'), // Specify the content type
    );
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
      downloadPercentage = (progress * 100).round();
      logs("download ---- > ${progress.toString()}");
      controller.update();
    });

    await uploadTask.whenComplete(() {
      logs('File uploaded successfully');
    });

    storage.getDownloadURL().then(
      (value) {
        logs("value -- > $value");
        downloadAndSaveFile(value, "SENT/AUDIO");
      },
    );
    logs("isLoading-----${isLoading}");
    return await storage.getDownloadURL();
  }

//======================== image ===========================//
  static Future<String>? imageURL;

  static Future<String> uploadImage(
      File url, AttachmentController controller) async {
    isLoading = true;
    controller.update();
    logs("isLoading-----$isLoading");
    final storage = FirebaseStorage.instance
        .ref('chat')
        .child("images")
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('${DateTime.now()}sentDoc.jpg');

    final UploadTask uploadTask = storage.putFile(
      url,
      SettableMetadata(contentType: 'IMAGE'), // Specify the content type
    );
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
      downloadPercentage = (progress * 100).round();
      logs("download ---- > ${progress.toString()}");
      controller.update();
    });

    await uploadTask.whenComplete(() {
      logs('File uploaded successfully');
    });

    storage.getDownloadURL().then(
      (value) {
        logs("value -- > $value");
        downloadAndSaveFile(value, "SENT/IMAGE");
      },
    );
    return await storage.getDownloadURL();
  }

  //======================== upload image thumb ===========================//

  static Future<String> uploadThumb(
      File url, AttachmentController controller) async {
    isLoading = true;
    controller.update();
    logs("isLoading-----$isLoading");
    final storage = FirebaseStorage.instance
        .ref('chat')
        .child("thumbnails")
        .child("thumb.png");

    final UploadTask uploadTask = storage.putFile(
      url,
      SettableMetadata(contentType: 'IMAGE'), // Specify the content type
    );
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
      downloadPercentage = (progress * 100).round();
      logs("download ---- > ${progress.toString()}");
      controller.update();
    });

    await uploadTask.whenComplete(() {
      logs('File uploaded successfully');
    });

    return await storage.getDownloadURL();
  }

//======================== markMessageAsSeen ===========================//

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

  //===========getChatDoc===================================================//

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
        .child('${DateTime.now()}sentDoc.mp4');

    final UploadTask uploadTask = storage.putFile(
      url,
      SettableMetadata(contentType: 'VIDEO'), // Specify the content type
    );
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
      downloadPercentage = (progress * 100).round();
      logs("download ---- > ${progress.toString()}");
      controller.update();
    });

    await uploadTask.whenComplete(() {
      logs('File uploaded successfully');
    });

    storage.getDownloadURL().then(
      (value) {
        logs("value -- > $value");
        downloadAndSaveFile(value, "SENT/VIDEO");
      },
    );
    return await storage.getDownloadURL();
  }

//==================== file Upload =====================//

  static String docURL = "";

  static Future<String> uploadDoc(File url, controller, extension) async {
    isLoading = true;
    logs("file Extension ----- >$extension");
    controller.update();
    final storage = FirebaseStorage.instance
        .ref('chat')
        .child("doc")
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('${DateTime.now()}sentDoc.$extension');

    final UploadTask uploadTask = storage.putFile(
      url,
      SettableMetadata(contentType: 'DOC'), // Specify the content type
    );
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
      downloadPercentage = (progress * 100).round();
      logs("download ---- > ${progress.toString()}");
      controller.update();
    });

    await uploadTask.whenComplete(() {
      logs('File uploaded successfully');
    });

    storage.getDownloadURL().then(
      (value) {
        logs("value -- > $value");
        downloadAndSaveFile(value, "SENT/DOC");
      },
    );
    return await storage.getDownloadURL();
  }

  static var rootPath;

  static ChatingPageController? controller;

  static downloadAndSaveFile(
    String pdfURL,
    folderName,
  ) async {
    Future.delayed(const Duration(milliseconds: 0), () async {
      controller = Get.find<ChatingPageController>();
    });

    List splitUrl = pdfURL.split("/");
    final response = await http.get(Uri.parse(pdfURL));
    String? fileName;
    var rootPath;
    rootPath ??= await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    var dirPath = "$rootPath/CHATAPP/$folderName";
    logs("dir path -- $dirPath");
    Directory dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    fileName =
        "myFile${splitUrl.last.toString().substring(splitUrl.last.toString().length - 10, splitUrl.last.toString().length)}.${extensionCheck(pdfURL)}";
    File file = File("${dir.path}/$fileName");
    logs("saved file path --->  ${file.path}");

    await file.writeAsBytes(response.bodyBytes);
    isLoading = false;
    controller!.update();
    logs("isLoading-----$isLoading");
    Get.back();

    logs("downloaded path --- > $fileName");
  }

  static extensionCheck(pdfURL) {
    if (pdfURL.toString().contains("sentDoc.${"jpg"}")) {
      return "jpg";
    }
    if (pdfURL.toString().contains("sentDoc.${"png"}")) {
      return "png";
    }
    if (pdfURL.toString().contains("sentDoc.${"mp4"}")) {
      return "mp4";
    }
    if (pdfURL.toString().contains("sentDoc.${"mp3"}")) {
      return "mp3";
    }
    if (pdfURL.toString().contains("sentDoc.${"pdf"}")) {
      return "pdf";
    }
    if (pdfURL.toString().contains("sentDoc.${"doc"}")) {
      return "doc";
    }
    if (pdfURL.toString().contains("sentDoc.${"docx"}")) {
      return "docx";
    }
  }
}
