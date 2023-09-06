import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/new_message_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/new_message_page/new_message_view_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/service/auth_service.dart';
import '../../service/database_helper.dart';

// ignore: must_be_immutable
class NewMessagePage extends StatelessWidget {
  NewMessagePage({super.key});

  NewMessageViewModel? newMessageViewModel;

  @override
  Widget build(BuildContext context) {
    newMessageViewModel ?? (newMessageViewModel = NewMessageViewModel(this));
    newMessageViewModel!.getContactPermission();
    return GetBuilder<NewMessageController>(
      init: NewMessageController(),
      initState: (state) {
        DataBaseHelper.createDB();
        newMessageViewModel!.getContactPermission();
        newMessageViewModel!.getAllContacts();
        getNumbers();
      },
      builder: (NewMessageController controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: buildAppBar(context),
          body: buildSearchBar(context, controller),
        ));
      },
    );
  }

  buildAppBar(BuildContext context) => AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: AppText(
          S.of(context).newMessage,
          fontSize: 20.px,
          color: Theme.of(context).colorScheme.primary,
        ),
      );

  buildSearchBar(BuildContext context, NewMessageController controller) =>
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20.px),
              child: SizedBox(
                height: 50.px,
                child: AppTextFormField(
                  onChanged: (value) {
                    newMessageViewModel!.textController.text = value;
                    onSearchContacts(filterContacts());
                    newMessageViewModel!.newMessageController!.isSearch(true);
                    newMessageViewModel!.newMessageController!
                        .setFilterText('');
                  },
                  controller: newMessageViewModel!.textController,
                  suffixIcon: InkWell(
                    onTap: () {
                      newMessageViewModel!.toggleIcon();
                      newMessageViewModel!.newMessageController!.update();
                    },
                    child: (newMessageViewModel!.isIcon)
                        ? const Icon(Icons.dialpad)
                        : const Icon(Icons.keyboard),
                  ),
                  keyboardType: newMessageViewModel!.getKeyboardType(),
                  hintText: S.of(context).search,
                  style: TextStyle(
                    fontSize: 22.px,
                    fontWeight: FontWeight.w400,
                  ),
                  fontSize: 20.px,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.px),
              child: ListTile(
                  onTap: () {
                    Get.toNamed(RouteHelper.getNewGroupScreen());
                  },
                  title: AppText(
                    S.of(context).newGroup,
                    fontSize: 18.px,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  leading: CircleAvatar(
                    radius: 30.px,
                    backgroundColor:
                        AppColorConstant.appYellow.withOpacity(0.5),
                    child: const Icon(Icons.group,
                        color: AppColorConstant.appBlack),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(20.px),
              child: AppText(
                S.of(context).contacts,
                fontSize: 22.px,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            buildContactList(context, controller),
          ],
        ),
      );

  buildContactList(BuildContext context, NewMessageController controller) {
    if (newMessageViewModel!.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColorConstant.appYellow,
        ),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: newMessageViewModel!.isSerching == true
          ? newMessageViewModel!.contacts.length
          : newMessageViewModel!.contacts.length,
      itemBuilder: (context, index) {
        final Contact contact = newMessageViewModel!.contacts[index];
        String? mobileNumber =
            contact.phones!.isNotEmpty ? contact.phones!.first.value : 'N/A';
        String? displayName = contact.displayName ?? 'unknown';
        String firstLetter = displayName.substring(0, 1).toUpperCase();
        return Container(
          margin: EdgeInsets.only(top: 5.px),
          child: InkWell(
            onTap: () {
              goToChatingScreen();
            },
            child: ListTile(
              onTap: () async {
                newMessageViewModel!.isThisUserExist =
                    await controller.doesUserExist(
                        mobileNumber.toString().trim().removeAllWhitespace);
                if (newMessageViewModel!.isThisUserExist &&
                    mobileNumber.toString().trim().removeAllWhitespace !=
                        AuthService.auth.currentUser!.phoneNumber) {
                  Get.toNamed(RouteHelper.getChattingScreen(), arguments: {
                    'members': [
                      AuthService.auth.currentUser!.phoneNumber!,
                      mobileNumber.toString().removeAllWhitespace.trim()
                    ],
                    'name': displayName,
                    'number':
                        mobileNumber.toString().trim().removeAllWhitespace,
                    'isGroup': false,
                  });
                } else {
                  Get.toNamed(RouteHelper.getInviteMemberScreen(), parameters: {
                    'firstLetter': firstLetter,
                    'displayName': displayName,
                    'phoneNo': mobileNumber
                  });
                }
              },
              leading: InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getChatProfileScreen());
                },
                child: CircleAvatar(
                    maxRadius: 30.px,
                    backgroundColor:
                        AppColorConstant.appYellow.withOpacity(0.8),
                    child: AppText(
                      firstLetter,
                      color: AppColorConstant.appWhite,
                      fontSize: 22.px,
                    )),
              ),
              title: AppText(
                displayName,
                fontSize: 15.px,
                color: Theme.of(context).colorScheme.primary,
              ),
              subtitle: AppText(mobileNumber!,
                  color: AppColorConstant.grey, fontSize: 12.px),
            ),
          ),
        );
      },
    );
  }

  getNumbers() async {
    newMessageViewModel!.mobileNumbers =
        await newMessageViewModel!.getMobileNumbers();
    logs('phones----> ${newMessageViewModel!.mobileNumbers}');
  }

  // onSearchContacts(bool searching) {
  //   newMessageViewModel!.isSerching = searching;
  //   if (searching) {
  //     newMessageViewModel!.filterContacts =
  //         newMessageViewModel!.contacts.where((contact) {
  //       final displayName = contact.displayName?.toLowerCase() ?? '';
  //       final phones = contact.phones ?? [];
  //
  //       return displayName.contains(
  //               newMessageViewModel!.textController.text.toLowerCase()) ||
  //           phones.any((phone) =>
  //               phone.value?.toLowerCase().contains(
  //                   newMessageViewModel!.textController.text.toLowerCase()) ??
  //               false);
  //     }).toList();
  //   } else {
  //     newMessageViewModel!.filterContacts = newMessageViewModel!.contacts;
  //   }
  //   newMessageViewModel!.newMessageController!.update();
  // }

  filterContacts() {
    newMessageViewModel!.getAllContacts().addAll(newMessageViewModel!.contacts);
    if (newMessageViewModel!.textController.text.isNotEmpty) {
      newMessageViewModel!.contacts.retainWhere((contact) {
        String serchterm =
            newMessageViewModel!.textController.text.toLowerCase();
        String contactName = contact.displayName!.toLowerCase();
        return contactName.contains(serchterm);
      });
      newMessageViewModel!.contacts = newMessageViewModel!.filterContacts;
      newMessageViewModel!.newMessageController!.update();
    }
  }

  // Future<void> filterContacts() async {
  //   List<Contact> contacts = await newMessageViewModel!.getAllContacts();
  //   contacts.addAll(contacts); // Use the actual contacts data, not the Future
  //   if (newMessageViewModel!.textController.text.isNotEmpty) {
  //     contacts.retainWhere((contact) {
  //       String searchterm = newMessageViewModel!.textController.text.toLowerCase();
  //       String contactName = contact.displayName!.toLowerCase();
  //       return contactName.contains(searchterm);
  //     });
  //     newMessageViewModel!.contacts = contacts; // Update the filtered contacts
  //     newMessageViewModel!.newMessageController!.update();
  //   }
  // }
  onSearchContacts(NewMessageController controller) {
    if (controller.searchValue) {
      newMessageViewModel!.filterContacts =
          newMessageViewModel!.contacts.where((contact) {
        return contact.displayName
            .toString()
            .toLowerCase()
            .contains(controller.filteredValue.toLowerCase());
      }).toList();
    } else {
      newMessageViewModel!.filterContacts = newMessageViewModel!.contacts;
    }
  }
}
