import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/new_message_controller.dart';
import 'package:signal/pages/new_message_page/new_message_page.dart';
import '../../service/database_helper.dart';
class NewMessageViewModel {
  NewMessagePage? newMessagePage;
  List<Contact> contacts = [];
  List<Contact> filterContacts = [];
  bool isLoading = true;
  NewMessageController? newMessageController;
  bool isIcon = true;
  bool isKeyBoard = true;
  TextEditingController textController = TextEditingController();
  bool isSerching = false;
  List<String> mobileNumbers = [];
  NewMessageViewModel(this.newMessagePage) {
    Future.delayed(
      const Duration(milliseconds: 0),
          () {
        newMessageController = Get.find<NewMessageController>();
      },
    );
  }
  void toggleIcon() {
    isIcon = !isIcon;
    textController.clear();
    newMessageController!.update();
    logs('isIcon--> $isIcon');
  }
  TextInputType getKeyboardType() {
    return isIcon ? TextInputType.text : TextInputType.number;
  }
  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      await Permission.contacts.request();
    }
  }
  void fetchContacts() async {
    logs("fetch contact entered");
    contacts = await ContactsService.getContacts();
    isLoading = false;
    newMessageController!.update();
  }
  getAllContacts() async {
    List<Contact> contacts =
    (await ContactsService.getContacts(withThumbnails: false)).toList();
    logs("contacts length-->${contacts.length}");
  }
  Future<List<String>> getMobileNumbers() async {
    QuerySnapshot usersSnapshot =
    await FirebaseFirestore.instance.collection('users').get();
    for (var value in usersSnapshot.docs) {
    String mobileNumber = value.get('phone');
    mobileNumbers.add(mobileNumber);
    }
    return mobileNumbers;
  }
}