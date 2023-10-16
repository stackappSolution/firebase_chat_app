import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/new_message_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/new_message_page/new_message_view_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/service/auth_service.dart';

import '../../app/app/utills/app_utills.dart';
import '../../app/app/utills/theme_util.dart';
import '../../app/widget/app_image_assets.dart';
import '../../app/widget/app_shimmer.dart';
import '../../service/database_helper.dart';
import '../../service/network_connectivity.dart';

class NewMessagePage extends StatelessWidget {
  NewMessagePage({super.key});

  NewMessageViewModel? newMessageViewModel;

  @override
  Widget build(BuildContext context) {
    newMessageViewModel ?? (newMessageViewModel = NewMessageViewModel(this));
    return GetBuilder<NewMessageController>(
      init: NewMessageController(),
      initState: (state) {},
      builder: (NewMessageController controller) {
       controller.getUserPhoneList();
        return SafeArea(
          child: Builder(builder: (context) {
            MediaQueryData mediaQuery = MediaQuery.of(context);
            ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: buildAppBar(context),
              body: buildSearchBar(context, controller),
            );
          }),
        );
      },
    );
  }

  buildAppBar(BuildContext context) => AppAppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: AppText(
          S.of(context).newMessage,
          fontSize: 20.px,
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          InkWell(
            onTap: newMessageViewModel!.refreshTap,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 22.px, horizontal: 15),
              child: const Icon(Icons.refresh_outlined),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      );

  buildSearchBar(BuildContext context, NewMessageController controller) =>
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.px),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 50.px,
                child: AppTextFormField(
                  onChanged: (value) {
                    newMessageViewModel!.searchController.text;
                    newMessageViewModel!.filterContacts(value);
                  },
                  suffixIcon: InkWell(
                    onTap: () {
                      newMessageViewModel!.toggleIcon(controller);
                      newMessageViewModel!.controller!.update();
                    },
                    child: (newMessageViewModel!.isIcon)
                        ? const Icon(Icons.dialpad)
                        : const Icon(Icons.keyboard),
                  ),
                  controller: newMessageViewModel!.searchController,
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
            SizedBox(
              height: 15.px,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.px),
              child: ListTile(
                  onTap: () {
                    goToNewGroupScreen();
                  },
                  title: AppText(
                    S.of(context).newGroup,
                    fontSize: 16.px,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  leading: CircleAvatar(
                    radius: 20.px,
                    backgroundColor:
                        AppColorConstant.appYellow.withOpacity(0.5),
                    child: Icon(Icons.group,
                        color: AppColorConstant.appBlack, size: 17.px),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(20.px),
              child: AppText(
                S.of(context).contacts,
                fontSize: 14.px,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            buildContactList(context, controller),
          ],
        ),
      );

  buildContactList(BuildContext context, NewMessageController controller) {
    return Stack(
      children: [
        ListView.builder(
          controller: newMessageViewModel!.scrollController,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: newMessageViewModel!.isSearching == true
              ? filteredContacts.length
              : contacts.length,
          itemBuilder: (context, index) {
            final Contact contact = newMessageViewModel!.isSearching
                ? filteredContacts[index]
                : contacts[index];
            String? mobileNumber = contact.phones!.isNotEmpty
                ? contact.phones!.first.value
                : 'N/A';
            String? displayName = contact.displayName ?? 'unknown';
            String firstLetter =
                displayName.substring(0, 1).toUpperCase();

              return Container(
                margin: EdgeInsets.only(top: 5.px),
                child: InkWell(
                  onTap: () {
                    newMessageViewModel!.isLoading = true;
                    controller.update();
                    goToChatingScreen();
                    controller.update();
                  },
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          newMessageViewModel!.isThisUserExist =
                              await controller.doesUserExist(mobileNumber
                                  .toString()
                                  .trim()
                                  .removeAllWhitespace);
                          if (newMessageViewModel!.isThisUserExist &&
                              mobileNumber
                                      .toString()
                                      .trim()
                                      .removeAllWhitespace !=
                                  AuthService.auth.currentUser!.phoneNumber) {
                            Get.toNamed(RouteHelper.getChattingScreen(),
                                arguments: {
                                  'members': [
                                    AuthService.auth.currentUser!.phoneNumber!,
                                    mobileNumber
                                        .toString()
                                        .removeAllWhitespace
                                        .trim()
                                  ],
                                  'name': displayName,
                                  'number': mobileNumber
                                      .toString()
                                      .trim()
                                      .removeAllWhitespace,
                                  'isGroup': false,
                                });
                          } else {
                            Get.toNamed(RouteHelper.getInviteMemberScreen(),
                                parameters: {
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
                            child: StreamBuilder(
                              stream: controller.getProfile(mobileNumber
                                  .toString()
                                  .trim()
                                  .removeAllWhitespace),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const AppText('');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const AppText('');
                                }
                                final data = snapshot.data!.docs;
                                return (controller.userList.contains(
                                            mobileNumber
                                                .toString()
                                                .trim()
                                                .removeAllWhitespace) &&
                                        data.first["photoUrl"]
                                            .toString()
                                            .contains("https://"))
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(700),
                                        child: AppImageAsset(
                                          image: data[0]["photoUrl"],
                                          fit: BoxFit.cover,
                                          height: 40.px,
                                          width: 40.px,
                                        ))
                                    : CircleAvatar(
                                        maxRadius: 20.px,
                                        backgroundColor: AppColorConstant
                                            .appYellow
                                            .withOpacity(0.8),
                                        child: AppText(
                                          firstLetter,
                                          color: AppColorConstant.appWhite,
                                          fontSize: 20.px,
                                        ));
                              },
                            )),
                        title: AppText(
                          displayName,
                          fontSize: 15.px,
                          color: Theme.of(context).colorScheme.primary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: AppText(mobileNumber!,
                            color: AppColorConstant.grey, fontSize: 12.px),
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
        if (newMessageViewModel!.isLoading)
          ListView(
            children: const [
              AppShimmerView(),
              AppShimmerView(),
              AppShimmerView(),
            ],
          )
      ],
    );
  }
}
