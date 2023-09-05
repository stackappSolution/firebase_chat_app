import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/new_message_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/new_message_page/new_message_view_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/service/auth_service.dart';

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
        newMessageViewModel!.getContactPermission();
        newMessageViewModel!.getAllContacts();
        getNumbers();
        onSearchContacts();
      },
      builder: (NewMessageController controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: buildAppBar(context),
          body: buildSearchBar(context),
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

  buildSearchBar(BuildContext context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20.px),
              child: SizedBox(
                height: 50.px,
                child:AppTextFormField(
                  onChanged: (value) {
                    newMessageViewModel!.textController.text;
                    filterContacts();
                    newMessageViewModel!.newMessageController!.isSearch(true);
                    newMessageViewModel!.newMessageController!.setFilterText(value);
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
                )
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
            buildContactList(),
          ],
        ),
      );

  buildContactList() {
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
              onSearchContacts();
              goToChatingScreen();
              newMessageViewModel!.newMessageController!.update();
            },
            child: ListTile(
              onTap: () {
                (newMessageViewModel!.mobileNumbers.contains(mobileNumber))
                    ? Get.toNamed(RouteHelper.getChattingScreen(), arguments: {
                        'members': [
                          AuthService.auth.currentUser!.phoneNumber!,
                          mobileNumber
                        ],
                        'displayName': displayName,
                        'isGroup': false,
                      })
                    : Get.toNamed(RouteHelper.getInviteMemberScreen(),
                        parameters: {
                            'firstLetter': firstLetter,
                            'displayName': displayName,
                            'phoneNo': mobileNumber
                          });
                logs('mo--> $mobileNumber');
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
  onSearchContacts() {
    newMessageViewModel!.filterContacts =
        newMessageViewModel!.contacts.where((contact) {
          final lowerCaseQuery = newMessageViewModel!
              .newMessageController!.filteredValue
              .toLowerCase();
          return contact.displayName!.toLowerCase().contains(
              lowerCaseQuery) ||
              contact.phones!.any(
                      (phone) =>
                      phone.value!.toLowerCase().contains(
                          lowerCaseQuery));
        }).toList();
  }

  Future<void>filterContacts() async {
    final contacts = await newMessageViewModel!.getAllContacts();
    final searchTerm = newMessageViewModel!.textController.text.toLowerCase();

    if (contacts != null && searchTerm.isNotEmpty) {
      newMessageViewModel!.contacts = contacts.where((contact) {
        final displayName = contact.displayName?.toLowerCase() ?? '';
        final phones = contact.phones ?? [];
        bool nameMatch = displayName.contains(searchTerm);
        bool phoneMatch = phones.any((phone) =>
        phone.value?.toLowerCase().contains(searchTerm) ?? false);

        return nameMatch || phoneMatch;
      }).toList();
    } else {
      newMessageViewModel!.contacts = [];
    }
    newMessageViewModel!.newMessageController!.update();
  }
}