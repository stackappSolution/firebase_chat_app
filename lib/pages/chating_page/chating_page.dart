import 'dart:io';
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
import 'package:signal/app/app/utills/shared_preferences.dart';
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
import 'package:signal/pages/home/home_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_service.dart';
import 'package:signal/service/users_service.dart';
import '../../controller/chating_page_controller.dart';
import '../../modal/send_message_model.dart';

// ignore: must_be_immutable
class ChatingPage extends StatelessWidget {
  ChatingPage({super.key});

  ChatingPageViewModal? chatingPageViewModal;
  static String date = '';
  ChatingPageController? controller;
  Stream<QuerySnapshot>? chats;

  getBlockedList() async {
    chatingPageViewModal!.blockedNumbers =
        await UsersService.instance.getBlockedUsers();
    logs('list-------------> ${chatingPageViewModal!.blockedNumbers}');
  }

  @override
  Widget build(BuildContext context) {
    chatingPageViewModal ?? (chatingPageViewModal = ChatingPageViewModal(this));

    getBlockedList();

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

            chatingPageViewModal!.isBlocked = await UsersService.instance
                .isBlockedByLoggedInUser(
                    chatingPageViewModal!.arguments['number']);
            logs('blocked----------> ${chatingPageViewModal!.isBlocked}');

            final snapshots = await FirebaseFirestore.instance
                .collection('rooms')
                .where('members',
                    isEqualTo: chatingPageViewModal!.arguments['members'])
                .get();

            chats = DatabaseService.instance.getChatStream(
              snapshots.docs.first.id,
            );

            chatingPageViewModal!.snapshots = await DatabaseService.instance
                .getChatDoc(chatingPageViewModal!.arguments['members']);

            DatabaseService.instance.markMessagesAsSeen(snapshots.docs.first.id,
                chatingPageViewModal!.arguments['number']);
            Future<String?> key = getStringValue(wallPaperColor);
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
        return Scaffold(
          appBar: appBar(controller, context),
          body: Container(
            decoration: BoxDecoration(
                image: (chatingPageViewModal!.wallpaperPath != null)
                    ? DecorationImage(
                        image: FileImage(
                            File(chatingPageViewModal!.wallpaperPath!)))
                    : null,
                color: (chatingPageViewModal!.wallpaperPath != null)
                    ? chatingPageViewModal!.wallpaperColor
                    : Colors.transparent),
            child: Column(
              children: [
                (chatingPageViewModal!.arguments['isGroup'])
                    ? Container(
                        padding: EdgeInsets.all(8.px),
                        margin: EdgeInsets.all(8.px),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.px),
                              color:
                                  AppColorConstant.appWhite.withOpacity(0.3)),
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: chats,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return AppText(S.of(context).somethingWentWrong);
                      }
                      if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        logs('data----> ${data.length}');
                        final message = snapshot.data!.docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .toList();

                        DatabaseService.instance.markMessagesAsSeen(
                            chatingPageViewModal!.snapshots.docs.first.id,
                            chatingPageViewModal!.arguments['number']);

                        return GroupedListView(
                          itemBuilder: (context, element) {
                            String formattedTime = DateFormation()
                                .getChatTimeFormate(
                                    element['messageTimestamp']);

                            DateTime dateTime = DateFormation()
                                .getDatetime(element['messageTimestamp']);

                            chatingPageViewModal!.messageTimeStamp
                                .add(dateTime);

                            return buildMessage(
                                MessageModel(
                                    messageStatus: element['messageStatus'],
                                    message: element['message'],
                                    isSender: element['isSender'],
                                    messageTimestamp: formattedTime,
                                    messageType: element['messageType'],
                                    sender: element['sender']),
                                context,
                                controller);
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
                              return DateFormat('MMM d, y').format(dateTime);
                            }

                            int timestamp = element['messageTimestamp'];
                            DateTime date =
                                DateTime.fromMillisecondsSinceEpoch(timestamp);
                            return formatDate(date);
                          },
                          groupHeaderBuilder: (value) {
                            var timestamp = value['messageTimestamp'];
                            String formatDate =
                                DateFormation().headerTimestamp(timestamp);
                            return Container(
                              margin: EdgeInsets.all(15.px),
                              alignment: Alignment.center,
                              height: 25.px,
                              child: Container(
                                padding: EdgeInsets.all(5.px),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.px),
                                  color:
                                      AppColorConstant.appGrey.withOpacity(0.3),
                                ),
                                alignment: Alignment.center,
                                height: 25.px,
                                width: 100.px,
                                child: Text(
                                  formatDate,
                                  style: const TextStyle(
                                    color: AppColorConstant.appBlack,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const AppLoader();
                    },
                  ),
                ),
                (chatingPageViewModal!.isBlocked)
                    ? buildBlockView(context)
                    : (chatingPageViewModal!.blockedNumbers.contains(
                            chatingPageViewModal!.arguments['number']))
                        ? buildUnblockView(context, controller)
                        : buildTextFormField(context, controller),
              ],
            ),
          ),
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
    return Row(
      children: [
        chatingPageViewModal!.buildPopupMenu(context),
        Expanded(
            child: Container(
                margin: EdgeInsets.only(right: 15.px, bottom: 5.px, top: 5.px),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(35.px)),
                height: 40.px,
                child: textFormField(controller, context))),
      ],
    );
  }

  buildVideoView(MessageModel messageModel) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppImageAsset(
            image: AppAsset.signIn,
            fit: BoxFit.fill,
            height: 200,
            width: 150,
          ),
        ),
        InkWell(
            onTap: () {
              Get.toNamed(RouteHelper.getVideoPlayerScreen(), arguments: {
                'receiverName': chatingPageViewModal!.arguments['name'],
                'videoUrl': messageModel.message
              });
            },
            child: const SizedBox(
                height: 30,
                width: 30,
                child: AppImageAsset(
                  image: AppAsset.play,
                  color: AppColorConstant.appBlack,
                )))
      ],
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
              const AppText(
                'cancel',
                color: AppColorConstant.appYellow,
              ),
              AppButton(
                onTap: () {
                  chatingPageViewModal!.blockedNumbers
                      .remove(chatingPageViewModal!.arguments['number']);
                  UsersService.instance
                      .unblockUser(chatingPageViewModal!.arguments['number']);
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
      ChatingPageController controller) {
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
                      ? buildSenderImageView(message, context)
                      : (message.messageType == 'audio')
                          ? buildSenderAudioView(controller, context, message)
                          : buildVideoView(message)))
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
                              ? chatingPageViewModal!.arguments['groupName']
                                  .substring(0, 1)
                                  .toUpperCase()
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
                      ? buildReceiverImageView(message, context)
                      : (message.messageType == 'audio')
                          ? buildReceiverAudioView(context, controller, message)
                          : buildVideoView(message),
            )),
    );
  }

  buildReceiverMessageView(BuildContext context, MessageModel message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatBubble(
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
                    children: [
                      AppText(
                        message.sender.toString(),
                        fontSize: 10.px,
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
                    fontSize: chatingPageViewModal!.fontSize ==
                            S.of(context).small
                        ? 10.px
                        : chatingPageViewModal!.fontSize == S.of(context).large
                            ? 20.px
                            : chatingPageViewModal!.fontSize ==
                                    S.of(context).extraLarge
                                ? 25.px
                                : 15.px,
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.px, top: 3.px),
            child: AppText(
              message.messageTimestamp.toString(),
              color: Theme.of(context).colorScheme.primary,
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
        ],
      ),
    );
  }

  buildReceiverImageView(MessageModel message, BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(RouteHelper.getImageViewScreen(), arguments: {
                'image': message.message,
                'name': chatingPageViewModal!.arguments['name']
              });
            },
            child: Container(
              margin: EdgeInsets.all(10.px),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColorConstant.appYellow,
                ),
                borderRadius: BorderRadius.circular(12.px),
              ),
              height: 200.px,
              width: 150.px,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.px),
                child: AppImageAsset(image: message.message),
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

  buildSenderAudioView(ChatingPageController controller, BuildContext context,
      MessageModel message) {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 265.px,
            margin: EdgeInsets.all(8.px),
            height: 45.px,
            decoration: BoxDecoration(
                color: chatingPageViewModal!.chatBubbleColor,
                borderRadius: BorderRadius.circular(12.px)),
            child: Row(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColorConstant.appWhite,
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8.px, disabledThumbRadius: 8.px),
                  ),
                  child: SizedBox(
                    width: 150.px,
                    child: Slider(
                      activeColor: AppColorConstant.appWhite,
                      min: 0,
                      max: controller.duration.inSeconds.toDouble(),
                      value: controller.position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        controller.position = Duration(seconds: value.toInt());
                        await controller.player.seek(controller.position);
                        //await controller.player.resume();
                      },
                    ),
                  ),
                ),
                AppText(
                  DateFormation().formatTime(controller.position),
                  color: AppColorConstant.appWhite,
                ),
                IconButton(
                    onPressed: () async {
                      if (controller.isPlay.value) {
                        await controller.player.pause();
                      } else {
                        await controller.player
                            .setUrl(message.message.toString());
                        await controller.player.play();
                      }
                    },
                    icon: (controller.isPlay.value)
                        ? const Icon(
                            Icons.pause_circle,
                            color: AppColorConstant.appWhite,
                          )
                        : const Icon(Icons.play_circle,
                            color: AppColorConstant.appWhite)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
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

  buildSenderImageView(MessageModel message, BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
          onTap: () {
            Get.toNamed(RouteHelper.getImageViewScreen(), arguments: {
              'image': message.message,
              'name': chatingPageViewModal!.arguments['name']
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.all(10.px),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColorConstant.appYellow,
                  ),
                  borderRadius: BorderRadius.circular(12.px),
                ),
                height: 200.px,
                width: 150.px,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.px),
                    child: AppImageAsset(image: message.message)),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.px),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
          )),
    );
  }

  buildSenderMessageView(BuildContext context, MessageModel message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ChatBubble(
            elevation: 0,
            margin: EdgeInsets.only(left: 80.px),
            clipper: ChatBubbleClipper2(
                type: BubbleType.sendBubble,
                nipHeight: 10.px,
                nipWidth: 6.px,
                radius: 5.px),
            alignment: Alignment.topRight,
            backGroundColor: chatingPageViewModal!.chatBubbleColor,
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
          Padding(
            padding: EdgeInsets.only(right: 5.px, top: 3.px),
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

  buildReceiverAudioView(BuildContext context, ChatingPageController controller,
      MessageModel message) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 265.px,
            margin: EdgeInsets.all(8.px),
            height: 45.px,
            decoration: BoxDecoration(
                color: AppColorConstant.appGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.px)),
            child: Row(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColorConstant.appBlack,
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8.px, disabledThumbRadius: 8.px),
                  ),
                  child: SizedBox(
                    width: 150.px,
                    child: Slider(
                      activeColor: AppColorConstant.appBlack,
                      min: 0,
                      max: controller.duration.inSeconds.toDouble(),
                      value: controller.position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        controller.position = Duration(seconds: value.toInt());
                        await controller.player.seek(controller.position);
                        //await controller.player.resume();
                      },
                    ),
                  ),
                ),
                AppText(
                  DateFormation().formatTime(controller.position),
                  color: AppColorConstant.appBlack,
                ),
                IconButton(
                    onPressed: () async {
                      if (controller.isPlay.value) {
                        await controller.player.pause();
                      } else {
                        await controller.player
                            .setUrl(message.message.toString());
                        await controller.player.play();
                        controller.update();
                        logs('url--------> ${message.message}');
                      }
                    },
                    icon: (controller.isPlay.value)
                        ? const Icon(
                            Icons.pause_circle,
                            color: AppColorConstant.appBlack,
                          )
                        : const Icon(Icons.play_circle,
                            color: AppColorConstant.appBlack)),
              ],
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
              Get.to(HomeScreen());
            },
          ),
          CircleAvatar(
            maxRadius: 20.px,
            backgroundColor: AppColorConstant.appYellow.withOpacity(0.5),
            child: AppText(
              (chatingPageViewModal!.arguments['isGroup'] != false)
                  ? chatingPageViewModal!.arguments['groupName']
                      .substring(0, 1)
                      .toUpperCase()
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
              chatingPageViewModal!.buildNavigationMenu(context),
            ],
          ),
        ),
      ],
    );
  }

  onSendMessage(message, ChatingPageController controller) async {
    SendMessageModel sendMessageModel = SendMessageModel(
        type: 'text',
        members: chatingPageViewModal!.arguments['members'],
        message: message,
        sender: AuthService.auth.currentUser!.phoneNumber!,
        isGroup: false);

    (chatingPageViewModal!.blockedNumbers
            .contains(chatingPageViewModal!.arguments['number']))
        ? null
        : DatabaseService.instance.addNewMessage(sendMessageModel :sendMessageModel);
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
                  chatingPageViewModal!.chatController.text, controller);
              controller.update();
              chatingPageViewModal!.chatController.clear();
            }
          },
        ),
      ),
      controller: chatingPageViewModal!.chatController,
    );
  }

  AppButton micButton() {
    return AppButton(
      onTap: () {},
      margin: EdgeInsets.only(left: 3.px),
      width: 27.px,
      height: 27.px,
      color: Colors.transparent,
      stringChild: true,
      borderRadius: BorderRadius.circular(27.px),
      child: Icon(
        Icons.mic,
        size: 27.px,
        color: AppColorConstant.offBlack,
      ),
    );
  }
}
