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
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/modal/message.dart';
import 'package:signal/pages/chating_page/chating_page_view_modal.dart';
import 'package:signal/pages/home/home_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_service.dart';
import 'package:signal/service/users_service.dart';
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
    fontSize = '${chatingPageViewModal!.fontSizeInitState}';
    logs('fontSize-----------> $fontSize');
    getBlockedList();

    return GetBuilder<ChatingPageController>(
        initState: (state) async {
          chatingPageViewModal!.parameter = Get.parameters;
          chatingPageViewModal!.arguments = Get.arguments;

          Future.delayed(
            const Duration(milliseconds: 0),
                () async {
              controller = Get.find<ChatingPageController>();
              logs('arg--> ${chatingPageViewModal!.arguments}');

              chatingPageViewModal!.isBlocked = await UsersService()
                  .isBlockedByLoggedInUser(
                  chatingPageViewModal!.arguments['number']);
              logs('blocked----------> ${chatingPageViewModal!.isBlocked}');

              final snapshots = await FirebaseFirestore.instance
                  .collection('rooms')
                  .where('members',
                  isEqualTo: chatingPageViewModal!.arguments['members'])
                  .get();

              chats = DatabaseService().getChatStream(
                snapshots.docs.first.id,
              );
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
                  child: Column(children: [
                    (chatingPageViewModal!.arguments['isGroup'])
                        ? Container(
                      padding: EdgeInsets.all(8.px),
                      margin: EdgeInsets.all(8.px),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.px),
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
                              return GroupedListView(
                                itemBuilder: (context, element) {

                                  String formattedTime= DateFormation().getChatTimeFormate(element['messageTimestamp']);

                                  DateTime dateTime = DateFormation()
                                      .getDatetime(element['messageTimestamp']);

                                  chatingPageViewModal!.messageTimeStamp
                                      .add(dateTime);

                                  return buildMessage(
                                      Message(
                                          message: element['message'],
                                          isSender: element['isSender'],
                                          messageTimestamp: formattedTime,
                                          messageType: element['messageType'],
                                          sender: element['sender']),
                                      context,
                                      controller);
                                },
                                reverse: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                order: GroupedListOrder.DESC,
                                useStickyGroupSeparators: true,
                                floatingHeader: true,
                                elements: message,
                                groupBy: (element) {
                                  String formatDate(DateTime dateTime) {
                                    return DateFormat('MMM d, y').format(dateTime);
                                  }
                                  var timestamp = element['messageTimestamp'];
                                  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                                  return formatDate(date);
                                },
                                groupHeaderBuilder: (value) {
                                  var timestamp = value['messageTimestamp'];
                                  String formatDate =DateFormation().headerTimestamp(timestamp);
                                  return Container(
                                      margin: EdgeInsets.only(top: 5.px),
                                      alignment: Alignment.center,
                                      height: 25.px,
                                      child: Container(
                                          padding: EdgeInsets.all(5.px),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(5.px),
                                              color: AppColorConstant.appGrey.withOpacity(0.1)),
                                          alignment: Alignment.center,
                                          height: 25.px,
                                          width: 100.px,
                                          child: Text(
                                              formatDate,
                                              style: const TextStyle(
                                                  color:
                                                  AppColorConstant.appBlack))));
                                },
                              );
                            }
                            return const AppLoader();
                          },
                        )),
                    (chatingPageViewModal!.isBlocked)
                        ? buildBlockView(context)
                        : (chatingPageViewModal!.blockedNumbers.contains(
                        chatingPageViewModal!.arguments['number']))
                        ? buildUnblockView(context)
                        : buildTextFormField(context, controller)
                  ])));
        });
  }

  getBlockedList() async {
    chatingPageViewModal!.blockedNumbers =
    await UsersService().getBlockedUsers();
    logs('list-------------> ${chatingPageViewModal!.blockedNumbers}');
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
        ));
  }

  buildTextFormField(BuildContext context, ChatingPageController controller) {
    return Row(children: [
      chatingPageViewModal!.buildPopupMenu(context),
      Expanded(
          child: Container(
              margin: EdgeInsets.only(right: 15.px, bottom: 5.px, top: 5.px),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(35.px)),
              height: 40.px,
              child: textFormField(controller, context))),
    ]);
  }

  buildUnblockView(BuildContext context) {
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
                  UsersService()
                      .unblockUser(chatingPageViewModal!.arguments['number']);
                  controller!.update();
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

  Widget buildMessage(
      Message message, BuildContext context, ChatingPageController controller) {






    return Slidable(
        child: (message.sender == AuthService.auth.currentUser!.phoneNumber)
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
                              backgroundColor:  chatingPageViewModal!.chatBubbleColor,)))
                ]),
            child: (message.messageType == 'text')
                ? Container(
                margin: EdgeInsets.symmetric(
                    vertical: 4.px, horizontal: 8.px),
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
                          child: AppText(message.message,
                              color: AppColorConstant.appWhite,
                              fontSize: getFontSizeValue(
                                  small: 10.px,
                                  large: 20.px,
                                  extraLarge: 25.px,
                                  normal: 15.px))),
                      Padding(
                          padding:
                          EdgeInsets.only(right: 5.px, top: 3.px),
                          child: AppText(
                              message.messageTimestamp.toString(),
                              color:
                              Theme.of(context).colorScheme.primary,
                              fontSize: getFontSizeValue(
                                  small: 8.px,
                                  large: 15.px,
                                  extraLarge: 20.px,
                                  normal: 12.px)))
                    ]))
                : Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getImageViewScreen(),
                      arguments: {
                        'image': message.message,
                        'name':
                        chatingPageViewModal!.arguments['name']
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
                      child: AppImageAsset(image: message.message)),
                ),
              ),
            )))
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
                          child:  CircleAvatar(
                            radius: getFontSizeValue(
                                small: 15.px,
                                large: 22.px,
                                extraLarge: 28.px,
                                normal: 18.px),
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
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18.px,
                              fontWeight: FontWeight.w500,
                            ),
                          )))
                ]),
            child: (message.messageType == 'text')
                ? Container(
                margin: EdgeInsets.symmetric(
                    vertical: 4.px, horizontal: 8.px),
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
                                message.sender,
                                fontSize: 10.px,
                              ),
                              AppText(message.message,
                                  color:
                                  AppColorConstant.appBlack,
                                  fontSize: getFontSizeValue(
                                      small: 10.px,
                                      large: 20.px,
                                      extraLarge: 25.px,
                                      normal: 15.px))
                            ],
                          )
                              : AppText(message.message,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: getFontSizeValue(
                                  small: 10.px,
                                  large: 20.px,
                                  extraLarge: 25.px,
                                  normal: 15.px))),
                      Padding(
                          padding:
                          EdgeInsets.only(left: 5.px, top: 3.px),
                          child: AppText(
                              message.messageTimestamp.toString(),
                              color:
                              Theme.of(context).colorScheme.primary,
                              fontSize: getFontSizeValue(
                                  small: 8.px,
                                  large: 15.px,
                                  extraLarge: 20.px,
                                  normal: 12.px)))
                    ]))
                : Align(
              alignment: Alignment.topLeft,
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
                    child: AppImageAsset(image: message.message)),
              ),
            ))));
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
                  : chatingPageViewModal!.arguments['name']
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
            if (chatingPageViewModal!.arguments['id'] != null) {
              Get.toNamed(RouteHelper.getChatProfileScreen(), arguments: {
                'name': chatingPageViewModal!.arguments['name'],
                'number': chatingPageViewModal!.arguments['number'],
                'id': chatingPageViewModal!.arguments['id'],
                'isGroup': chatingPageViewModal!.arguments['isGroup'],
                'members': chatingPageViewModal!.arguments['members'],
              });
            }
          },
          child: AppText(
              (chatingPageViewModal!.arguments['isGroup'])
                  ? chatingPageViewModal!.arguments['groupName']
                  : chatingPageViewModal!.arguments['name'],
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
                    chatingPageViewModal!.buildNavigationMenu(context)
                  ]))
        ]);
  }

  onSendMessage(message) async {
    (chatingPageViewModal!.blockedNumbers
        .contains(chatingPageViewModal!.arguments['number']))
        ? null
        : DatabaseService().addNewMessage(
        type: 'text',
        members: chatingPageViewModal!.arguments['members'],
        massage: message,
        sender: AuthService.auth.currentUser!.phoneNumber!,
        isGroup: false);
    logs('message---> $message');

    controller!.update();
  }

  textFormField(ChatingPageController controller, BuildContext context) {
    return TextFormField(
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        cursorColor: AppColorConstant.offBlack,
        onChanged: (value) {
          if (chatingPageViewModal!.chatController.text == '') {
            controller.chatingPageViewModal!.iconChange = false;
            controller.update();
          } else {
            controller.chatingPageViewModal!.iconChange = true;
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
                  : Icon(Icons.add,
                  size: 27.px, color: AppColorConstant.appBlack),
              onTap: () {
                if (chatingPageViewModal!.chatController.text.isNotEmpty) {
                  onSendMessage(chatingPageViewModal!.chatController.text);
                  controller.update();
                  chatingPageViewModal!.chatController.clear();
                }
              }),
        ),
        controller: chatingPageViewModal!.chatController);
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
        child: Icon(Icons.mic, size: 27.px, color: AppColorConstant.offBlack));
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
