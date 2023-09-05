import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/database_service.dart';

import '../../app/widget/app_alert_dialog.dart';
import '../../app/widget/app_button.dart';
import '../../constant/string_constant.dart';
import '../../service/database_helper.dart';

class ChatViewModel {
  ChatScreen? chatScreen;
  List<Contact> contacts = [];
  List<Contact> filterContacts = [];
  bool isLoading = false;
  String string = '';
  bool isConnected = false;

  final Stream<QuerySnapshot> usersStream = DatabaseService().getUserStream();
  List<DocumentSnapshot> data = [];
  ContactController? controller;

  ChatViewModel(this.chatScreen) {
    Future.delayed(
      const Duration(milliseconds: 0),
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
        return contact["name"];
      }
    }
    return "Not Saved";
  }

}
