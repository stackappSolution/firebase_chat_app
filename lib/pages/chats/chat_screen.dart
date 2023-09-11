import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/date_formation.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_view_model.dart';

import 'package:signal/routes/app_navigation.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_helper.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  ChatViewModel? chatViewModel;
  ContactController? contactController;

  @override
  Widget build(BuildContext context) {
    logs("Current Screen --> $runtimeType");
    chatViewModel ?? (chatViewModel = ChatViewModel(this));
    return GetBuilder<ContactController>(
      init: ContactController(),
      initState: (state) {
        DataBaseHelper.createDB();
        chatViewModel!.getPermission();
      },
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          appBar: getAppBar(context, controller),
          backgroundColor: Theme.of(context).colorScheme.background,
          floatingActionButton: buildFloatingButton(),
          body: getBody(controller),
        ));
      },
    );
  }

  getBody(ContactController controller) {
    return ListView(
      children: [buildContactList(controller)],
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
            onPressed: () {
              Get.toNamed(RouteHelper.getNewMessageScreen());
            },
          ),
        )
      ],
    );
  }

  getAppBar(BuildContext context, ContactController controller) {
    return controller.searchValue
        ? AppAppBar(
            leading: IconButton(
              icon: Icon(
                color: Theme.of(context).colorScheme.primary,
                Icons.arrow_back_outlined,
              ),
              onPressed: () {
                controller.setSearch(false);
              },
            ),
            title: SizedBox(
              height: 30,
              child: TextFormField(
                onChanged: (value) {
                  controller.setFilterText(value);
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
              child: InkWell(
                onTap: () {
                  goToSettingPage();
                },
                child: CircleAvatar(
                  backgroundColor: AppColorConstant.appYellow.withOpacity(0.2),
                  child: AppText('S',
                      fontSize: 20.px, color: AppColorConstant.appYellow),
                ),
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
                  controller.setSearch(true);
                  controller.setFilterText('');
                },
                child: Padding(
                    padding: EdgeInsets.all(18.px),
                    child: AppImageAsset(
                      image: AppAsset.search,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              ),
              buildPopupMenu(context),
            ],
          );
  }

  buildPopupMenu(BuildContext context) {
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
        child: AppImageAsset(
          image: AppAsset.popup,
          color: Theme.of(context).colorScheme.primary,
        ),
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

  buildContactList(ContactController controller) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller
          .getMyChatContactList(AuthService.auth.currentUser!.phoneNumber!),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return AppText('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoader();
        }
        final documents = snapshot.data!.docs;

        return ListView.builder(

          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            bool isGroup = documents[index]['isGroup'];
            List receiver = documents[index]["members"];
            receiver.remove(AuthService.auth.currentUser!.phoneNumber!);
            String receiverNumber =
                receiver.join("").toString().trim().removeAllWhitespace;
            String firstLetter = chatViewModel!
                .getNameFromContact(receiverNumber)
                .toString()
                .substring(0, 1);
            controller.getTimeStamp(documents[index]["id"]);

            return Container(
                margin: EdgeInsets.all(10.px),
                child: ListTile(
                  onTap: () {
                    Get.toNamed(RouteHelper.getChattingScreen(), arguments: {
                      'groupProfile': (documents[index]['isGroup'])
                          ? documents[index]['groupProfile']
                          : '',
                      'isGroup': (documents[index]['isGroup']) ? true : false,
                      'groupName': (documents[index]['isGroup'])
                          ? documents[index]['groupName']
                          : '',
                      'createdBy': (documents[index]['isGroup'])
                          ? documents[index]['createdBy']
                          : '',
                      'id': documents[index]['id'],
                      'members': documents[index]['members'],
                      'name': chatViewModel!.getNameFromContact(receiverNumber),
                      'number': receiverNumber,
                    });
                  },

                  trailing:  StreamBuilder(
                    stream: controller.getLastMessage(documents[index]['id']),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const AppText('');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const AppText('');
                      }
                      final data = snapshot.data!.docs;
                      return AppText(
                          DateFormation.formatTimestamp(data[0]["timeStamp"]),
                          color: AppColorConstant.grey,
                          fontSize: 12.px);
                    },
                  ),
                  leading: InkWell(
                    onTap: () {
                      Get.toNamed(RouteHelper.getChatProfileScreen());
                    },
                    child: CircleAvatar(
                      maxRadius: 30.px,
                      backgroundColor:
                          AppColorConstant.appYellow.withOpacity(0.8),
                      child: (isGroup)
                          ? AppText(
                              documents[index]['groupName']
                                      .substring(0, 1)
                                      .toUpperCase() ??
                                  "",
                              color: AppColorConstant.appWhite,
                              fontSize: 22.px,
                            )
                          : AppText(
                              firstLetter,
                              color: AppColorConstant.appWhite,
                              fontSize: 22.px,
                            ),
                    ),
                  ),
                  title: (isGroup)
                      ? AppText(
                          documents[index]['groupName'] ?? "",
                          fontSize: 15.px,
                          color: AppColorConstant.appWhite,
                        )
                      : AppText(
                          chatViewModel!.getNameFromContact(receiverNumber),
                          color: Theme.of(context).colorScheme.primary),
                  subtitle: StreamBuilder(
                    stream: controller.getLastMessage(documents[index]['id']),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const AppText('');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const AppText('');
                      }
                      final messageData = snapshot.data!.docs;
                      return (isGroup)
                          ? StreamBuilder(
                              stream: controller
                                  .getUserName(messageData[0]["sender"]),
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
                                return AppText(
                                    "${data[0]["firstName"]} | ${messageData[0]["message"]}",
                                    color: AppColorConstant.grey,
                                    fontSize: 12.px);
                              },
                            )
                          : AppText(messageData[0]["message"] ?? "",
                              color: AppColorConstant.grey, fontSize: 12.px);
                    },
                  ),
                ));
          },
        );
      },
    );
  }
}
