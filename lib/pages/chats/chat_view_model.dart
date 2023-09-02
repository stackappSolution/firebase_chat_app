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

class ChatViewModel {
  ChatScreen? chatScreen;
  List<Contact> contacts = [];
  List<Contact> filterContacts = [];
  bool isLoading = false;
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

  getUsersList() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.hasData) {
                data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Get.toNamed(RouteHelper.getChattingScreen(),
                            parameters: {
                              'phoneNo': data[index]['phone'],
                              'photoUrl': data[index]['photoUrl'],
                              'firstName': data[index]['firstName'],
                              'receiverId': data[index]['id'],
                            });
                      },
                      leading: CircleAvatar(
                          maxRadius: 40.px,
                          backgroundImage:
                              NetworkImage(data[index]['photoUrl'])),
                      title: AppText(
                        fontSize: 15.px,
                        '${data[index]['firstName']}',
                      ),
                      subtitle: AppText(
                        color: AppColorConstant.appGrey,
                        '${data[index]['phone']}',
                        fontSize: 10.px,
                      ),
                      trailing: AppText(
                          fontSize: 10.px,
                          S.of(Get.context!).yesterday,
                          color: AppColorConstant.appBlack),
                    );
                  },
                );
              }
              return const AppLoader();
            },
          ),
        ),
      ],
    );
  }
}
