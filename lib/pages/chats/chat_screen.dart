import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/date_formation.dart';
import 'package:signal/app/app/utills/theme_util.dart';
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
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_helper.dart';

import '../../app/widget/app_shimmer.dart';
import '../../modal/message.dart';
import '../../service/network_connectivity.dart';
import '../../service/users_service.dart';
import '../notifications/notifications.dart';

class ChatScreen extends StatelessWidget {
  bool sent;
  var  msgList;

  ChatScreen( {this.msgList,this.sent = false,super.key});

  ChatViewModel? chatViewModel;
  ContactController? controller;

  @override
  Widget build(BuildContext context) {
    logs("Current Screen --> $runtimeType");
    chatViewModel ?? (chatViewModel = ChatViewModel(this));
    return GetBuilder<ContactController>(
      init: ContactController(),
      initState: (state) {
        var brightness =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;
        ThemeUtil.isDark = brightness == Brightness.dark;
        logs("ThemeUtil.isDark--- > ${ThemeUtil.isDark}");
        DataBaseHelper.createDB();
        Future.delayed(
          const Duration(milliseconds: 0),
          () async {
            controller = Get.find<ContactController>();
            await UsersService.getUserStream();
            //chatViewModel!.getPermission(controller!);

            controller!.update();
          },
        );
      },
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            return await chatViewModel!.willPopDialog(context);
          },
          child: SafeArea(
            child:  Builder(builder: (context) {
              MediaQueryData mediaQuery = MediaQuery.of(context);
              ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
              return Scaffold(
              appBar: getAppBar(context, controller),
              backgroundColor: Theme.of(context).colorScheme.background,
              floatingActionButton: buildFloatingButton(),
              body: getBody(controller),
            );}),
          ),
        );
      },
    );
  }

  getBody(ContactController controller) {
    return ListView(
      children: [buildContactList(controller)],
    );
  }

  buildFloatingButton() {
    return sent
        ? FloatingActionButton(
            heroTag: 'camera',
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.px)),
            backgroundColor: AppColorConstant.appYellow,
            child:
                Icon(Icons.send, size: 25.px, color: AppColorConstant.appWhite),
            onPressed: () {
              List sampleList = Set.of(chatViewModel!.selectedContacts).toList();
              List Final = sampleList;
              for (int j = 0; j < sampleList.length; j++) {
                List receiver = sampleList[j]["members"];
                String phoneNumberToRemove = AuthService.auth.currentUser!.phoneNumber!;

                if (receiver.contains(phoneNumberToRemove)) {
                  receiver.remove(phoneNumberToRemove);
                }

                String receiverNumber = receiver.join("").toString().trim();
                chatViewModel!.getToken(receiverNumber);
                for (int i = 0; i < msgList.length - 1; i++) {

                  logs("msgList length -- > ");

                  var messageModel = msgList[i] as MessageModel;
                  warningLogs('messageModel.message --> ${messageModel}');
                  warningLogs('messageModel.message --> ${messageModel.message}');
                  chatViewModel!.addChatMessage(messageModel, sampleList[j]['id']);

                  Future.delayed(const Duration(microseconds: 1), () {
                    (messageModel.messageType == 'text')
                        ? chatViewModel!
                            .notification(messageModel.message.toString())
                        : (messageModel.messageType == 'image')
                            ? chatViewModel!.notification('📷 photo')
                            : (messageModel.messageType == 'audio')
                                ? chatViewModel!.notification('🎶 audio')
                                : (messageModel.messageType == 'doc')
                                    ? chatViewModel!.notification('📃 document')
                                    : chatViewModel!.notification('🎥 video');
                  });
                }
                chatViewModel!.token = "";
                controller!.update();
              }
              // List receiver = Final.last["members"];
              // receiver.remove(AuthService.auth.currentUser!.phoneNumber!);
              // String receiverNumber =
              //     receiver.join("").toString().trim().removeAllWhitespace;
              // Get.toNamed(RouteHelper.getChattingScreen(), arguments: {
              //   'groupProfile':
              //       (Final.last['isGroup']) ? Final.last['groupProfile'] : '',
              //   'isGroup': (Final.last['isGroup']) ? true : false,
              //   'groupName':
              //       (Final.last['isGroup']) ? Final.last['groupName'] : '',
              //   'createdBy':
              //       (Final.last['isGroup']) ? Final.last['createdBy'] : '',
              //   'id': Final.last['id'],
              //   'members': Final.last['members'],
              //   'name': chatViewModel!.getNameFromContact(receiverNumber),
              //   'number': receiverNumber,
              //   'sent': sent,
              //   'msgList': msgList
              // });
            },
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(
            heroTag: 'camera',
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.px)),
            backgroundColor: AppColorConstant.appYellow,
            child: AppImageAsset(
                image: AppAsset.camera, height: 22.px, width: 22.px),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(
            heroTag: "chats",
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.px)),
            backgroundColor: AppColorConstant.appYellow,
            child: AppImageAsset(
                image: AppAsset.edit, height: 19.px, width: 19.px),
            onPressed: () {
              Get.toNamed(RouteHelper.getNewMessageScreen());
            },
          ),
        ),
      ],
    );
  }

  getAppBar(BuildContext context, ContactController controller) {
    if (controller.searchValue) {
      return AppAppBar(
        leading: IconButton(
          icon: Icon(
            color: Theme.of(context).colorScheme.onSecondary,
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
      );
    } else {
      return AppAppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: sent
            ? IconButton(
                icon: Icon(
                  color: Theme.of(context).colorScheme.onSecondary,
                  Icons.arrow_back_outlined,
                ),
                onPressed: () {
                  Get.back();
                },
              )
            : Padding(
                padding: EdgeInsets.only(left: 15.px),
                child: InkWell(
                  onTap: () {
                    goToSettingPage();
                  },
                  child: StreamBuilder(
                    stream: UsersService.getUserStream(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const AppText('');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const AppText('');
                      }
                      final data = snapshot.data!.docs;
                      return Padding(
                        padding: EdgeInsets.only(left: 11.px, top: 3.px, bottom: 3.px),
                  child: data.first['photoUrl'].isEmpty
                      ? CircleAvatar(
                          maxRadius: 35.px,
                          backgroundColor:
                              AppColorConstant.appYellow.withOpacity(0.8),

                          child: AppText(
                            data.first['firstName']
                                .substring(0, 1)
                                .toString()
                                .toUpperCase(),
                            fontSize: 18.px,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        )
                      : CircleAvatar(
                          maxRadius: 35.px,
                          backgroundImage: NetworkImage(data.first['photoUrl']),
                        ),
                );
              },
            ),
          ),
        ),
        title: Padding(
          padding: sent ? EdgeInsets.only(left: 0.px) : EdgeInsets.only(left: 5.px),
          child: sent
              ? AppText('Select contect',
                  color: Theme.of(Get.context!).colorScheme.primary,
                  fontSize: 18.px)
              : AppText(S.of(Get.context!).chatapp,
                  color: Theme.of(Get.context!).colorScheme.primary,
                  fontSize: 18.px),
        ),
        actions: [
          InkWell(
            onTap: () {
              controller.setSearch(true);
              controller.setFilterText('');
            },
            child: Padding(
                padding:
                    EdgeInsets.only(right: 13.px, top: 18.px, bottom: 18.px),
                child: AppImageAsset(
                  image: AppAsset.search,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ),
          sent
              ? Padding(
                  padding: EdgeInsets.only(left: 7.px),
                  child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      child:
                          AppText('${chatViewModel!.selectedContacts.length}')),
                )
              : buildPopupMenu(context),
        ],
      );
    }
  }

  buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0) {
          goToNewGroupScreen();
        }
        if (value == 2) {
          goToSettingPage();
        }
        if (value == 3) {
          UsersService.instance.getAllNotifications();
          Get.to(NotificationsScreen());
        }
      },
      elevation: 0.5,
      position: PopupMenuPosition.under,
      color: (ThemeUtil.isDark)
          ? AppColorConstant.blackOff
          : AppColorConstant.appWhite,
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
            child: AppText(S.of(Get.context!).newGroup,
                color: Theme.of(context).colorScheme.primary),
          ),
          PopupMenuItem(
              onTap: () async {
                chatViewModel!.markMessagesAsSeenChatPage();
              },
              value: 1,
              child: AppText(S.of(Get.context!).markAllRead,
                  color: Theme.of(context).colorScheme.primary)),
          PopupMenuItem(
              value: 2,
              child: AppText(S.of(Get.context!).settings,
                  color: Theme.of(context).colorScheme.primary)),
          PopupMenuItem(
              value: 3,
              child: AppText(S.of(Get.context!).notification,
                  color: Theme.of(context).colorScheme.primary)),
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
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (contexti, index) {
              return const AppShimmerView();
            },
          );
        }
        final documents = snapshot.data!.docs;
        return (documents.length != 0)
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  bool isGroup = documents[index]['isGroup'];
                  logs("is Group  -- ${snapshot.data!.docs.length}");
                  List receiver = documents[index]["members"];
                  receiver.remove(AuthService.auth.currentUser!.phoneNumber!);
                  String receiverNumber =
                      receiver.join("").toString().trim().removeAllWhitespace;
                  String firstLetter = chatViewModel!
                      .getNameFromContact(receiverNumber)
                      .toString()
                      .substring(0, 1);

                  return Container(
                      color: chatViewModel!.selectedContactsTrueFalse[index]
                          ? AppColorConstant.yellowLight
                          : Colors.transparent,
                      child: ListTile(
                        onTap: () {
                       !sent ? Get.toNamed(RouteHelper.getChattingScreen(),
                              arguments: {
                                'groupProfile': (documents[index]['isGroup'])
                                    ? documents[index]['groupProfile']
                                    : '',
                                'isGroup': (documents[index]['isGroup'])
                                    ? true
                                    : false,
                                'groupName': (documents[index]['isGroup'])
                                    ? documents[index]['groupName']
                                    : '',
                                'createdBy': (documents[index]['isGroup'])
                                    ? documents[index]['createdBy']
                                    : '',
                                'id': documents[index]['id'],
                                'members': documents[index]['members'],
                                'name': chatViewModel!
                                    .getNameFromContact(receiverNumber),
                                'number': receiverNumber,
                                'sent' : sent,
                                'msgList' : msgList
                              })
                              : chatViewModel!.addRemove(index,documents[index]);
                        },
                        trailing: StreamBuilder(
                          stream:
                              controller.getLastMessage(documents[index]['id']),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const AppText('');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const AppText('');
                            }
                            final data = snapshot.data!.docs;
                            return AppText(
                                DateFormation.formatTimestamp(
                                    data.first["messageTimestamp"]),
                                color: AppColorConstant.grey,
                                fontSize: 12.px);
                          },
                        ),
                        leading: InkWell(
                            onTap: () {},
                            child: (isGroup)
                                ? StreamBuilder(
                                    stream: controller
                                        .getGroupName(documents[index]['id']),
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
                                      logs(
                                          "g name -- ${data.first["groupName"]}");
                                      return (data.first["groupProfile"]
                                              .toString()
                                              .isNotEmpty)
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(700),
                                              child: AppImageAsset(
                                                image:
                                                    data.first["groupProfile"],
                                                fit: BoxFit.cover,
                                                height: 48.px,
                                                width: 48.px,
                                              ))
                                          : CircleAvatar(
                                              maxRadius: 22.px,
                                              backgroundColor: AppColorConstant
                                                  .appYellow
                                                  .withOpacity(0.8),
                                              child: (data.first["groupProfile"]
                                                      .toString()
                                                      .isNotEmpty)
                                                  ? AppText(
                                                      data.first["groupName"]
                                                          .toString()
                                                          .substring(0, 1),
                                                      color: AppColorConstant
                                                          .appWhite,
                                                      fontSize: 24.px,
                                                    )
                                                  : AppText(
                                                      "G",
                                                      color: AppColorConstant
                                                          .appWhite,
                                                      fontSize: 24.px,
                                                    ),
                                            );
                                    },
                                  )
                                : StreamBuilder(
                                    stream:
                                        controller.getUserName(receiverNumber),
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
                                      return (data.first["photoUrl"]
                                              .toString()
                                              .contains("https://"))
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(700),
                                              child: AppImageAsset(
                                                image: data.first["photoUrl"],
                                                fit: BoxFit.cover,
                                                height: 48.px,
                                                width: 48.px,
                                              ))
                                          : CircleAvatar(
                                              maxRadius: 24.px,
                                              backgroundColor: AppColorConstant
                                                  .appYellow
                                                  .withOpacity(0.8),
                                              child: AppText(
                                                firstLetter,
                                                color:
                                                    AppColorConstant.appWhite,
                                                fontSize: 22.px,
                                              ),
                                            );
                                    },
                                  )),
                        title: (isGroup)
                            ? StreamBuilder(
                                stream: controller
                                    .getGroupName(documents[index]['id']),
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
                                  logs(
                                      "name---> ${data.first['groupName'].toString()}");
                                  return AppText(data.first['groupName'],
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary);
                                },
                              )
                            : AppText(
                                chatViewModel!
                                    .getNameFromContact(receiverNumber),
                                color: Theme.of(context).colorScheme.primary),
                        subtitle: StreamBuilder(
                          stream:
                              controller.getLastMessage(documents[index]['id']),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const AppText('');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const AppText('');
                            }
                            final messageData = snapshot.data!.docs;
                            return (isGroup)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 30.px,
                                        child: StreamBuilder(
                                          stream: controller.getUserName(
                                              messageData.first["sender"]),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return const AppText('');
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const AppText('');
                                            }
                                            final data = snapshot.data!.docs;
                                            return AppText(
                                              "${data.first["firstName"]}",
                                              color: AppColorConstant.appYellow,
                                              fontSize: 12.px,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          },
                                        ),
                                      ),
                                      AppText(
                                        " | ",
                                        fontSize: 12.px,
                                        color: AppColorConstant.appYellow,
                                      ),
                                      Container(
                                        child: (messageData
                                                    .first["messageType"] ==
                                                "image")
                                            ? Row(
                                                children: [
                                                  Icon(Icons.image,
                                                      size: 13.px,
                                                      color: AppColorConstant
                                                          .appYellow),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.px,
                                                        right: 5.px),
                                                    child: AppText(
                                                      "photo",
                                                      color: AppColorConstant
                                                          .appYellow,
                                                      fontSize: 10.px,
                                                    ),
                                                  ),
                                                  if (messageData
                                                      .first["messageStatus"])
                                                    Icon(
                                                      Icons.done_all,
                                                      size: 13.px,
                                                      color: AppColorConstant
                                                          .extraLightSky,
                                                    )
                                                  else
                                                    Icon(
                                                      Icons.done,
                                                      size: 13.px,
                                                      color: AppColorConstant
                                                          .appYellow,
                                                    )
                                                ],
                                              )
                                            : (messageData
                                                        .first["messageType"] ==
                                                    "doc")
                                                ? Row(
                                                    children: [
                                                      Icon(Icons.file_copy,
                                                          size: 13.px,
                                                          color:
                                                              AppColorConstant
                                                                  .appYellow),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.px,
                                                                right: 5.px),
                                                        child: AppText(
                                                          "document",
                                                          color:
                                                              AppColorConstant
                                                                  .appYellow,
                                                          fontSize: 10.px,
                                                        ),
                                                      ),
                                                      if (messageData.first[
                                                          "messageStatus"])
                                                        Icon(
                                                          Icons.done_all,
                                                          size: 13.px,
                                                          color: AppColorConstant
                                                              .extraLightSky,
                                                        )
                                                      else
                                                        Icon(
                                                          Icons.done,
                                                          size: 13.px,
                                                          color:
                                                              AppColorConstant
                                                                  .appYellow,
                                                        )
                                                    ],
                                                  )
                                                : ((messageData.first[
                                                            "messageType"] ==
                                                        "video"))
                                                    ? Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .video_collection,
                                                              size: 13.px,
                                                              color:
                                                                  AppColorConstant
                                                                      .appYellow),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5.px,
                                                                    right:
                                                                        5.px),
                                                            child: AppText(
                                                              "video",
                                                              color:
                                                                  AppColorConstant
                                                                      .appYellow,
                                                              fontSize: 10.px,
                                                            ),
                                                          ),
                                                          if (messageData.first[
                                                              "messageStatus"])
                                                            Icon(
                                                              Icons.done_all,
                                                              size: 13.px,
                                                              color: AppColorConstant
                                                                  .extraLightSky,
                                                            )
                                                          else
                                                            Icon(
                                                              Icons.done,
                                                              size: 13.px,
                                                              color:
                                                                  AppColorConstant
                                                                      .appYellow,
                                                            )
                                                        ],
                                                      )
                                                    : (messageData.first[
                                                                "messageType"] ==
                                                            "audio")
                                                        ? Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .multitrack_audio,
                                                                size: 13.px,
                                                                color: AppColorConstant
                                                                    .appYellow,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 5
                                                                            .px,
                                                                        right: 5
                                                                            .px),
                                                                child: AppText(
                                                                  "audio",
                                                                  color: AppColorConstant
                                                                      .appYellow,
                                                                  fontSize:
                                                                      10.px,
                                                                ),
                                                              ),
                                                              if (messageData
                                                                      .first[
                                                                  "messageStatus"])
                                                                Icon(
                                                                  Icons
                                                                      .done_all,
                                                                  size: 13.px,
                                                                  color: AppColorConstant
                                                                      .extraLightSky,
                                                                )
                                                              else
                                                                Icon(
                                                                  Icons.done,
                                                                  size: 13.px,
                                                                  color: AppColorConstant
                                                                      .appYellow,
                                                                )
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right: 5
                                                                            .px),
                                                                child:
                                                                    Container(
                                                                  width: 100.px,
                                                                  height: 20.px,
                                                                  child:
                                                                      AppText(
                                                                    messageData.first[
                                                                            "message"] ??
                                                                        "",
                                                                    color: AppColorConstant
                                                                        .appYellow,
                                                                    fontSize:
                                                                        12.px,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                              if (messageData
                                                                      .first[
                                                                  "messageStatus"])
                                                                Icon(
                                                                  Icons
                                                                      .done_all,
                                                                  size: 13.px,
                                                                  color: AppColorConstant
                                                                      .extraLightSky,
                                                                )
                                                              else
                                                                Icon(
                                                                  Icons.done,
                                                                  size: 13.px,
                                                                  color: AppColorConstant
                                                                      .appYellow,
                                                                )
                                                            ],
                                                          ),
                                      )
                                    ],
                                  )
                                : (messageData.first["messageType"] == "image")
                                    ? Row(
                                        children: [
                                          Icon(Icons.image,
                                              size: 13.px,
                                              color:
                                                  AppColorConstant.appYellow),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 5.px, right: 5.px),
                                            child: AppText(
                                              "photo",
                                              color: AppColorConstant.appYellow,
                                              fontSize: 10.px,
                                            ),
                                          ),
                                          if (messageData
                                              .first["messageStatus"])
                                            Icon(
                                              Icons.done_all,
                                              size: 13.px,
                                              color: AppColorConstant
                                                  .extraLightSky,
                                            )
                                          else
                                            Icon(
                                              Icons.done,
                                              size: 13.px,
                                              color: AppColorConstant.appYellow,
                                            )
                                        ],
                                      )
                                    : (messageData.first["messageType"] ==
                                            "doc")
                                        ? Row(
                                            children: [
                                              Icon(Icons.file_copy,
                                                  size: 13.px,
                                                  color: AppColorConstant
                                                      .appYellow),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.px, right: 5.px),
                                                child: AppText(
                                                  "document",
                                                  color: AppColorConstant
                                                      .appYellow,
                                                  fontSize: 10.px,
                                                ),
                                              ),
                                              if (messageData
                                                  .first["messageStatus"])
                                                Icon(
                                                  Icons.done_all,
                                                  size: 13.px,
                                                  color: AppColorConstant
                                                      .extraLightSky,
                                                )
                                              else
                                                Icon(
                                                  Icons.done,
                                                  size: 13.px,
                                                  color: AppColorConstant
                                                      .appYellow,
                                                )
                                            ],
                                          )
                                        : ((messageData.first["messageType"] ==
                                                "video"))
                                            ? Row(
                                                children: [
                                                  Icon(Icons.video_collection,
                                                      size: 13.px,
                                                      color: AppColorConstant
                                                          .appYellow),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.px,
                                                        right: 5.px),
                                                    child: AppText(
                                                      "video",
                                                      color: AppColorConstant
                                                          .appYellow,
                                                      fontSize: 10.px,
                                                    ),
                                                  ),
                                                  if (messageData
                                                      .first["messageStatus"])
                                                    Icon(
                                                      Icons.done_all,
                                                      size: 13.px,
                                                      color: AppColorConstant
                                                          .extraLightSky,
                                                    )
                                                  else
                                                    Icon(
                                                      Icons.done,
                                                      size: 13.px,
                                                      color: AppColorConstant
                                                          .appYellow,
                                                    )
                                                ],
                                              )
                                            : (messageData
                                                        .first["messageType"] ==
                                                    "audio")
                                                ? Row(
                                                    children: [
                                                      Icon(
                                                        Icons.multitrack_audio,
                                                        size: 13.px,
                                                        color: AppColorConstant
                                                            .appYellow,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.px,
                                                                right: 5.px),
                                                        child: AppText(
                                                          "audio",
                                                          color:
                                                              AppColorConstant
                                                                  .appYellow,
                                                          fontSize: 10.px,
                                                        ),
                                                      ),
                                                      if (messageData.first[
                                                          "messageStatus"])
                                                        Icon(
                                                          Icons.done_all,
                                                          size: 13.px,
                                                          color: AppColorConstant
                                                              .extraLightSky,
                                                        )
                                                      else
                                                        Icon(
                                                          Icons.done,
                                                          size: 13.px,
                                                          color:
                                                              AppColorConstant
                                                                  .appYellow,
                                                        )
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5.px),
                                                        child: SizedBox(
                                                          width: 140.px,
                                                          height: 20.px,
                                                          child: AppText(
                                                            messageData.first[
                                                                    "message"] ??
                                                                "",
                                                            color:
                                                                AppColorConstant
                                                                    .appYellow,
                                                            fontSize: 12.px,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      if (messageData.first[
                                                          "messageStatus"])
                                                        Icon(
                                                          Icons.done_all,
                                                          size: 13.px,
                                                          color: AppColorConstant
                                                              .extraLightSky,
                                                        )
                                                      else
                                                        Icon(
                                                          Icons.done,
                                                          size: 13.px,
                                                          color:
                                                              AppColorConstant
                                                                  .appYellow,
                                                        )
                                                    ],
                                                  );
                          },
                        ),
                      ));
                },
              )
            : Container(
                margin: EdgeInsets.all(20.px),
                alignment: Alignment.center,
                height: 200.px,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.px))),
                child: AppText(
                  textAlign: TextAlign.center,
                  "Let's\nStart Messaging\nwith ChatApp",
                  color: AppColorConstant.yellowLight,
                  fontSize: 25.px,
                ),
              );
      },
    );
  }
}
