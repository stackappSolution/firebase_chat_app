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
  NewMessageController? controller;

  bool isLoading = false;
  bool isRefreshing = false;
  bool isIcon = true;
  bool isKeyBoard = true;
  TextEditingController textController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  ScrollController scrollController = ScrollController();
  int page = 1; // Current page
  bool isLoadingContact = false;

  bool isSearching = false;
  List<String> mobileNumbers = [];
  bool isThisUserExist = false;

  List<Map<String, dynamic>> filteredContactss = [];

  NewMessageViewModel(this.newMessagePage) {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        controller = Get.isRegistered<NewMessageController>()
            ? Get.find<NewMessageController>()
            : Get.put(NewMessageController());
      },
    );
  }

  void refreshTap() {
    logs("Refreshing");
    getContactPermission();
  }

  void toggleIcon(NewMessageController controller) {
    isIcon = !isIcon;
    textController.clear();
    controller!.update();
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
    isRefreshing = true;
    controller!.update();

    // Fetch contacts
    contacts = await ContactsService.getContacts(withThumbnails: false);

    // Update filteredContacts by checking if each contact already exists
    for (var contact in contacts) {
      if (!filteredContacts.contains(contact)) {
        filteredContacts.add(contact);
      }
    }

    isRefreshing = false;
    controller!.update();
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
    controller!.update();
  }
}
