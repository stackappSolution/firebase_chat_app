import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/pages/chats/chat_screen.dart';
import 'package:signal/service/database_service.dart';


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
      await fetchContacts();
    } else {
      final PermissionStatus requestResult =
      await Permission.contacts.request();

      if (requestResult.isGranted) {
        await fetchContacts();
      } else {
        logs('Contacts permission denied');
      }
    }
  }

  Future<void> fetchContacts() async {
    isLoading = true;
    logs("$isLoading");
    controller!.update();
    contacts = await ContactsService.getContacts();
    logs("contacts --> ${contacts.length}");
    isLoading = false;
    logs("$isLoading");
    controller!.update();
  }



}