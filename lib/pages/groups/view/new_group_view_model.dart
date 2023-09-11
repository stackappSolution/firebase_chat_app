import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/new_group_controller.dart';
import 'package:signal/pages/groups/view/new_group_screen.dart';

class NewGroupViewModel {
  NewGroupScreen? newGroupScreen;
  GroupController? controller;
  List<Contact> items = [];
  List<bool> selectedItems = [];
  List<Contact> contacts = [];
  List groupMembers = [];
  List<Contact> filteredContacts = [];
  bool isLoading = true;
  bool isIcon = true;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;


  NewGroupViewModel(this.newGroupScreen) {
    Future.delayed(
      const Duration(milliseconds: 0),
      () {
        controller = Get.find<GroupController>();
      },
    );
  }

  TextInputType getKeyboardType() {
    return isIcon ? TextInputType.text : TextInputType.number;
  }
  void fetchContacts() async {
    logs("fetch contact entered");
    contacts = await ContactsService.getContacts(withThumbnails: false);
    filteredContacts = List.from(contacts);
    isLoading = false;
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
        final mobileNumber = contact.phones!.isNotEmpty
            ? contact.phones!.first.value
            : 'N/A';
        return displayName.toLowerCase().contains(query.toLowerCase()) ||
            mobileNumber!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    controller!.update();
  }


}
