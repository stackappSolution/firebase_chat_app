import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/pages/chats/chat_screen.dart';

class ChatViewModel {
  ChatScreen? chatScreen;
  List<Contact> contacts = [];
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
    contacts = await ContactsService.getContacts();
    controller!.update();
    logs("contacts --> ${contacts.length}");
  }
}
