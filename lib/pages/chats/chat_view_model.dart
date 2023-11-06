import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/chat_controller.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/pages/chats/chat_screen.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_helper.dart';

import '../../app/widget/app_elevated_button.dart';
import '../../app/widget/app_text.dart';
import '../../constant/color_constant.dart';
import '../../constant/string_constant.dart';
import '../../modal/message.dart';
import '../../modal/notification_model.dart';
import '../../modal/send_message_model.dart';
import '../../service/notification_api_services.dart';
import '../../service/users_service.dart';

class ChatViewModel {
  ChatScreen? chatScreen;

  String string = '';
  bool isConnected = false;
  bool isLoading = false;
  String token = '';
  Map<String, dynamic> arguments = {};
  dynamic snapshots;

  final Stream<QuerySnapshot> usersStream = UsersService.getUserStream();

  List<DocumentSnapshot> data = [];
  List timeStamp = [];
  ContactController? controller;
  List selectedContacts = [];
  List selectedContactsTrueFalse =  List.filled(1500, false) ;
  ChatViewModel(this.chatScreen) {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        controller = Get.find<ContactController>();
      },
    );
  }

  void addRemove(index, message) {
    selectedContactsTrueFalse[index] = !selectedContactsTrueFalse[index];
    if (selectedContactsTrueFalse[index]) {
      selectedContacts.add(message);
    } else {
      selectedContacts.removeWhere((msg) => msg['id'] == message['id']);
    }
  }

  void getToken(number) async {
    token = await controller!.getUserFcmToken(number);
  }

  Future<void> notification(String message) async {
    ResponseService.postRestUrl(message, token);
    NotificationModel notificationModel = NotificationModel(
      time:' ${DateTime.now().hour}:${DateTime.now().minute} | ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      sender: AuthService.auth.currentUser!.phoneNumber,
      receiver: arguments['number'],
      receiverName: await UsersService.instance.getUserName('${arguments['number']}'),
      senderName: await UsersService.instance.getUserName('${AuthService.auth.currentUser!.phoneNumber}'),
      message: message,
    );

    await UsersService.instance.notification(notificationModel);
  }

  void addChatMessage(MessageModel messageModel, String sampleList) async {
    errorLogs('messageModel.message --> ${messageModel.message}');

    MessageModel newMessageModel = MessageModel(
        messageStatus: false,
        message: messageModel.message,
        isSender: true,
        messageTimestamp: DateTime.now().millisecondsSinceEpoch,
        messageType: messageModel.messageType,
        sender: AuthService.auth.currentUser!.phoneNumber,
        text: messageModel.text,
        thumb: messageModel.thumb,
        messageId: messageModel.messageId);

    DocumentReference messageRef = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(sampleList)
        .collection('chats')
        .add(newMessageModel.toJson());
    String messageId = messageRef.id;
    await messageRef.update({'messageid': messageId});
  }

  void fetchContacts(ContactController controller) async {
    logs("fetch contact entered");
    isLoading = true;
    controller.update();
    contacts = await ContactsService.getContacts();
    isLoading = false;
    controller.update();
    logs("saved contact length----->  ${contacts.length}");
    controller!.update();
  }

  getNameFromContact(String number) {
    for (var contact in contacts) {
      if (contact.phones!.isNotEmpty) {
        if (contact.phones!.first.value.toString().trim().removeAllWhitespace ==
            number) {
          return contact.displayName ?? "";
        }
      }
    }
    return "Not Saved Yet";
  }

  willPopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.transparent)),
          title: const AppText('Exit App', fontWeight: FontWeight.bold),
          content: const AppText('Are you sure you want to exit the app?'),
          actions: [
            Row(
              children: [
                const Spacer(),
                AppElevatedButton(
                  buttonWidth: 50,
                  buttonColor: AppColorConstant.appYellow,
                  buttonHeight: 40,
                  widget: const AppText(StringConstant.yes,
                      color: AppColorConstant.appWhite),
                  onPressed: () {
                    SystemNavigator.pop();
                    Navigator.of(context).pop(true); // Exit the app
                  },
                ),
                const SizedBox(width: 10),
                AppElevatedButton(
                  buttonWidth: 50,
                  buttonColor: AppColorConstant.appYellow,
                  buttonHeight: 40,
                  widget: const AppText(StringConstant.cansel,
                      color: AppColorConstant.appWhite),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Don't exit the app
                  },
                ),
                // Add spacing between buttons
              ],
            ),
          ],
        );
      },
    );
  }

  List<String> roomid = [];

  Future<void> markMessagesAsSeenChatPage() async {
    FirebaseFirestore.instance
        .collection("rooms")
        .where('members',
            arrayContains: AuthService.auth.currentUser!.phoneNumber)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        roomid.add(doc.id);
      }
      logs('rooomIdddd-->$roomid');
    });
    for (int i = 0; i <= roomid.length; i++) {
      FirebaseFirestore.instance
          .collection("rooms")
          .doc(roomid[i])
          .collection("chats")
          .where('messageStatus', isEqualTo: false)
          .get()
          .then((value) {
        List<String> messageIds = [];
        for (var doc in value.docs) {
          messageIds.add(doc.id);
        }
        for (var element in messageIds) {
          FirebaseFirestore.instance
              .collection('rooms')
              .doc(roomid[i])
              .collection('chats')
              .doc(element)
              .update({'messageStatus': true}).then((value) {
            print("massage upgraded");
          });
          print("value-----------> ${value.docs.length}");
        }
      });
    }
  }
}
