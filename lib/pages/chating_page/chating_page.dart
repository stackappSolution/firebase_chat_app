import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/date_formation.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/modal/message.dart';
import 'package:signal/pages/chating_page/chating_page_view_modal.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_service.dart';
import 'package:signal/service/users_service.dart';

import '../../app/app/utills/theme_util.dart';
import '../../controller/chating_page_controller.dart';
import '../../modal/send_message_model.dart';
import '../../routes/app_navigation.dart';

// ignore: must_be_immutable
class ChatingPage extends StatelessWidget {
  ChatingPage({super.key});

  ChatingPageViewModal? chatingPageViewModal;
  static String date = '';
  ChatingPageController? controller;
  Color? wallColorbackground;
  DecorationImage? backgroundImage;

  getBlockedList() async {
    chatingPageViewModal!.blockedNumbers =
        await UsersService.instance.getBlockedUsers();
    logs('list-------------> ${chatingPageViewModal!.blockedNumbers}');
  }

  @override
  Widget build(BuildContext context) {
    chatingPageViewModal ?? (chatingPageViewModal = ChatingPageViewModal(this));

    return GetBuilder<ChatingPageController>(
      dispose: (state) {
        controller!.player.dispose();
      },
      initState: (state) async {
        chatingPageViewModal!.parameter = Get.parameters;
        chatingPageViewModal!.arguments = Get.arguments;
        chatingPageViewModal!.fontSize =
            await chatingPageViewModal!.fontSizeInitState();
        logs('fontSize-----------> ${chatingPageViewModal!.fontSize}');

        Future.delayed(
          const Duration(milliseconds: 0),
          () async {
            logs('arg--> ${chatingPageViewModal!.arguments}');
            controller = Get.find<ChatingPageController>();

            controller!.durationList = List.filled(100, Duration.zero);
            controller!.positionList = List.filled(100, Duration.zero);
            controller!.isPlayingList = List.filled(100, false);

            await chatingPageViewModal!.getBlockedList(controller);
            await chatingPageViewModal!.getChatId();
            await chatingPageViewModal!.getChatLength();

            chatingPageViewModal!.chatStream();
            chatingPageViewModal!.markMessage();
            chatingPageViewModal!.getColorFromFirestore();
            chatingPageViewModal!.getChatBubbleColors();
            chatingPageViewModal!.backWallpaper =
                await UsersService.getSinglebackgroundImage();
            chatingPageViewModal!.getChatBubbleColors();
            logs('chatBubbleColor-->${chatingPageViewModal!.chatbubblecolor}');

            Future<String?> key = getStringValue(wallpaper);
            chatingPageViewModal!.wallpaperPath = await key;

            chatingPageViewModal!.chatBubbleColor =
                await chatingPageViewModal!.getChatBubbleColor();

            chatingPageViewModal!.wallpaperColor =
                await chatingPageViewModal!.getWallpaperColor();
            controller!.update();
          },
        );
      },
      init: ChatingPageController(),
      builder: (ChatingPageController controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.player.dispose();
            return true;
          },
          child:Builder(builder: (context) {
            MediaQueryData mediaQuery = MediaQuery.of(context);
            ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
            return   Builder(builder: (context) {
              MediaQueryData mediaQuery = MediaQuery.of(context);
              ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
              return Scaffold(
              appBar: appBar(controller, context),
              body: Container(
                decoration: BoxDecoration(
                    image: (chatingPageViewModal!.wallpaperPath != null)
                        ? DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(
                            File(chatingPageViewModal!.wallpaperPath!)))
                        : null,
                    color: (chatingPageViewModal!.wallpaperPath != null)
                        ? chatingPageViewModal!.wallpaperColor
                        : Colors.transparent),
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: chatingPageViewModal!.getChatsStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return AppText(S.of(context).somethingWentWrong);
                          }
                          if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            chatingPageViewModal!.updateChatLength(data.length);
                            final message = snapshot.data!.docs
                                .map((doc) => doc.data() as Map<String, dynamic>)

                                .toList();

                            Future.delayed(
                              const Duration(milliseconds: 300),
                                  () {
                                DatabaseService.instance.markMessagesAsSeen(
                                    chatingPageViewModal!.snapshots.docs.first.id,
                                    chatingPageViewModal!.arguments['number']);
                              },
                            );

                            return Column(
                              children: [
                                (chatingPageViewModal!.arguments['isGroup'] &&
                                    message.isEmpty)
                                    ? Container(
                                  padding: EdgeInsets.all(8.px),
                                  margin: EdgeInsets.all(8.px),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(15.px),
                                        color: AppColorConstant.appWhite
                                            .withOpacity(0.3)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AppText(
                                        '${chatingPageViewModal!.arguments['createdBy']} created this group',
                                        fontSize: 10.px,
                                      ),
                                    ),
                                  ),
                                )
                                    : const SizedBox(),
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      GroupedListView(
                                        itemBuilder: (context, element) {
                                          int index = message.indexOf(element);

                                          String formattedTime = DateFormation()
                                              .getChatTimeFormate(
                                              element['messageTimestamp']);

                                          DateTime dateTime = DateFormation()
                                              .getDatetime(
                                              element['messageTimestamp']);

                                          chatingPageViewModal!.messageTimeStamp
                                              .add(dateTime);

                                          return buildMessage(
                                              MessageModel(
                                                  messageStatus:
                                                  element['messageStatus'],
                                                  message: element['message'],
                                                  isSender: element['isSender'],
                                                  messageTimestamp: formattedTime,
                                                  messageType:
                                                  element['messageType'],
                                                  sender: element['sender'],
                                                  text: element['text'],
                                                  emoji: element['emoji'],
                                                  messageId: element['messageid'],
                                                  thumb: element['thumb']),
                                              context,
                                              controller,
                                              index);
                                        },
                                        reverse: true,
                                        physics: const BouncingScrollPhysics(),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        order: GroupedListOrder.DESC,
                                        useStickyGroupSeparators: true,
                                        floatingHeader: true,
                                        elements: message,
                                        groupBy: (element) {
                                          String formatDate(DateTime dateTime) {
                                            return DateFormat('MMM d, y')
                                                .format(dateTime);
                                          }

                                          int timestamp =
                                          element['messageTimestamp'];
                                          DateTime date =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              timestamp);
                                          return formatDate(date);
                                        },
                                        groupHeaderBuilder: (value) {
                                          var timestamp =
                                          value['messageTimestamp'];
                                          String formatDate = DateFormation()
                                              .headerTimestamp(timestamp);
                                          return Container(
                                            margin: EdgeInsets.all(15.px),
                                            alignment: Alignment.center,
                                            height: 25.px,
                                            child: Container(
                                              padding: EdgeInsets.all(5.px),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(5.px),
                                                color: AppColorConstant.appGrey
                                                    .withOpacity(0.3),
                                              ),
                                              alignment: Alignment.center,
                                              height: 25.px,
                                              width: 100.px,
                                              child: Text(
                                                formatDate,
                                                style: const TextStyle(
                                                  color:
                                                  AppColorConstant.appBlack,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      // ignore: prefer_is_empty
                                      if (message.length < 0 &&
                                          chatingPageViewModal!
                                              .arguments["isGroup"])
                                        Container(
                                          padding: EdgeInsets.all(8.px),
                                          margin: EdgeInsets.all(8.px),
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(15.px),
                                                color: AppColorConstant.appWhite
                                                    .withOpacity(0.3)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: AppText(
                                                '${chatingPageViewModal!.arguments['createdBy']} created this group',
                                                fontSize: 10.px,
                                              ),
                                            ),
                                          ),

                                        )
                                    ],
                                  ),
                                )
                              ],
                            );
                          }
                          return AppLoader();
                        },
                      ),
                    ),
                    (chatingPageViewModal!.isBlockedByLoggedInUser)
                        ? buildUnblockView(context, controller)
                        : (chatingPageViewModal!.isBlockedByLoggedInUser)
                        ? buildBlockView(context)
                        : buildTextFormField(context, controller),
                    // chatingPageViewModal!.blockedNumbers.contains(chatingPageViewModal!.arguments['number'])
                  ],
                ),
              ),
            );});
          },)

        );
      },
    );
  }

  buildBlockView(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.px,
      color: AppColorConstant.appYellow.withOpacity(0.1),
      child: Column(
        children: [
          SizedBox(
            height: 20.px,
          ),
          AppText(
            S.of(context).blockMessageToReceiver,
            textAlign: TextAlign.center,
            fontSize: 12.px,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(
            height: 20.px,
          ),
        ],
      ),
    );
  }

  buildTextFormField(BuildContext context, ChatingPageController controller) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          chatingPageViewModal!.buildPopupMenu(context, controller),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(right: 15.px, bottom: 5.px, top: 5.px),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(35.px)),
                height: 40.px,
                child: textFormField(controller, context)),
          ),
          chatingPageViewModal!.isLoading
              ? Padding(
                  padding:
                      EdgeInsets.only(right: 5.px, bottom: 5.px, top: 5.px),
                  child: const CircularProgressIndicator(),
                )
              : AppButton(
                  margin: EdgeInsets.only(right: 5.px, bottom: 5.px, top: 5.px),
                  color: AppColorConstant.appTransparent,
                  height: 30.px,
                  stringChild: true,
                  width: 40.px,
                  borderRadius: BorderRadius.circular(40.px),
                  child: GestureDetector(
                    onLongPress: () {
                      chatingPageViewModal!.checkPermission();
                      chatingPageViewModal!.startRecord();
                    },
                    onLongPressUp: () {
                      chatingPageViewModal!.stopRecord();
                    },
                    child: AppButton(
                      color: AppColorConstant.appTransparent,
                      height: 30.px,
                      stringChild: true,
                      width: 40.px,
                      borderRadius: BorderRadius.circular(40.px),
                      child: Icon(Icons.mic, size: 27.px),
                      onTap: () {
                        chatingPageViewModal!.checkPermission();
                        chatingPageViewModal!.stopRecord();
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  buildUnblockView(BuildContext context, ChatingPageController controller) {
    return Container(
      padding: EdgeInsets.all(12.px),
      width: double.infinity,
      height: 150.px,
      color: AppColorConstant.appYellow.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 20.px,
          ),
          AppText(
            S.of(context).unblockMessage,
            textAlign: TextAlign.center,
            fontSize: 12.px,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(
            height: 20.px,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: const AppText(
                  'cancel',
                  color: AppColorConstant.appYellow,
                ),
              ),
              AppButton(
                onTap: () {
                  chatingPageViewModal!.blockedNumbers
                      .remove(chatingPageViewModal!.arguments['number']);
                  UsersService.instance
                      .unblockUser(chatingPageViewModal!.arguments['number']);
                  chatingPageViewModal!.getBlockedList(controller);
                  controller.update();
                },
                borderRadius: BorderRadius.circular(12.px),
                height: 35,
                width: 90.px,
                color: AppColorConstant.appYellow,
                stringChild: true,
                child: AppText(S.of(context).unblock,
                    color: AppColorConstant.appWhite, fontSize: 12.px),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildMessage(MessageModel message, BuildContext context,
      ChatingPageController controller, int index) {
    return Slidable(
      child: (message.sender == AuthService.auth.currentUser!.phoneNumber)
          ? (Slidable(
              endActionPane: ActionPane(
                extentRatio:
                    chatingPageViewModal!.fontSize == S.of(context).small
                        ? 0.115.px
                        : chatingPageViewModal!.fontSize == S.of(context).large
                            ? 0.15.px
                            : chatingPageViewModal!.fontSize ==
                                    S.of(context).extraLarge
                                ? 0.189.px
                                : 0.13.px,
                motion: const ScrollMotion(),
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.px),
                      child: CircleAvatar(
                        radius: chatingPageViewModal!.fontSize ==
                                S.of(context).small
                            ? 15.px
                            : chatingPageViewModal!.fontSize ==
                                    S.of(context).large
                                ? 22.px
                                : chatingPageViewModal!.fontSize ==
                                        S.of(context).extraLarge
                                    ? 28.px
                                    : 18.px,
                        backgroundColor: chatingPageViewModal!.chatBubbleColor,
                      ),
                    ),
                  ),
                ],
              ),
              child: (message.messageType == 'text')
                  ? buildSenderMessageView(context, message)
                  : (message.messageType == 'image')
                      ? buildSenderImageView(message, context, index)
                      : (message.messageType == 'audio')
                          ? buildSenderAudioView(
                              controller, context, message, index)
                          : (message.messageType == 'doc')
                              ? buildSenderDocumentView(context, message, index)
                              : buildSenderVideoView(context, message, index)))
          : (Slidable(
              startActionPane: ActionPane(
                extentRatio:
                    chatingPageViewModal!.fontSize == S.of(context).small
                        ? 0.115.px
                        : chatingPageViewModal!.fontSize == S.of(context).large
                            ? 0.15.px
                            : chatingPageViewModal!.fontSize ==
                                    S.of(context).extraLarge
                                ? 0.189.px
                                : 0.13.px,
                motion: const ScrollMotion(),
                children: [
                  SizedBox(width: 10.px),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.px),
                      child: CircleAvatar(
                        radius: chatingPageViewModal!.fontSize ==
                                S.of(context).small
                            ? 15.px
                            : chatingPageViewModal!.fontSize ==
                                    S.of(context).large
                                ? 22.px
                                : chatingPageViewModal!.fontSize ==
                                        S.of(context).extraLarge
                                    ? 28.px
                                    : 18.px,
                        backgroundColor:
                            AppColorConstant.appGrey.withOpacity(0.3),
                        child: AppText(
                          (chatingPageViewModal!.arguments['isGroup'] != false)
                              ? (chatingPageViewModal!.arguments['groupName']
                                      .toString()
                                      .isNotEmpty)
                                  ? chatingPageViewModal!.arguments['groupName']
                                      .substring(0, 1)
                                      .toUpperCase()
                                  : ""
                              : chatingPageViewModal!.arguments['name']
                                  .substring(0, 1)
                                  .toUpperCase(),
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: chatingPageViewModal!.fontSize ==
                                  S.of(context).small
                              ? 10.px
                              : chatingPageViewModal!.fontSize ==
                                      S.of(context).large
                                  ? 20.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).extraLarge
                                      ? 25.px
                                      : 15.px,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              child: (message.messageType == 'text')
                  ? buildReceiverMessageView(context, message)
                  : (message.messageType == 'image')
                      ? buildReceiverImageView(message, context, index)
                      : (message.messageType == 'audio')
                          ? buildReceiverAudioView(
                              context, controller, message, index)
                          : (message.messageType == 'doc')
                              ? buildReceiverDocumentView(
                                  context, message, index)
                              : buildReceiverVideoView(context, message, index),
            )),
    );
  }

  ///  /////////////// ============================  message View ============================================///////
  buildReceiverMessageView(BuildContext context, MessageModel message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPressDown: (details) {
              log("receicer isssddd-->${message.sender}");
              chatingPageViewModal!.showEmojiMenu(
                  context,
                  details.globalPosition,
                  chatingPageViewModal!.snapshots.docs[0]['id'],
                  message.messageId,
                  message.sender,
                  chatingPageViewModal!.arguments["isGroup"]);
              logs(
                  'showimg--> ${chatingPageViewModal!.snapshots.docs[0]['id']}');
            },
            child: ChatBubble(
              elevation: 0,
              margin: EdgeInsets.only(right: 100.px),
              clipper: ChatBubbleClipper2(
                  type: BubbleType.receiverBubble,
                  nipHeight: 10.px,
                  nipWidth: 6.px,
                  radius: 5.px),
              backGroundColor: AppColorConstant.appGrey.withOpacity(0.3),
              child: (chatingPageViewModal!.arguments['isGroup'])
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_circle_rounded,
                              size: 12.px,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.px),
                              child: StreamBuilder(
                                stream: controller!.getUserName(message.sender
                                    .toString()
                                    .trim()
                                    .removeAllWhitespace),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return AppText(
                                      '',
                                      fontSize: 10.px,
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return AppText(
                                      '',
                                      fontSize: 10.px,
                                    );

                                  }
                                  final data = snapshot.data!.docs;
                                  logs("name -- > ${data.first['firstName']}");
                                  logs("length -- > ${data.length}");

                                  return AppText(
                                    data.first['firstName'],
                                    fontSize: 10.px,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: AppColorConstant.appWhite,
                                    fontWeight: FontWeight.bold,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        AppText(
                          message.message.toString(),
                          color: AppColorConstant.appBlack,
                          fontSize: chatingPageViewModal!.fontSize ==
                                  S.of(context).small
                              ? 10.px
                              : chatingPageViewModal!.fontSize ==
                                      S.of(context).large
                                  ? 20.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).extraLarge
                                      ? 25.px
                                      : 15.px,
                        ),
                      ],
                    )
                  : AppText(
                      message.message.toString(),
                      color: AppColorConstant.appBlack,
                      fontSize:
                          chatingPageViewModal!.fontSize == S.of(context).small
                              ? 10.px
                              : chatingPageViewModal!.fontSize ==
                                      S.of(context).large
                                  ? 20.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).extraLarge
                                      ? 25.px
                                      : 15.px,
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.px, top: 3.px),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  message.messageTimestamp.toString(),
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: chatingPageViewModal!.fontSize ==
                          S.of(context).small
                      ? 8.px
                      : chatingPageViewModal!.fontSize == S.of(context).large
                          ? 15.px
                          : chatingPageViewModal!.fontSize ==
                                  S.of(context).extraLarge
                              ? 20.px
                              : 12.px,
                ),
                if (message.emoji != null &&
                    message.emoji!.containsKey('groupEmojis'))
                  for (var emoji in message.emoji!['groupEmojis'])
                    AppText(emoji['emoji']),
                if (message.emoji != null &&
                    message.emoji!.containsKey('receiverEmoji'))
                  GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          backgroundColor: AppColorConstant.appWhite,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          ListTile(
                            onTap: () {
                              chatingPageViewModal!.deleteEmoji(
                                  chatingPageViewModal!.snapshots.docs[0]['id'],
                                  message.messageId,
                                  message.sender,
                                  message.emoji,
                                  message.emoji);
                              Get.back();
                            },
                            leading: const CircleAvatar(
                                backgroundColor: Colors.deepOrange),
                            title: AppText(message.sender.toString(),
                                fontSize: 16),
                            trailing: AppText(
                                message.emoji!['receiverEmoji']['emoji'],
                                fontSize: 16),
                          ),
                        );
                      },
                      child: AppText(message.emoji!['receiverEmoji']['emoji'])),
                if (message.emoji != null &&
                    message.emoji!.containsKey('senderEmoji'))
                  AppText(message.emoji!['senderEmoji']['emoji']),
              ],
            ),
          ),
        ],
      ),
    );
  }


  buildSenderMessageView(BuildContext context, MessageModel message,) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onLongPressDown: (details) {
              log("sender isssddd-->${message.sender}");
              chatingPageViewModal!.showEmojiMenu(
                  context,
                  details.globalPosition,
                  chatingPageViewModal!.snapshots.docs[0]['id'],
                  message.messageId,
                  message.sender,
                  chatingPageViewModal!.arguments["isGroup"]);
            },
            child: ChatBubble(
              elevation: 0,
              margin: EdgeInsets.only(left: 80.px),
              clipper: ChatBubbleClipper2(
                  type: BubbleType.sendBubble,
                  nipHeight: 10.px,
                  nipWidth: 6.px,
                  radius: 5.px),
              alignment: Alignment.topRight,
              backGroundColor: chatingPageViewModal!.bubblColors,
              child: AppText(
                message.message.toString(),
                color: AppColorConstant.appWhite,
                fontSize: chatingPageViewModal!.fontSize == S.of(context).small
                    ? 10.px
                    : chatingPageViewModal!.fontSize == S.of(context).large
                        ? 20.px
                        : chatingPageViewModal!.fontSize ==
                                S.of(context).extraLarge
                            ? 25.px
                            : 15.px,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 5.px, top: 3.px),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.emoji != null &&
                    message.emoji!.containsKey('groupEmojis'))
                  for (var emoji in message.emoji!['groupEmojis'])
                    AppText(emoji['emoji']),
                if (message.emoji != null &&
                    message.emoji!.containsKey('senderEmoji'))
                  GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          backgroundColor: AppColorConstant.appWhite,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          ListTile(
                            onTap: () {
                              chatingPageViewModal!.deleteEmoji(
                                  chatingPageViewModal!.snapshots.docs[0]['id'],
                                  message.messageId,
                                  message.sender,
                                  message.emoji,
                                  message.emoji);
                              Get.back();
                            },
                            leading: const CircleAvatar(
                                backgroundColor: Colors.deepOrange),
                            title: AppText(message.sender.toString(),
                                fontSize: 16),
                            trailing: AppText(
                                message.emoji!['senderEmoji']['emoji'],
                                fontSize: 16),
                          ),
                        );
                      },
                      child: AppText(message.emoji!['senderEmoji']['emoji'])),
                if (message.emoji != null &&
                    message.emoji!.containsKey('receiverEmoji'))
                  AppText(message.emoji!['receiverEmoji']['emoji']),
                AppText(
                  message.messageTimestamp.toString(),
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: chatingPageViewModal!.fontSize ==
                          S.of(context).small
                      ? 8.px
                      : chatingPageViewModal!.fontSize == S.of(context).large
                          ? 15.px
                          : chatingPageViewModal!.fontSize ==
                                  S.of(context).extraLarge
                              ? 20.px
                              : 12.px,
                ),
                SizedBox(
                  width: 10.px,
                ),
                (message.sender == AuthService.auth.currentUser!.phoneNumber)
                    ? (message.messageStatus == true)
                        ? chatingPageViewModal!.buildDoubleClickView()
                        : chatingPageViewModal!.buildSingleClickView()
                    : null,
              ],
            ),
          ),
        ],
      ),
    );
  }

  //===========================  image =============================//

  buildReceiverImageView(MessageModel message, BuildContext context, index) {
    chatingPageViewModal!.isFileDownloadedCheck(
      index,
      "IMAGE",
      message.message,
      controller!,
    );
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        alignment: Alignment.center,
        width: 170.px,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                chatingPageViewModal!
                    .viewFile(message.message, "IMAGE", controller!, index);
              },
              onDoubleTapDown: (details) {
                chatingPageViewModal!.showEmojiMenu(
                  context,
                  details.globalPosition,
                  chatingPageViewModal!.snapshots.docs[0]['id'],
                  message.messageId,
                  message.sender,
                  chatingPageViewModal!.arguments["isGroup"],
                );
                logs('showimg--> ${chatingPageViewModal!.snapshots}');
              },
              child: Container(
                margin: EdgeInsets.all(10.px),
                decoration: BoxDecoration(
                  color: AppColorConstant.darkSecondary,
                  border: Border.all(
                    width: 2.px,
                    color: AppColorConstant.darkSecondary,
                  ),
                  borderRadius: BorderRadius.circular(12.px),
                ),
                width: 150.px,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.px, vertical: 3.px),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle_rounded,
                              size: 12.px,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.px),
                              child: StreamBuilder(
                                stream: controller!.getUserName(message.sender
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
                                  logs("name -- > ${data.first['firstName']}");
                                  logs("length -- > ${data.length}");

                                  return AppText(
                                    data.first['firstName'],
                                    fontSize: 10.px,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: AppColorConstant.appWhite,
                                    fontWeight: FontWeight.bold,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.px),
                          child: (chatingPageViewModal!
                                  .isFileDownLoadedList[index])
                              ? AppImageAsset(image: message.thumb)
                              : AppImageAsset(image: message.message),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (chatingPageViewModal!
                                    .isFileDownLoadingList[index] &&
                                !chatingPageViewModal!
                                    .isFileDownLoadedList[index])
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: AppColorConstant.appYellow,
                                ),
                              ),
                            if (!chatingPageViewModal!
                                    .isFileDownLoadedList[index] &&
                                !chatingPageViewModal!
                                    .isFileDownLoadingList[index])
                              InkWell(
                                onTap: () {
                                  chatingPageViewModal!.viewFile(
                                      message.message,
                                      "IMAGE",
                                      controller!,
                                      index);
                                },
                                child: Icon(
                                  Icons.download_for_offline_outlined,
                                  size: 45.px,
                                  color: AppColorConstant.appYellow,
                                ),
                              )
                          ],
                        )
                      ],
                    ),
                    if (message.text!.isNotEmpty)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(4.px),
                            child: AppText(
                              message.text.toString(),
                              fontSize: chatingPageViewModal!.fontSize ==
                                      S.of(context).small
                                  ? 10.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).large
                                      ? 20.px
                                      : chatingPageViewModal!.fontSize ==
                                              S.of(context).extraLarge
                                          ? 25.px
                                          : 15.px,
                              color: AppColorConstant.appWhite,
                            ),
                          ))
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10.px),
                child: Row(
                  children: [
                    AppText(
                      message.messageTimestamp.toString(),
                      color: Theme.of(context).colorScheme.primary,
                      textAlign: TextAlign.start,
                      fontSize:
                          chatingPageViewModal!.fontSize == S.of(context).small
                              ? 8.px
                              : chatingPageViewModal!.fontSize ==
                                      S.of(context).large
                                  ? 15.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).extraLarge
                                      ? 20.px
                                      : 12.px,
                    ),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('groupEmojis'))
                      for (var emoji in message.emoji!['groupEmojis'])
                        AppText(emoji['emoji']),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('receiverEmoji'))
                      GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              backgroundColor: AppColorConstant.appWhite,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.px),
                                      topRight: Radius.circular(30.px))),
                              ListTile(
                                onTap: () {
                                  chatingPageViewModal!.deleteEmoji(
                                      chatingPageViewModal!.snapshots.docs[0]
                                          ['id'],
                                      message.messageId,
                                      message.sender,
                                      message.emoji,
                                      message.emoji);
                                  Get.back();
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.deepOrange),
                                title: AppText(message.sender.toString(),
                                    fontSize: 16.px),
                                trailing: AppText(
                                    message.emoji!['receiverEmoji']['emoji'],
                                    fontSize: 16.px),
                              ),
                            );
                          },
                          child: AppText(
                              message.emoji!['receiverEmoji']['emoji'])),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('senderEmoji'))
                      AppText(message.emoji!['senderEmoji']['emoji']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSenderImageView(MessageModel message, BuildContext context, index) {
    chatingPageViewModal!.isFileDownloadedCheck(
      index,
      "SENT/IMAGE",
      message.message,
      controller!,
    );
    return Align(
      alignment: Alignment.topRight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  chatingPageViewModal!.viewFile(
                      message.message, "SENT/IMAGE", controller!, index);
                },
                onDoubleTapDown: (details) {
                  chatingPageViewModal!.showEmojiMenu(
                    context,
                    details.globalPosition,
                    chatingPageViewModal!.snapshots.docs[0]['id'],
                    message.messageId,
                    message.sender,
                    chatingPageViewModal!.arguments["isGroup"],
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10.px),
                  decoration: BoxDecoration(
                    color: chatingPageViewModal!.bubblColors,
                    border: Border.all(
                      color: AppColorConstant.appYellow,
                    ),
                    borderRadius: BorderRadius.circular(12.px),
                  ),
                  width: 150.px,
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12.px),
                          child: (false)
                              ? AppImageAsset(image: message.thumb)
                              : AppImageAsset(image: message.message)),
                      if (message.text!.isNotEmpty)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(4.px),
                              child: AppText(
                                message.text.toString(),
                                fontSize: chatingPageViewModal!.fontSize ==
                                        S.of(context).small
                                    ? 10.px
                                    : chatingPageViewModal!.fontSize ==
                                            S.of(context).large
                                        ? 20.px
                                        : chatingPageViewModal!.fontSize ==
                                                S.of(context).extraLarge
                                            ? 25.px
                                            : 15.px,
                                color: AppColorConstant.appWhite,
                              ),
                            ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 13.px,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.emoji != null &&
                        message.emoji!.containsKey('groupEmojis'))
                      for (var emoji in message.emoji!['groupEmojis'])
                        AppText(emoji['emoji']),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('senderEmoji'))
                      GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              backgroundColor: AppColorConstant.appWhite,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.px),
                                      topRight: Radius.circular(30.px))),
                              ListTile(
                                onTap: () {
                                  chatingPageViewModal!.deleteEmoji(
                                      chatingPageViewModal!.snapshots.docs[0]
                                          ['id'],
                                      message.messageId,
                                      message.sender,
                                      message.emoji,
                                      message.emoji);
                                  Get.back();
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.deepOrange),
                                title: AppText(message.sender.toString(),
                                    fontSize: 16),
                                trailing: AppText(
                                    message.emoji!['senderEmoji']['emoji'],
                                    fontSize: 16),
                              ),
                            );
                          },
                          child:
                              AppText(message.emoji!['senderEmoji']['emoji'])),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('receiverEmoji'))
                      AppText(message.emoji!['receiverEmoji']['emoji']),
                    AppText(
                      message.messageTimestamp.toString(),
                      color: Theme.of(context).colorScheme.primary,
                      fontSize:
                          chatingPageViewModal!.fontSize == S.of(context).small
                              ? 8.px
                              : chatingPageViewModal!.fontSize ==
                                      S.of(context).large
                                  ? 15.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).extraLarge
                                      ? 20.px
                                      : 12.px,
                    ),
                    SizedBox(
                      width: 10.px,
                    ),
                    (message.sender ==
                            AuthService.auth.currentUser!.phoneNumber)
                        ? (message.messageStatus == true)
                            ? chatingPageViewModal!.buildDoubleClickView()
                            : chatingPageViewModal!.buildSingleClickView()
                        : null,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //===========================  audio =============================//

  buildSenderAudioView(ChatingPageController controller, BuildContext context,
      MessageModel message, int index) {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
              onDoubleTapDown: (details) {
                chatingPageViewModal!.showEmojiMenu(
                  context,
                  details.globalPosition,
                  chatingPageViewModal!.snapshots.docs[0]['id'],
                  message.messageId,
                  message.sender,
                  chatingPageViewModal!.arguments["isGroup"],
                );
              },
              child: Container(
                margin: EdgeInsets.all(6.px),
                width: 265.px,
                decoration: BoxDecoration(
                    color: chatingPageViewModal!.bubblColors,
                    borderRadius: BorderRadius.circular(12.px)),
                child: Column(
                  children: [
                    Container(
                      width: 265.px,
                      height: 45.px,
                      decoration: BoxDecoration(
                          color: chatingPageViewModal!.chatBubbleColor,
                          borderRadius: BorderRadius.circular(12.px)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColorConstant.appWhite,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 8.px,
                                  disabledThumbRadius: 8.px),
                            ),
                            child: SizedBox(
                              width: 150.px,
                              child: Slider(
                                activeColor: AppColorConstant.appWhite,
                                min: 0,
                                max: controller.durationList[index].inSeconds
                                    .toDouble(),
                                value: controller.positionList[index].inSeconds
                                    .toDouble(),
                                onChanged: (value) async {
                                  controller.positionList[index] =
                                      Duration(seconds: value.toInt());
                                  await controller.player
                                      .seek(controller.positionList[index]);
                                  //await controller.player.resume();
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 50.px,
                            alignment: Alignment.center,
                            child: AppText(
                              DateFormation()
                                  .formatTime(controller.positionList[index]),
                              color: AppColorConstant.appWhite,
                              fontSize: 10.px,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                controller.index = index;
                                controller.update();

                                chatingPageViewModal!.viewFile(message.message,
                                    "SENT/AUDIO", controller, index);
                              },
                              icon: (controller!.isPlayingList[index])
                                  ? const Icon(
                                      Icons.pause_circle,
                                      color: AppColorConstant.appWhite,
                                    )
                                  : const Icon(Icons.play_circle,
                                      color: AppColorConstant.appWhite)),
                        ],
                      ),
                    ),
                    if (message.text!.isNotEmpty)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.px, horizontal: 8.px),
                            child: AppText(
                              message.text.toString(),
                              fontSize: chatingPageViewModal!.fontSize ==
                                      S.of(context).small
                                  ? 10.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).large
                                      ? 20.px
                                      : chatingPageViewModal!.fontSize ==
                                              S.of(context).extraLarge
                                          ? 25.px
                                          : 15.px,
                              color: AppColorConstant.blackOff,
                            ),
                          )),
                  ],
                ),
              )),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                right: 13.px,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.emoji != null &&
                      message.emoji!.containsKey('groupEmojis'))
                    for (var emoji in message.emoji!['groupEmojis'])
                      AppText(emoji['emoji']),
                  if (message.emoji != null &&
                      message.emoji!.containsKey('senderEmoji'))
                    GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            backgroundColor: AppColorConstant.appWhite,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            ListTile(
                              onTap: () {
                                chatingPageViewModal!.deleteEmoji(
                                    chatingPageViewModal!.snapshots.docs[0]
                                        ['id'],
                                    message.messageId,
                                    message.sender,
                                    message.emoji,
                                    message.emoji);
                                Get.back();
                              },
                              leading: const CircleAvatar(
                                  backgroundColor: Colors.deepOrange),
                              title: AppText(message.sender.toString(),
                                  fontSize: 16),
                              trailing: AppText(
                                  message.emoji!['senderEmoji']['emoji'],
                                  fontSize: 16),
                            ),
                          );
                        },
                        child: AppText(message.emoji!['senderEmoji']['emoji'])),
                  if (message.emoji != null &&
                      message.emoji!.containsKey('receiverEmoji'))
                    AppText(message.emoji!['receiverEmoji']['emoji']),
                  AppText(
                    message.messageTimestamp.toString(),
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: chatingPageViewModal!.fontSize ==
                            S.of(context).small
                        ? 8.px
                        : chatingPageViewModal!.fontSize == S.of(context).large
                            ? 15.px
                            : chatingPageViewModal!.fontSize ==
                                    S.of(context).extraLarge
                                ? 20.px
                                : 12.px,
                  ),
                  SizedBox(
                    width: 10.px,
                  ),
                  (message.sender == AuthService.auth.currentUser!.phoneNumber)
                      ? (message.messageStatus == true)
                          ? chatingPageViewModal!.buildDoubleClickView()
                          : chatingPageViewModal!.buildSingleClickView()
                      : null,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildReceiverAudioView(BuildContext context, ChatingPageController controller,
      MessageModel message, int index) {
    chatingPageViewModal!.isFileDownloadedCheck(
      index,
      "AUDIO",
      message.message,
      controller,
    );
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onDoubleTapDown: (details) {
              chatingPageViewModal!.showEmojiMenu(
                context,
                details.globalPosition,
                chatingPageViewModal!.snapshots.docs[0]['id'],
                message.messageId,
                message.sender,
                chatingPageViewModal!.arguments["isGroup"],
              );
              logs('showimg--> ${chatingPageViewModal!.snapshots}');
            },
            child: Container(
              margin: EdgeInsets.all(7.px),
              decoration: BoxDecoration(
                  color: AppColorConstant.darkSecondary,
                  borderRadius: BorderRadius.circular(12.px)),
              width: 265.px,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.px, vertical: 3.px),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle_rounded,
                            size: 12.px,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.px),
                            child: StreamBuilder(
                              stream: controller.getUserName(message.sender
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

                                return AppText(
                                  data.first['firstName'],
                                  fontSize: 10.px,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: AppColorConstant.appWhite,
                                  fontWeight: FontWeight.bold,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 265.px,
                    height: 45.px,
                    decoration: BoxDecoration(
                        color: AppColorConstant.blackOff,
                        borderRadius: BorderRadius.circular(12.px)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColorConstant.appWhite,
                            thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 8.px,
                                disabledThumbRadius: 8.px),
                          ),
                          child: SizedBox(
                            width: 150.px,
                            child: Slider(
                              activeColor: AppColorConstant.appWhite,
                              min: 0.0,
                              max: (controller.durationList[index].inSeconds
                                          .toDouble() <
                                      0.0)
                                  ? 1.0
                                  : controller.durationList[index].inSeconds
                                      .toDouble(),
                              value: (controller.positionList[index].inSeconds
                                          .toDouble() <
                                      0.0)
                                  ? 1.0
                                  : controller.positionList[index].inSeconds
                                      .toDouble(),
                              onChanged: (value) async {
                                controller.positionList[index] =
                                    Duration(seconds: value.toInt());
                                await controller.player
                                    .seek(controller.positionList[index]);
                                //await controller.player.resume();
                              },
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 50.px,
                          child: AppText(
                            DateFormation()
                                .formatTime(controller.positionList[index]),
                            color: AppColorConstant.appWhite,
                            fontSize: 10.px,
                          ),
                        ),
                        if (chatingPageViewModal!.isFileDownLoadedList[index])
                          IconButton(
                              onPressed: () async {
                                controller.index = index;
                                controller.update();

                                chatingPageViewModal!.viewFile(message.message,
                                    "AUDIO", controller, index);
                              },
                              icon: (controller.isPlayingList[index])
                                  ? const Icon(
                                      Icons.pause_circle,
                                      color: AppColorConstant.appWhite,
                                    )
                                  : const Icon(Icons.play_circle,
                                      color: AppColorConstant.appWhite)),
                        if (!chatingPageViewModal!
                                .isFileDownLoadingList[index] &&
                            !chatingPageViewModal!.isFileDownLoadedList[index])
                          Padding(
                            padding: EdgeInsets.only(left: 10.px),
                            child: InkWell(
                                onTap: () {
                                  chatingPageViewModal!.viewFile(
                                      message.message,
                                      "AUDIO",
                                      controller,
                                      index);
                                },
                                child: const Icon(
                                  Icons.download_for_offline_outlined,
                                  color: AppColorConstant.appYellow,
                                )),
                          ),
                        if (chatingPageViewModal!
                                .isFileDownLoadingList[index] &&
                            !chatingPageViewModal!.isFileDownLoadedList[index])
                          Container(
                            width: 30.px,
                            height: 30,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.px),
                            margin: EdgeInsets.only(left: 8.px),
                            child: const CircularProgressIndicator(
                              color: AppColorConstant.appWhite,
                            ),
                          )
                      ],
                    ),
                  ),
                  if (message.text!.isNotEmpty)
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.px, horizontal: 8.px),
                          child: Row(
                            children: [
                              AppText(
                                message.text.toString(),
                                fontSize: chatingPageViewModal!.fontSize ==
                                        S.of(context).small
                                    ? 10.px
                                    : chatingPageViewModal!.fontSize ==
                                            S.of(context).large
                                        ? 20.px
                                        : chatingPageViewModal!.fontSize ==
                                                S.of(context).extraLarge
                                            ? 25.px
                                            : 15.px,
                                color: AppColorConstant.appWhite,
                              ),
                              if (message.emoji != null &&
                                  message.emoji!.containsKey('groupEmojis'))
                                for (var emoji in message.emoji!['groupEmojis'])
                                  AppText(emoji['emoji']),
                              if (message.emoji != null &&
                                  message.emoji!.containsKey('receiverEmoji'))
                                GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                        backgroundColor:
                                            AppColorConstant.appWhite,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30))),
                                        ListTile(
                                          onTap: () {
                                            chatingPageViewModal!.deleteEmoji(
                                                chatingPageViewModal!
                                                    .snapshots.docs[0]['id'],
                                                message.messageId,
                                                message.sender,
                                                message.emoji,
                                                message.emoji);
                                            Get.back();
                                          },
                                          leading: const CircleAvatar(
                                              backgroundColor:
                                                  Colors.deepOrange),
                                          title: AppText(
                                              message.sender.toString(),
                                              fontSize: 16),
                                          trailing: AppText(
                                              message.emoji!['receiverEmoji']
                                                  ['emoji'],
                                              fontSize: 16),
                                        ),
                                      );
                                    },
                                    child: AppText(message
                                        .emoji!['receiverEmoji']['emoji'])),
                              if (message.emoji != null &&
                                  message.emoji!.containsKey('senderEmoji'))
                                AppText(message.emoji!['senderEmoji']['emoji']),
                            ],
                          ),
                        ))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: AppText(
                message.messageTimestamp.toString(),
                color: Theme.of(context).colorScheme.primary,
                textAlign: TextAlign.start,
                fontSize: chatingPageViewModal!.fontSize == S.of(context).small
                    ? 8.px
                    : chatingPageViewModal!.fontSize == S.of(context).large
                        ? 15.px
                        : chatingPageViewModal!.fontSize ==
                                S.of(context).extraLarge
                            ? 20.px
                            : 12.px,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //===========================  video =============================//

  buildSenderVideoView(context, MessageModel message, index) {
    chatingPageViewModal!.isFileDownloadedCheck(
      index,
      "SENT/VIDEO",
      message.message,
      controller!,
    );
    return Align(
      alignment: Alignment.topRight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTapDown: (details) {
                  chatingPageViewModal!.viewFile(
                      message.message, "SENT/VIDEO", controller!, index);
                },
                onDoubleTapDown: (details) {
                  chatingPageViewModal!.showEmojiMenu(
                    context,
                    details.globalPosition,
                    chatingPageViewModal!.snapshots.docs[0]['id'],
                    message.messageId,
                    message.sender,
                    chatingPageViewModal!.arguments["isGroup"],
                  );
                },
                child: Container(
                  width: 130.px,
                  margin: EdgeInsets.all(8.px),
                  decoration: BoxDecoration(
                      color: chatingPageViewModal!.bubblColors,
                      borderRadius: BorderRadius.all(Radius.circular(10.px))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.px, color: AppColorConstant.appYellow),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.px)),
                            color: AppColorConstant.yellowLight),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const AppImageAsset(
                              image: AppAsset.signIn,
                              fit: BoxFit.fill,
                            ),
                            InkWell(
                              onTap: () {
                                chatingPageViewModal!.viewFile(message.message,
                                    "SENT/VIDEO", controller!, index);
                              },
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 45.px,
                                color: AppColorConstant.appYellow,
                              ),
                            )
                          ],
                        ),
                      ),
                      if (message.text!.isNotEmpty)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(4.px),
                              child: AppText(
                                message.text.toString(),
                                fontSize: chatingPageViewModal!.fontSize ==
                                        S.of(context).small
                                    ? 10.px
                                    : chatingPageViewModal!.fontSize ==
                                            S.of(context).large
                                        ? 20.px
                                        : chatingPageViewModal!.fontSize ==
                                                S.of(context).extraLarge
                                            ? 25.px
                                            : 15.px,
                                color: AppColorConstant.appWhite,
                              ),
                            ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 13.px, top: 3.px),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.emoji != null &&
                        message.emoji!.containsKey('groupEmojis'))
                      for (var emoji in message.emoji!['groupEmojis'])
                        AppText(emoji['emoji']),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('senderEmoji'))
                      GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              backgroundColor: AppColorConstant.appWhite,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              ListTile(
                                onTap: () {
                                  chatingPageViewModal!.deleteEmoji(
                                      chatingPageViewModal!.snapshots.docs[0]
                                          ['id'],
                                      message.messageId,
                                      message.sender,
                                      message.emoji,
                                      message.emoji);
                                  Get.back();
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.deepOrange),
                                title: AppText(message.sender.toString(),
                                    fontSize: 16),
                                trailing: AppText(
                                    message.emoji!['senderEmoji']['emoji'],
                                    fontSize: 16),
                              ),
                            );
                          },
                          child:
                              AppText(message.emoji!['senderEmoji']['emoji'])),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('receiverEmoji'))
                      AppText(message.emoji!['receiverEmoji']['emoji']),
                    AppText(
                      message.messageTimestamp.toString(),
                      color: Theme.of(context).colorScheme.primary,
                      fontSize:
                          chatingPageViewModal!.fontSize == S.of(context).small
                              ? 8.px
                              : chatingPageViewModal!.fontSize ==
                                      S.of(context).large
                                  ? 15.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).extraLarge
                                      ? 20.px
                                      : 12.px,
                    ),
                    SizedBox(
                      width: 10.px,
                    ),
                    (message.sender ==
                            AuthService.auth.currentUser!.phoneNumber)
                        ? (message.messageStatus == true)
                            ? chatingPageViewModal!.buildDoubleClickView()
                            : chatingPageViewModal!.buildSingleClickView()
                        : null,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildReceiverVideoView(context, MessageModel message, index) {
    chatingPageViewModal!
        .isFileDownloadedCheck(index, "VIDEO", message.message, controller!);
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.px),
            child: GestureDetector(
              onTap: () {
                chatingPageViewModal!
                    .viewFile(message.message, "VIDEO", controller!, index);
              },
              onDoubleTapDown: (details) {
                chatingPageViewModal!.showEmojiMenu(
                    context,
                    details.globalPosition,
                    chatingPageViewModal!.snapshots.docs[0]['id'],
                    message.messageId,
                    message.sender,
                    chatingPageViewModal!.arguments["isGroup"]);
                logs('showimg--> ${chatingPageViewModal!.snapshots}');
              },
              child: Container(
                width: 130.px,
                margin: EdgeInsets.all(8.px),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.px, color: AppColorConstant.darkSecondary),
                    color: AppColorConstant.darkSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(10.px))),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.px, vertical: 3.px),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle_rounded,
                              size: 12.px,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.px),
                              child: StreamBuilder(
                                stream: controller!.getUserName(message.sender
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

                                  return AppText(
                                    data.first['firstName'],
                                    fontSize: 10.px,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: AppColorConstant.appWhite,
                                    fontWeight: FontWeight.bold,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.px)),
                              color: AppColorConstant.yellowLight),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                            child: const AppImageAsset(
                              image: AppAsset.signIn,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              chatingPageViewModal!.viewFile(
                                  message.message, "VIDEO", controller!, index);
                            },
                            child: Column(
                              children: [
                                if (chatingPageViewModal!
                                        .isFileDownLoadingList[index] &&
                                    !chatingPageViewModal!
                                        .isFileDownLoadedList[index])
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: AppColorConstant.appYellow,
                                    ),
                                  )
                                else if (chatingPageViewModal!
                                    .isFileDownLoadedList[index])
                                  InkWell(
                                    onTap: () {
                                      chatingPageViewModal!.viewFile(
                                          message.message,
                                          "VIDEO",
                                          controller!,
                                          index);
                                    },
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      size: 45.px,
                                      color: AppColorConstant.appYellow,
                                    ),
                                  ),
                                if (!chatingPageViewModal!
                                        .isFileDownLoadedList[index] &&
                                    !chatingPageViewModal!
                                        .isFileDownLoadingList[index])
                                  Icon(
                                    Icons.download_for_offline_outlined,
                                    size: 45.px,
                                    color: AppColorConstant.appYellow,
                                  )
                              ],
                            )),
                      ],
                    ),
                    if (message.text!.isNotEmpty)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(4.px),
                            child: AppText(
                              message.text.toString(),
                              fontSize: chatingPageViewModal!.fontSize ==
                                      S.of(context).small
                                  ? 10.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).large
                                      ? 20.px
                                      : chatingPageViewModal!.fontSize ==
                                              S.of(context).extraLarge
                                          ? 25.px
                                          : 15.px,
                              color: AppColorConstant.appWhite,
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 13.px, top: 3.px),
            child: Row(
              children: [
                AppText(
                  message.messageTimestamp.toString(),
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: chatingPageViewModal!.fontSize ==
                          S.of(context).small
                      ? 8.px
                      : chatingPageViewModal!.fontSize == S.of(context).large
                          ? 15.px
                          : chatingPageViewModal!.fontSize ==
                                  S.of(context).extraLarge
                              ? 20.px
                              : 12.px,
                ),
                if (message.emoji != null &&
                    message.emoji!.containsKey('groupEmojis'))
                  for (var emoji in message.emoji!['groupEmojis'])
                    AppText(emoji['emoji']),
                if (message.emoji != null &&
                    message.emoji!.containsKey('receiverEmoji'))
                  GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          backgroundColor: AppColorConstant.appWhite,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          ListTile(
                            onTap: () {
                              chatingPageViewModal!.deleteEmoji(
                                  chatingPageViewModal!.snapshots.docs[0]['id'],
                                  message.messageId,
                                  message.sender,
                                  message.emoji,
                                  message.emoji);
                              Get.back();
                            },
                            leading: const CircleAvatar(
                                backgroundColor: Colors.deepOrange),
                            title: AppText(message.sender.toString(),
                                fontSize: 16),
                            trailing: AppText(
                                message.emoji!['receiverEmoji']['emoji'],
                                fontSize: 16),
                          ),
                        );
                      },
                      child: AppText(message.emoji!['receiverEmoji']['emoji'])),
                if (message.emoji != null &&
                    message.emoji!.containsKey('senderEmoji'))
                  AppText(message.emoji!['senderEmoji']['emoji']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  ===========================  docs =============================  //

  buildSenderDocumentView(context, MessageModel message, int index) {
    chatingPageViewModal!.isFileDownloadedCheck(
      index,
      "SENT/DOC",
      message.message,
      controller!,
    );
    return Align(
      alignment: Alignment.topRight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 200.px,
                margin: EdgeInsets.symmetric(horizontal: 10.px, vertical: 5.px),
                decoration: BoxDecoration(
                    color: chatingPageViewModal!.bubblColors,
                    borderRadius: BorderRadius.all(Radius.circular(10.px))),
                child: Column(
                  children: [
                    GestureDetector(
                      onTapDown: (details) async {
                        chatingPageViewModal!.viewFile(
                            message.message, "SENT/DOC", controller!, index);
                      },
                      onDoubleTapDown: (details) {
                        chatingPageViewModal!.showEmojiMenu(
                            context,
                            details.globalPosition,
                            chatingPageViewModal!.snapshots.docs[0]['id'],
                            message.messageId,
                            message.sender,
                            chatingPageViewModal!.arguments["isGroup"]);
                      },
                      child: Container(
                        width: 200.px,
                        decoration: BoxDecoration(
                            color: chatingPageViewModal!.chatBubbleColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.px))),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.px),
                              child: Row(
                                children: [
                                  AppImageAsset(
                                    image: AppAsset.pdf,
                                    height: 45.px,
                                    color: AppColorConstant.appWhite,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.px),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            "Document",
                                            color: AppColorConstant.appWhite,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: chatingPageViewModal!
                                                        .fontSize ==
                                                    S.of(context).small
                                                ? 10.px
                                                : chatingPageViewModal!
                                                            .fontSize ==
                                                        S.of(context).large
                                                    ? 20.px
                                                    : chatingPageViewModal!
                                                                .fontSize ==
                                                            S
                                                                .of(context)
                                                                .extraLarge
                                                        ? 25.px
                                                        : 15.px,
                                          ),
                                          AppText(
                                            "File",
                                            color: AppColorConstant.appWhite,
                                            fontSize: chatingPageViewModal!
                                                        .fontSize ==
                                                    S.of(context).small
                                                ? 10.px
                                                : chatingPageViewModal!
                                                            .fontSize ==
                                                        S.of(context).large
                                                    ? 20.px
                                                    : chatingPageViewModal!
                                                                .fontSize ==
                                                            S
                                                                .of(context)
                                                                .extraLarge
                                                        ? 25.px
                                                        : 15.px,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (message.text!.isNotEmpty)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(4.px),
                            child: AppText(
                              message.text.toString(),
                              fontSize: chatingPageViewModal!.fontSize ==
                                      S.of(context).small
                                  ? 10.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).large
                                      ? 20.px
                                      : chatingPageViewModal!.fontSize ==
                                              S.of(context).extraLarge
                                          ? 25.px
                                          : 15.px,
                              color: AppColorConstant.appBlack,
                            ),
                          ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 13.px, top: 3.px),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.emoji != null &&
                        message.emoji!.containsKey('groupEmojis'))
                      for (var emoji in message.emoji!['groupEmojis'])
                        AppText(emoji['emoji']),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('senderEmoji'))
                      GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              backgroundColor: AppColorConstant.appWhite,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              ListTile(
                                onTap: () {
                                  chatingPageViewModal!.deleteEmoji(
                                      chatingPageViewModal!.snapshots.docs[0]
                                          ['id'],
                                      message.messageId,
                                      message.sender,
                                      message.emoji,
                                      message.emoji);
                                  Get.back();
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.deepOrange),
                                title: AppText(message.sender.toString(),
                                    fontSize: 16),
                                trailing: AppText(
                                    message.emoji!['senderEmoji']['emoji'],
                                    fontSize: 16),
                              ),
                            );
                          },
                          child:
                              AppText(message.emoji!['senderEmoji']['emoji'])),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('receiverEmoji'))
                      AppText(message.emoji!['receiverEmoji']['emoji']),
                    AppText(
                      message.messageTimestamp.toString(),
                      color: Theme.of(context).colorScheme.primary,
                      fontSize:
                          chatingPageViewModal!.fontSize == S.of(context).small
                              ? 8.px
                              : chatingPageViewModal!.fontSize ==
                                      S.of(context).large
                                  ? 15.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).extraLarge
                                      ? 20.px
                                      : 12.px,
                    ),
                    SizedBox(
                      width: 10.px,
                    ),
                    (message.sender ==
                            AuthService.auth.currentUser!.phoneNumber)
                        ? (message.messageStatus == true)
                            ? chatingPageViewModal!.buildDoubleClickView()
                            : chatingPageViewModal!.buildSingleClickView()
                        : null,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildReceiverDocumentView(context, MessageModel message, int index) {
    chatingPageViewModal!
        .isFileDownloadedCheck(index, "DOC", message.message, controller!);
    return Align(
      alignment: Alignment.topLeft,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.px, vertical: 5.px),
                width: 200.px,
                decoration: BoxDecoration(
                    color: AppColorConstant.darkSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(10.px))),
                child: GestureDetector(
                  onTap: () async {
                    chatingPageViewModal!
                        .viewFile(message.message, "DOC", controller!, index);
                  },
                  onDoubleTapDown: (details) {
                    chatingPageViewModal!.showEmojiMenu(
                      context,
                      details.globalPosition,
                      chatingPageViewModal!.snapshots.docs[0]['id'],
                      message.messageId,
                      message.sender,
                      chatingPageViewModal!.arguments["isGroup"],
                    );
                    logs('showimg--> ${chatingPageViewModal!.snapshots}');
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.px, vertical: 3.px),
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_circle_rounded,
                                size: 12.px,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.px),
                                child: StreamBuilder(
                                  stream: controller!.getUserName(message.sender
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

                                    return AppText(
                                      data.first['firstName'],
                                      fontSize: 10.px,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      color: AppColorConstant.appWhite,
                                      fontWeight: FontWeight.bold,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 200.px,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.px)),
                            color: AppColorConstant.blackOff),
                        child: Padding(
                          padding: EdgeInsets.all(10.px),
                          child: Row(
                            children: [
                              if (chatingPageViewModal!
                                      .isFileDownLoadingList[index] &&
                                  !chatingPageViewModal!
                                      .isFileDownLoadedList[index])
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: AppColorConstant.appWhite,
                                  ),
                                ),
                              if (!chatingPageViewModal!
                                      .isFileDownLoadedList[index] &&
                                  !chatingPageViewModal!
                                      .isFileDownLoadingList[index])
                                Icon(
                                  Icons.download_for_offline_outlined,
                                  size: 45.px,
                                  color: AppColorConstant.appWhite,
                                )
                              else
                                AppImageAsset(
                                  image: AppAsset.pdf,
                                  height: 45.px,
                                  color: AppColorConstant.appWhite,
                                ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.px),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        "Document",
                                        color: AppColorConstant.appWhite,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: chatingPageViewModal!
                                                    .fontSize ==
                                                S.of(context).small
                                            ? 10.px
                                            : chatingPageViewModal!.fontSize ==
                                                    S.of(context).large
                                                ? 20.px
                                                : chatingPageViewModal!
                                                            .fontSize ==
                                                        S.of(context).extraLarge
                                                    ? 25.px
                                                    : 15.px,
                                      ),
                                      AppText(
                                        "File",
                                        color: AppColorConstant.appWhite,
                                        fontSize: chatingPageViewModal!
                                                    .fontSize ==
                                                S.of(context).small
                                            ? 10.px
                                            : chatingPageViewModal!.fontSize ==
                                                    S.of(context).large
                                                ? 20.px
                                                : chatingPageViewModal!
                                                            .fontSize ==
                                                        S.of(context).extraLarge
                                                    ? 25.px
                                                    : 15.px,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (message.text!.isNotEmpty)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(4.px),
                              child: AppText(
                                message.text.toString(),
                                fontSize: chatingPageViewModal!.fontSize ==
                                        S.of(context).small
                                    ? 10.px
                                    : chatingPageViewModal!.fontSize ==
                                            S.of(context).large
                                        ? 20.px
                                        : chatingPageViewModal!.fontSize ==
                                                S.of(context).extraLarge
                                            ? 25.px
                                            : 15.px,
                                color: AppColorConstant.appWhite,
                              ),
                            ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.px, bottom: 5.px),
                child: Row(
                  children: [
                    AppText(
                      message.messageTimestamp.toString(),
                      color: Theme.of(context).colorScheme.primary,
                      textAlign: TextAlign.start,
                      fontSize:
                          chatingPageViewModal!.fontSize == S.of(context).small
                              ? 8.px
                              : chatingPageViewModal!.fontSize ==
                                      S.of(context).large
                                  ? 15.px
                                  : chatingPageViewModal!.fontSize ==
                                          S.of(context).extraLarge
                                      ? 20.px
                                      : 12.px,
                    ),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('groupEmojis'))
                      for (var emoji in message.emoji!['groupEmojis'])
                        AppText(emoji['emoji']),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('receiverEmoji'))
                      GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              backgroundColor: AppColorConstant.appWhite,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              ListTile(
                                onTap: () {
                                  chatingPageViewModal!.deleteEmoji(
                                      chatingPageViewModal!.snapshots.docs[0]
                                          ['id'],
                                      message.messageId,
                                      message.sender,
                                      message.emoji,
                                      message.emoji);
                                  Get.back();
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.deepOrange),
                                title: AppText(message.sender.toString(),
                                    fontSize: 16),
                                trailing: AppText(
                                    message.emoji!['receiverEmoji']['emoji'],
                                    fontSize: 16),
                              ),
                            );
                          },
                          child: AppText(
                              message.emoji!['receiverEmoji']['emoji'])),
                    if (message.emoji != null &&
                        message.emoji!.containsKey('senderEmoji'))
                      AppText(message.emoji!['senderEmoji']['emoji']),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppAppBar appBar(
    ChatingPageController controller,
    context,
  ) {
    return AppAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      leadingWidth: 90.px,
      leading: Row(
        children: [
          SizedBox(width: 2.px),
          IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              goToHomeScreen();
            },
          ),
          CircleAvatar(
            maxRadius: 20.px,
            backgroundColor: AppColorConstant.appYellow.withOpacity(0.5),
            child: AppText(
              (chatingPageViewModal!.arguments['isGroup'] != false)
                  ? (chatingPageViewModal!.arguments['groupName']
                          .toString()
                          .isNotEmpty)
                      ? chatingPageViewModal!.arguments['groupName']
                          .substring(0, 1)
                          .toUpperCase()
                      : ""
                  : chatingPageViewModal!.arguments['name']
                      .substring(0, 1)
                      .toUpperCase(),
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18.px,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      title: InkWell(
        onTap: () {
          if (chatingPageViewModal!.arguments['id'] != null) {
            Get.toNamed(
              RouteHelper.getChatProfileScreen(),
              arguments: {
                'name': chatingPageViewModal!.arguments['name'],
                'number': chatingPageViewModal!.arguments['number'],
                'id': chatingPageViewModal!.arguments['id'],
                'isGroup': chatingPageViewModal!.arguments['isGroup'],
                'members': chatingPageViewModal!.arguments['members'],
                'about': chatingPageViewModal!.arguments['about'],
                'groupName': chatingPageViewModal!.arguments['groupName'],
              },
            );
          }
        },
        child: AppText(
          (chatingPageViewModal!.arguments['isGroup'])
              ? chatingPageViewModal!.arguments['groupName']
              : chatingPageViewModal!.arguments['name'],
          color: Theme.of(context).colorScheme.primary,
          fontSize: 18.px,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      actions: [
        SizedBox(
          width: 115.px,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.call_outlined,
                size: 26.px,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 10.px),
              Icon(
                Icons.video_camera_back_outlined,
                size: 26.px,
                color: Theme.of(context).colorScheme.primary,
              ),
              chatingPageViewModal!.buildNavigationMenu(context, controller),
            ],
          ),
        ),
      ],
    );
  }

  onSendMessage(message, ChatingPageController controller) async {
    chatingPageViewModal!.isFileDownLoadingList =
        chatingPageViewModal!.isFileDownLoadingList.toList();
    chatingPageViewModal!.isFileDownLoadingList.add(false);
    chatingPageViewModal!.isFileDownLoadedList =
        chatingPageViewModal!.isFileDownLoadedList.toList();
    chatingPageViewModal!.isFileDownLoadedList.add(false);

    controller.durationList = controller.durationList.toList();
    controller.durationList.add(Duration.zero);
    controller.positionList = controller.positionList.toList();
    controller.positionList.add(Duration.zero);
    controller.isPlayingList = controller.isPlayingList.toList();
    controller.isPlayingList.add(false);

    controller.update();

    logs(
        "Chatting page members ---- > ${chatingPageViewModal!.arguments['members']}");

    chatingPageViewModal!.notification(message);
    logs(
        "Chatting page members ---- > ${chatingPageViewModal!.arguments['members']}");

    chatingPageViewModal!.notification(message);
    SendMessageModel sendMessageModel = SendMessageModel(
      type: 'text',
      members: chatingPageViewModal!.arguments['members'],
      message: message,
      sender: AuthService.auth.currentUser!.phoneNumber!,
      isGroup: false,
    );

    (chatingPageViewModal!.blockedNumbers
            .contains(chatingPageViewModal!.arguments['number']))
        ? null
        : DatabaseService.instance.addNewMessage(sendMessageModel);
    logs('message---> $message');
    controller.update();
  }

  textFormField(ChatingPageController controller, BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      cursorColor: AppColorConstant.offBlack,
      onChanged: (value) {
        if (chatingPageViewModal!.chatController.text == '') {
          controller.chatingPageViewModal.iconChange = false;
          controller.update();
        } else {
          controller.chatingPageViewModal.iconChange = true;
          controller.update();
        }
      },
      decoration: InputDecoration(
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.px),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        hintText: S.of(context).signalMessage,
        suffixIcon: AppButton(
          color: AppColorConstant.appTransparent,
          height: 30.px,
          stringChild: true,
          width: 40.px,
          borderRadius: BorderRadius.circular(40.px),
          child: controller.chatingPageViewModal.iconChange
              ? const Icon(Icons.send, color: AppColorConstant.appBlack)
              : Icon(Icons.add, size: 27.px, color: AppColorConstant.appBlack),
          onTap: () {
            if (chatingPageViewModal!.chatController.text.isNotEmpty) {
              onSendMessage(
                  chatingPageViewModal!.chatController.text.trim(), controller);
              controller.update();
              chatingPageViewModal!.chatController.clear();
            }
          },
        ),
      ),
      controller: chatingPageViewModal!.chatController,
    );
  }
}
