import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/date_formation.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/generated/l10n.dart';
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

          chatingPageViewModal!.parameter = Get.parameters;
          chatingPageViewModal!.arguments = Get.arguments;

          Future.delayed(
            const Duration(milliseconds: 0),
            () async {
              controller = Get.put(ChatingPageController());

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
                                          String formattedTime = DateFormation()
                                              .getChatTimeFormate(
                                                  data[index]['timeStamp']);

                                          return buildMessage(
                                              data[index]['sender'],
                                              context,
                                              controller,
                                              data[index]['message'],
                                              formattedTime);
                                        },
                                      );
                                    }
                                    return const AppLoader();
                                  },
                                )
                              : const SizedBox(),
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
                                    child: textFormField(controller,context))),
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
                  ])));
        });
  }

  Widget buildMessage(
    String sender,
    context,
    ChatingPageController controller,
    String chatMessage,
    String timeStamp,
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
                              child: (chatingPageViewModal!
                                      .arguments['isGroup'])
                                  ? Column(
                                      children: [
                                        AppText(
                                          sender,
                                          fontSize: 10.px,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        AppText(chatMessage,
                                            color: AppColorConstant.appWhite,
                                            fontSize: getFontSizeValue(
                                                small: 10.px,
                                                large: 20.px,
                                                extraLarge: 25.px,
                                                normal: 15.px))
                                      ],
                                    )
                                  : AppText(chatMessage,
                                      color: AppColorConstant.appWhite,
                                      fontSize: getFontSizeValue(
                                          small: 10.px,
                                          large: 20.px,
                                          extraLarge: 25.px,
                                          normal: 15.px))),
                          Padding(
                              padding: EdgeInsets.only(right: 5.px, top: 3.px),
                              child: AppText(timeStamp.toString(),
                                  color: Theme.of(context).colorScheme.primary,
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
                              child: (chatingPageViewModal!
                                      .arguments['isGroup'])
                                  ? Column(
                                      children: [
                                        AppText(
                                          sender,
                                          fontSize: 10.px,
                                        ),
                                        AppText(chatMessage,
                                            color: AppColorConstant.appBlack,
                                            fontSize: getFontSizeValue(
                                                small: 10.px,
                                                large: 20.px,
                                                extraLarge: 25.px,
                                                normal: 15.px))
                                      ],
                                    )
                                  : AppText(chatMessage,
                                      color: AppColorConstant.appWhite,
                                      fontSize: getFontSizeValue(
                                          small: 10.px,
                                          large: 20.px,
                                          extraLarge: 25.px,
                                          normal: 15.px))),
                          Padding(
                              padding: EdgeInsets.only(left: 5.px, top: 3.px),
                              child: AppText(timeStamp.toString(),
                                  color: Theme.of(context).colorScheme.primary,
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
        backgroundColor: Theme.of(context).colorScheme.background,
        leadingWidth: 90.px,
        leading: Row(children: [
          SizedBox(width: 2.px),
          IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 30.px,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Get.to(HomeScreen());
              }),
          CircleAvatar(
            maxRadius: 20.px,
            backgroundColor: AppColorConstant.appYellow.withOpacity(0.5),
            child: AppText(
              (chatingPageViewModal!.arguments['isGroup'] != false)
                  ? chatingPageViewModal!.arguments['groupName']
                      .substring(0, 1)
                      .toUpperCase()
                  : chatingPageViewModal!.arguments['members'][0]
                      .substring(0, 1)
                      .toUpperCase(),
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18.px,
              fontWeight: FontWeight.w800,
            ),
          )
        ]),
        title: InkWell(
          onTap: () {
            if (chatingPageViewModal!.arguments['id'] != null ||
                chatingPageViewModal!.arguments['groupName']) {
              Get.toNamed(RouteHelper.getChatProfileScreen(), arguments: {
                'members': chatingPageViewModal!.arguments['members'],
                'id' : chatingPageViewModal!.arguments['id'],
                'isGroup' : false,
              });
            }
          },
          child: AppText(
              (chatingPageViewModal!.arguments['isGroup'])
                  ? chatingPageViewModal!.arguments['groupName']
                  : chatingPageViewModal!.arguments['members'][0],
              color: Theme.of(context).colorScheme.primary,
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
                    Icon(
                      Icons.video_camera_back_outlined,
                      size: 26.px,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Icon(
                      Icons.call_outlined,
                      size: 26.px,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    PopupMenuButton(
                        onSelected: (value) {
                          Get.toNamed(value);
                        },
                        itemBuilder: (context) {
                          return controller.chatingPageViewModal.popupMenu;
                        },
                        icon: Icon(Icons.more_vert,
                            color: Theme.of(context).colorScheme.primary,
                            size: 26.px))
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

  TextFormField textFormField(ChatingPageController controller,BuildContext context) {
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
            hintText: S.of(context).signalMessage,
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
