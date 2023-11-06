import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/new_group_controller.dart';
import 'package:signal/pages/groups/view/new_group_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NewGroupViewModel {
  NewGroupScreen? newGroupScreen;
  GroupController? controller;
  List<Contact> items = [];
  List groupMembers = [];
  List selectedItemsIndex = [];
  List<bool> selectedItems = List.filled(2000, false);
  List userList = [];
  bool isLoading = true;
  bool isIcon = true;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isChecked = false;
  bool isRefreshing = false;
  final userTable = FirebaseFirestore.instance.collection('users');

  NewGroupViewModel(this.newGroupScreen) {}

  TextInputType getKeyboardType() {
    return isIcon ? TextInputType.text : TextInputType.number;
  }

  Future getUserPhoneList(GroupController controllers) async {
    if (userList.isEmpty) {
      final data = await userTable.where('phone').get();
      data.docs.forEach((element) {
        userList.add(element["phone"].toString().trim().removeAllWhitespace);
      });
      logs("getUserPhoneList=== $userList");
    }
    controllers.update();
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

  void inviteTap(number) {
    inviteFriends(number);
  }

  void inviteFriends(number) async {
    if (Platform.isAndroid) {
      String uri =
          'sms:${number}?body=${Uri.encodeComponent("Lets switch to signal: \n http://signal.org/install")}';
      await launchUrl(Uri.parse(uri));
    } else if (Platform.isIOS) {
      String uri =
          'sms:${number}&body=${Uri.encodeComponent("Lets switch to signal: \n http://signal.org/install")}';
      await launchUrl(Uri.parse(uri));
    }
  }
}
