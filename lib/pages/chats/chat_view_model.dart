import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/pages/chats/chat_screen.dart';
import 'package:signal/service/database_helper.dart';

import '../../service/users_service.dart';


class ChatViewModel {
  ChatScreen? chatScreen;
  List<Contact> contacts = [];
  List<Contact> filterContacts = [];
  bool isLoading = false;
  String string = '';
  bool isConnected = false;

  final Stream<QuerySnapshot> usersStream = UsersService.getUserStream();
  List<DocumentSnapshot> data = [];
  List timeStamp = [];
  ContactController? controller;

  ChatViewModel(this.chatScreen) {
    Future.delayed(
      const Duration(milliseconds: 20),
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
    logs("fetch contact entered");
    contacts = await ContactsService.getContacts();
    isLoading = false;
    logs("saved contact length----->  ${contacts.length}");
    for (int i = 0; i < contacts.length; i++) {
      Contact contact = contacts[i];
      await DataBaseHelper.setContactDetails(
          contact.displayName, contact.phones!.first.value);
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
}

