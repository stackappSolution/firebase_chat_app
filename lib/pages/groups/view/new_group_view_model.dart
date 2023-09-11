import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
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


  NewGroupViewModel(this.newGroupScreen) {
    Future.delayed(
      const Duration(milliseconds: 0),
      () {
        controller = Get.find<GroupController>();
      },
    );
  }

  Future<void> fetchContacts() async {
    contacts = await ContactsService.getContacts();
    controller!.update();
    logs("contacts --> ${contacts.length}");
  }


}
