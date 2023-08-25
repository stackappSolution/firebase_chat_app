import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_view_model.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/routes/routes_helper.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  ChatViewModel? chatViewModel;



  @override
  Widget build(BuildContext context) {
    logs("Current Screen --> $runtimeType");
    chatViewModel ?? (chatViewModel = ChatViewModel(this));
    chatViewModel!.getPermission();
    return GetBuilder<ContactController>(
      init: ContactController(),
      initState: (state) {
      },
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          appBar: getAppBar(context),
          backgroundColor: AppColorConstant.appWhite,
          floatingActionButton: buildFloatingButton(),
          body: getBody(),
        ));
      },
    );
  }

  getBody() {
    return ListView(
      children: [
        buildContactList(),
      ],
    );
  }

  buildFloatingButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(
            heroTag: 'camera',
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.px)),
            backgroundColor: AppColorConstant.appYellow,
            child: AppImageAsset(
                image: AppAsset.camera, height: 25.px, width: 25.px),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(
            heroTag: "chats",
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.px)),
            backgroundColor: AppColorConstant.appYellow,
            child: AppImageAsset(
                image: AppAsset.edit, height: 25.px, width: 25.px),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  getAppBar(BuildContext context) {
    return chatViewModel!.controller!.searchValue
        ? AppAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined,
              ),
              onPressed: () {
                chatViewModel!.controller!.setSearch(false);
              },
            ),
            title: SizedBox(height: 30,
              child: TextFormField(
                onChanged: (value) {
                  chatViewModel!.controller!.setFilterText(value);
                },
                decoration: InputDecoration(
                    hintText: 'Search',
                    fillColor: AppColorConstant.grey.withOpacity(0.2),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.px),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(18.px),
                    )),
              ),
            ),
          )
        : AppAppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: Padding(
              padding: EdgeInsets.only(left: 15.px),
              child: CircleAvatar(
                backgroundColor: AppColorConstant.appYellow.withOpacity(0.2),
                child: AppText('S',
                    fontSize: 20.px, color: AppColorConstant.appYellow),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(left: 20.px),
              child: AppText(S.of(Get.context!).signal,
                  color: Theme.of(Get.context!).colorScheme.primary,
                  fontSize: 20.px),
            ),
            actions: [
              InkWell(
                onTap: () {

                  chatViewModel!.controller!.setSearch(true);
                  chatViewModel!.controller!.setFilterText('');


                },
                child: Padding(
                    padding: EdgeInsets.all(18.px),
                    child: const AppImageAsset(image: AppAsset.search)),
              ),
              buildPopupMenu(),
            ],
          );
  }

  buildContactList() {
    onSearchContacts();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: chatViewModel!.filterContacts.length,
      itemBuilder: (context, index) {
        Contact contact = chatViewModel!.filterContacts[index];

        String? mobileNumber =
            contact.phones!.isNotEmpty ? contact.phones!.first.value : 'N/A';
        String? displayName = contact.displayName ?? 'unknown';
        String firstLetter = displayName.substring(0, 1).toUpperCase();

        return Container(
            margin: EdgeInsets.all(10.px),
            child: ListTile(
              onTap: () {
                Get.toNamed(RouteHelper.getChattingScreen(),
                    parameters: {'phoneNo': mobileNumber});
              },
              trailing: AppText(
                  fontSize: 10.px,
                  S.of(Get.context!).yesterday,
                  color: AppColorConstant.appBlack),
              leading: InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getChatProfileScreen());
                },
                child: CircleAvatar(
                  maxRadius: 30.px,
                  backgroundColor: AppColorConstant.appYellow.withOpacity(0.8),
                  child: AppText(
                    firstLetter,
                    color: AppColorConstant.appWhite,
                    fontSize: 22.px,
                  ),
                ),
              ),
              title: AppText(
                displayName,
                fontSize: 15.px,
              ),
              subtitle: AppText(mobileNumber!,
                  color: AppColorConstant.grey, fontSize: 12.px),
            ));
      },
    );
  }

  buildPopupMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 2) {
          goToSettingPage();
        }
      },
      elevation: 0.5,
      position: PopupMenuPosition.under,
      color: AppColorConstant.appLightGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.px)),
      icon: Padding(
        padding: EdgeInsets.all(10.px),
        child: const AppImageAsset(image: AppAsset.popup),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 0,
            child: AppText(S.of(Get.context!).newGroup),
          ),
          PopupMenuItem(
              value: 1, child: AppText(S.of(Get.context!).markAllRead)),
          PopupMenuItem(value: 2, child: AppText(S.of(Get.context!).settings)),
          PopupMenuItem(
              value: 3, child: AppText(S.of(Get.context!).inviteFriends)),
        ];
      },
    );
  }

  onSearchContacts() {
    if (chatViewModel!.controller!.searchValue) {
      chatViewModel!.filterContacts = chatViewModel!.contacts.where((contact) {
        return contact.displayName
            .toString()
            .toLowerCase()
            .contains(chatViewModel!.controller!.filteredValue.toLowerCase());
      }).toList();
    } else {
      chatViewModel!.filterContacts = chatViewModel!.contacts;


    }
  }



}
