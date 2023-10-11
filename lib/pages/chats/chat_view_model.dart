import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/pages/chats/chat_screen.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_helper.dart';

import '../../app/widget/app_elevated_button.dart';
import '../../app/widget/app_text.dart';
import '../../constant/color_constant.dart';
import '../../constant/string_constant.dart';
import '../../service/users_service.dart';

class ChatViewModel {
  ChatScreen? chatScreen;
  List<Contact> contacts = [];
  List<Contact> filterContacts = [];
  String string = '';
  bool isConnected = false;

  Map<String, dynamic> arguments = {};
  dynamic snapshots;


  final Stream<QuerySnapshot> usersStream = UsersService.getUserStream();

  List<DocumentSnapshot> data = [];
  List timeStamp = [];
  ContactController? controller;

  ChatViewModel(this.chatScreen) {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        controller = Get.find<ContactController>();
      },
    );
  }

  Future<void> getPermission() async {
    final PermissionStatus permissionStatus = await Permission.contacts.status;

    if (permissionStatus.isGranted) {
      fetchContacts();
    } else {
      final PermissionStatus requestResult =
          await Permission.contacts.request();

      if (requestResult.isGranted) {
        fetchContacts();
      } else {
        logs('Contacts permission denied');
      }
    }
  }

  void fetchContacts() async {
    DataBaseHelper.getContactDetails();
    logs("fetch contact entered");
    contacts = await ContactsService.getContacts();
    logs("saved contact length----->  ${contacts.length}");
    for (int i = 0; i < contacts.length; i++) {
      Contact contact = contacts[i];
      if (contact.phones!.isNotEmpty && contact.displayName!.isNotEmpty) {
        await DataBaseHelper.setContactDetails(
            contact.displayName, contact.phones!.first.value ?? "");
      }
    }
    DataBaseHelper.getContactDetails();
    controller!.update();
  }

  getNameFromContact(String number) {
    for (var contact in DataBaseHelper.contactData) {
      if (contact["contact"].toString().trim().removeAllWhitespace == number) {
        return contact["name"] ?? "";
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

  // Future<void> markMessagesAsSeen(String chatRoomId, String receiverId) async {
  //   await FirebaseFirestore.instance
  //       .collection("rooms")
  //       .doc().get().then((value){
  //     List<String> roomsId = [];
  //     logs('roooomsssssiddd-->$roomsId');
  //     for (var doc in value.docs) {
  //       roomsId.add(doc.id);
  //     }
  //   });
  //
  //   FirebaseFirestore.instance
  //       .collection("rooms")
  //       .doc(chatRoomId)
  //       .collection("chats")
  //       .where('sender', isEqualTo: receiverId)
  //       .where("messageStatus", isEqualTo: false)
  //       .get()
  //       .then((value) {
  //     List<String> messageIds = [];
  //     for (var doc in value.docs) {
  //       messageIds.add(doc.id);
  //     }
  //
  //     for (var element in messageIds) {
  //       FirebaseFirestore.instance
  //           .collection('rooms')
  //           .doc(chatRoomId)
  //           .collection('chats')
  //           .doc(element)
  //           .update({'messageStatus': true}).then((value) {
  //         print("massage upgraded");
  //       });
  //       print("value-----------> ${value.docs.length}");
  //     }
  //   });
  // }
  List<String> roomid = [];

  Future<void> markMessagesAsSeenChatPage() async {
    FirebaseFirestore.instance
        .collection("rooms").where('members', arrayContains: AuthService.auth.currentUser!.phoneNumber).get().then((value) {
      for (var doc in value.docs) {
        roomid.add(doc.id);
      }
      logs('rooomIdddd-->$roomid');
    });
    for(int i = 0;i<=roomid.length;i++){
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

