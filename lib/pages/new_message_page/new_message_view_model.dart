import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/new_message_controller.dart';
import 'package:signal/pages/new_message_page/new_message_page.dart';
import 'package:signal/service/database_helper.dart';

class NewMessageViewModel {
  NewMessagePage? newMessagePage;
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  bool isLoading = false;
  NewMessageController? newMessageController;
  bool isIcon = true;
  bool isKeyBoard = true;
  TextEditingController textController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  List<String> mobileNumbers = [];
  bool isThisUserExist = false;

  List<Map<String, dynamic>> filteredContactss = [];

  NewMessageViewModel(this.newMessagePage) {
    Future.delayed(
      const Duration(milliseconds: 0),
      () {
        newMessageController = Get.find<NewMessageController>();
        fetchContacts();
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
    if (await Permission.contacts.isGranted && contacts.isEmpty) {
      fetchContacts();
    } else {
      await Permission.contacts.request();
    }
  }

  void fetchContacts() async {
    if (contacts.isEmpty) {
      logs("fetch contact entered");
      isLoading = true;
      newMessageController!.update();
      contacts = await ContactsService.getContacts(withThumbnails: false);
      filteredContacts = List.from(contacts);
      isLoading = false;
      newMessageController!.update();
    }
  }

  getAllContacts() async {
    List<Contact> contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    logs("contacts length-->${contacts.length}");
  }

  void filterContacts(String query) {
    if (query.isEmpty) {
      isSearching = false;
      filteredContacts = List.from(contacts);
    } else {
      isSearching = true;
      filteredContacts = contacts.where((contact) {
        final displayName = contact.displayName ?? 'unknown';
        final mobileNumber =
            contact.phones!.isNotEmpty ? contact.phones!.first.value : 'N/A';
        return displayName.toLowerCase().contains(query.toLowerCase()) ||
            mobileNumber!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    newMessageController!.update();
  }
}
