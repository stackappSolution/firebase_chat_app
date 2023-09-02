import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/pages/chating_page/chating_page_view_modal.dart';

import 'package:signal/pages/home/home_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_service.dart';

import '../../controller/chating_page_controller.dart';

// ignore: must_be_immutable
class ChatingPage extends StatelessWidget {
  ChatingPage({super.key});

  ChatingPageViewModal? chatingPageViewModal;
  static String date = '';
  static String? fontSize;
  Stream<QuerySnapshot>? chats;
  ChatingPageController? controller;

  @override
  Widget build(BuildContext context) {
    chatingPageViewModal ?? (chatingPageViewModal = ChatingPageViewModal(this));
    fontSize = '${chatingPageViewModal!.fontSizeInitState()}';

    return GetBuilder<ChatingPageController>(
        initState: (state) async {
          Future.delayed(
            const Duration(milliseconds: 0),
            () async {
              controller = Get.find<ChatingPageController>();
              chatingPageViewModal!.parameter = Get.parameters;

              chatingPageViewModal!.arguments = Get.arguments;
              logs('arg--> ${chatingPageViewModal!.arguments}');

              final snapshots = await FirebaseFirestore.instance
                  .collection('rooms')
                  .where('members',
                      isEqualTo: chatingPageViewModal!.arguments['members'])
                  .get();

              logs(snapshots.docs.first.id);
              logs('auth----> ${AuthService.auth.currentUser!.phoneNumber!}');

              chats = DatabaseService().getChatStream(
                snapshots.docs.first.id,
              );

              Future<String?> key = getStringValue('wallpaper');
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
                  child: Column(children: [
                    Expanded(
                      child:
                          (chatingPageViewModal!.arguments['isGroup'] != null)
                              ? StreamBuilder<QuerySnapshot>(
                                  stream: chats,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }
                                    if (snapshot.hasData) {
                                      final data = snapshot.data?.docs;

                                      logs('data----> ${data!.length}');

                                      return ListView.builder(
                                        itemCount: snapshot.data?.docs.length,
                                        itemBuilder: (context, index) {
                                          return buildMessage(
                                              data[index]['sender'],
                                              context,
                                              controller,
                                              data[index]['message'],
                                              data[index]['timeStamp']);
                                        },
                                      );
                                    }
                                    return const AppLoader();
                                  },
                                )
                              : const SizedBox(),
                      // : buildInviteView(
                      //     chatingPageViewModal!.parameter['firstLetter'],
                      //     chatingPageViewModal!.parameter['displayName'],
                      //     chatingPageViewModal!.parameter['phoneNo'])
                    ),
                    (chatingPageViewModal!.arguments['isGroup'] != null)
                        ? Row(children: [
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        right: 15.px,
                                        left: 15.px,
                                        bottom: 5.px,
                                        top: 5.px),
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(35.px)),
                                    height: 40.px,
                                    child: textFormField(controller))),
                            AppButton(
                                margin: EdgeInsets.only(right: 15.px),
                                height: 40.px,
                                color: AppColorConstant.appWhite,
                                stringChild: true,
                                width: 40.px,
                                borderRadius: BorderRadius.circular(40.px),
                                child:
                                    controller.chatingPageViewModal.iconChange
                                        ? const Icon(Icons.send,
                                            color: AppColorConstant.appBlack)
                                        : Icon(Icons.add,
                                            size: 27.px,
                                            color: AppColorConstant.appBlack),
                                onTap: () {
                                  if (chatingPageViewModal!
                                      .chatController.text.isNotEmpty) {
                                    onSendMessage(chatingPageViewModal!
                                        .chatController.text);
                                    controller.update();
                                    chatingPageViewModal!.chatController
                                        .clear();
                                  }
                                }),
                          ])
                        : const SizedBox(),

                    // Column(
                    //         children: [
                    //           AppText(
                    //             'Invite ${chatingPageViewModal!.parameter['members'][0]} to Signal to keep Conversation here',
                    //             textAlign: TextAlign.center,
                    //             color: AppColorConstant.appGrey,
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.all(20.px),
                    //             child: AppButton(
                    //                 onTap: () async {
                    //                   chatingPageViewModal!.inviteFriends();
                    //                 },
                    //                 borderRadius: BorderRadius.circular(18.px),
                    //                 height: 40.px,
                    //                 width: 180.px,
                    //                 color: AppColorConstant.appYellow,
                    //                 stringChild: true,
                    //                 child: const AppText("Invite To signal",
                    //                     color: AppColorConstant.appWhite)),
                    //           ),
                    //         ],
                    //       )
                  ])));
        });
  }

  getNumbers() {
    chatingPageViewModal!.mobileNumbers =
        chatingPageViewModal!.getMobileNumbers() as List<String>;
    logs('phones----> ${chatingPageViewModal!.mobileNumbers}');
  }

  Widget buildMessage(
    String sender,
    context,
    ChatingPageController controller,
    String chatMessage,
    int timeStamp,
  ) {
    return Slidable(
        child: (sender == AuthService.auth.currentUser!.phoneNumber!)
            ? (Slidable(
                endActionPane: ActionPane(
                    extentRatio: fontSize == StringConstant.small
                        ? 0.115.px
                        : fontSize == StringConstant.large
                            ? 0.15.px
                            : fontSize == StringConstant.extraLarge
                                ? 0.189.px
                                : 0.13.px,
                    motion: const ScrollMotion(),
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 10.px),
                              child: CircleAvatar(
                                  radius: getFontSizeValue(
                                      small: 15.px,
                                      large: 22.px,
                                      extraLarge: 28.px,
                                      normal: 18.px),
                                  backgroundColor: AppColorConstant.appYellow)))
                    ]),
                child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
                    alignment: Alignment.centerRight,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ChatBubble(
                              elevation: 0,
                              margin: EdgeInsets.only(left: 100.px),
                              clipper: ChatBubbleClipper2(
                                  type: BubbleType.sendBubble,
                                  nipHeight: 10.px,
                                  nipWidth: 6.px,
                                  radius: 5.px),
                              alignment: Alignment.topRight,
                              backGroundColor:
                                  chatingPageViewModal!.chatBubbleColor,
                              child: AppText(chatMessage,
                                  color: AppColorConstant.appWhite,
                                  fontSize: getFontSizeValue(
                                      small: 10.px,
                                      large: 20.px,
                                      extraLarge: 25.px,
                                      normal: 15.px))),
                          Padding(
                              padding: EdgeInsets.only(right: 5.px, top: 3.px),
                              child: AppText(timeStamp.toString(),
                                  color: AppColorConstant.appBlack,
                                  fontSize: getFontSizeValue(
                                      small: 8.px,
                                      large: 15.px,
                                      extraLarge: 20.px,
                                      normal: 12.px)))
                        ]))))
            : (Slidable(
                startActionPane: ActionPane(
                    extentRatio: fontSize == StringConstant.small
                        ? 0.115.px
                        : fontSize == StringConstant.large
                            ? 0.15.px
                            : fontSize == StringConstant.extraLarge
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
                                  radius: getFontSizeValue(
                                      small: 15.px,
                                      large: 22.px,
                                      extraLarge: 28.px,
                                      normal: 18.px),
                                  backgroundColor:
                                      chatingPageViewModal!.chatBubbleColor)))
                    ]),
                child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
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
                              backGroundColor:
                                  AppColorConstant.appGrey.withOpacity(0.3),
                              child: AppText(chatMessage,
                                  fontSize: getFontSizeValue(
                                      small: 10.px,
                                      large: 20.px,
                                      extraLarge: 25.px,
                                      normal: 15.px))),
                          Padding(
                              padding: EdgeInsets.only(left: 5.px, top: 3.px),
                              child: AppText(timeStamp.toString(),
                                  color: AppColorConstant.appBlack,
                                  fontSize: getFontSizeValue(
                                      small: 8.px,
                                      large: 15.px,
                                      extraLarge: 20.px,
                                      normal: 12.px)))
                        ])))));
  }

  AppAppBar appBar(
    ChatingPageController controller,
    context,
  ) {
    return AppAppBar(
        backgroundColor: AppColorConstant.appTransparent,
        leadingWidth: 90.px,
        leading: Row(children: [
          SizedBox(width: 2.px),
          IconButton(
              icon: Icon(Icons.arrow_back_rounded,
                  size: 30.px, color: AppColorConstant.offBlack),
              onPressed: () {
                Get.to(HomeScreen());
              }),
          CircleAvatar(
            // backgroundImage:
            //     NetworkImage(chatingPageViewModal!.parameter['photoUrl'] ?? ''),
            maxRadius: 20.px,
            backgroundColor: AppColorConstant.appYellow.withOpacity(0.5),
            child: AppText(
              (chatingPageViewModal!.arguments['isGroup'] != false)
                  ? chatingPageViewModal!.arguments['groupName']
                      .substring(0, 1)
                      .toUpperCase()
                  : chatingPageViewModal!.arguments['id']
                      .substring(0, 1)
                      .toUpperCase(),
              color: AppColorConstant.appWhite,
              fontSize: 18.px,
              fontWeight: FontWeight.w800,
            ),
          )
        ]),
        title: InkWell(
          onTap: () {
            if (chatingPageViewModal!.arguments['id'] != null ||
                chatingPageViewModal!.arguments['groupName']) {
              Get.toNamed(RouteHelper.getChatProfileScreen());
            }
          },
          child: AppText(
              (chatingPageViewModal!.arguments['isGroup'])
                  ? chatingPageViewModal!.arguments['groupName']
                  : chatingPageViewModal!.arguments['id'],
              fontSize: 18.px,
              overflow: TextOverflow.ellipsis),
        ),
        actions: [
          SizedBox(
              width: 125.px,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppButton(
                        onTap: () {},
                        width: 26.px,
                        height: 26.px,
                        color: Colors.transparent,
                        stringChild: true,
                        borderRadius: BorderRadius.circular(35.px),
                        child: Icon(Icons.video_camera_back_outlined,
                            size: 26.px, color: AppColorConstant.offBlack)),
                    AppButton(
                        margin: EdgeInsets.only(left: 12.px),
                        onTap: () {},
                        width: 26.px,
                        height: 26.px,
                        color: Colors.transparent,
                        stringChild: true,
                        borderRadius: BorderRadius.circular(26.px),
                        child: Icon(Icons.call_outlined,
                            size: 26.px, color: AppColorConstant.offBlack)),
                    PopupMenuButton(
                        onSelected: (value) {
                          Get.toNamed(value);
                        },
                        itemBuilder: (context) {
                          return controller.chatingPageViewModal.popupMenu;
                        },
                        icon: Icon(Icons.more_vert,
                            color: AppColorConstant.offBlack, size: 26.px))
                  ]))
        ]);
  }

  onSendMessage(message) async {
    DatabaseService().addNewMessage(
        members: chatingPageViewModal!.arguments['members'],
        massage: message,
        sender: AuthService.auth.currentUser!.phoneNumber!,
        isGroup: false);
    logs('message---> $message');

    controller!.update();
  }

  TextFormField textFormField(ChatingPageController controller) {
    return TextFormField(
        style: const TextStyle(color: AppColorConstant.appBlack),
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
            contentPadding: EdgeInsets.all(2.px),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            prefixIcon: AppButton(
                onTap: () {},
                margin: EdgeInsets.only(left: 3.px),
                width: 27.px,
                height: 27.px,
                color: Colors.transparent,
                stringChild: true,
                borderRadius: BorderRadius.circular(27.px),
                child: Icon(Icons.mood,
                    size: 27.px, color: AppColorConstant.offBlack)),
            hintText: StringConstant.signalMessage,
            suffixIcon: SizedBox(
                height: 40.px,
                width: 78.px,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [cameraButton(), micButton()]))),
        controller: chatingPageViewModal!.chatController);
  }

  AppButton emojiButton() {
    return AppButton(
        onTap: () {},
        margin: EdgeInsets.only(left: 3.px),
        width: 27.px,
        height: 27.px,
        color: Colors.transparent,
        stringChild: true,
        borderRadius: BorderRadius.circular(27.px),
        child: Icon(Icons.mood, size: 27.px, color: AppColorConstant.offBlack));
  }

  AppButton cameraButton() {
    return AppButton(
        onTap: () {},
        margin: EdgeInsets.only(right: 10.px),
        width: 27.px,
        height: 27.px,
        color: Colors.transparent,
        stringChild: true,
        borderRadius: BorderRadius.circular(27.px),
        child: Icon(Icons.camera_alt_outlined,
            size: 27.px, color: AppColorConstant.offBlack));
  }

  AppButton micButton() {
    return AppButton(
        onTap: () async {},
        margin: EdgeInsets.only(right: 10.px),
        width: 27.px,
        height: 27.px,
        color: Colors.transparent,
        stringChild: true,
        borderRadius: BorderRadius.circular(27.px),
        child: Icon(Icons.mic_none_outlined,
            size: 27.px, color: AppColorConstant.offBlack));
  }

  buildInviteView(
    String firstLetter,
    String displayName,
    String phoneNo,
  ) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ListView(
        children: [
          SizedBox(
            height: 30.px,
          ),
          CircleAvatar(
            maxRadius: 50.px,
            backgroundColor: AppColorConstant.appYellow.withOpacity(0.5),
            child: AppText(firstLetter,
                fontSize: 40.px, color: AppColorConstant.appWhite),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.px),
            child: AppText(
              displayName,
              fontSize: 20.px,
              textAlign: TextAlign.center,
            ),
          ),
          AppText(phoneNo,
              fontSize: 12.px,
              textAlign: TextAlign.center,
              color: AppColorConstant.appGrey),
        ],
      ),
    );
  }

  double? getFontSizeValue(
      {required double small,
      required double large,
      required double extraLarge,
      required double normal}) {
    switch (ChatingPage.fontSize) {
      case StringConstant.small:
        return small;
      case StringConstant.large:
        return large;
      case StringConstant.extraLarge:
        return extraLarge;
      case StringConstant.normal:
        return normal;
      default:
        return normal;
    }
  }
}
