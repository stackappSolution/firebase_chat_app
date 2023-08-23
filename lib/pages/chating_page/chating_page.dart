import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/modal/message.dart';
import 'package:signal/pages/chating_page/chating_page_view_modal.dart';
import '../../app/app/utills/shared_preferences.dart';
import '../../controller/chating_page_controller.dart';

class ChatingPage extends StatelessWidget {
  ChatingPageViewModal? chatingPageViewModal;
  static String date = '';
  static String? fontSize;

  ChatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    chatingPageViewModal ?? (chatingPageViewModal = ChatingPageViewModal(this));
    fontSize =  '${chatingPageViewModal!.fontSizeInitState()}' ;


    return GetBuilder(
        init: ChatingPageController(),
        builder: (ChatingPageController controller) {
          return Scaffold(
              appBar: appBar(controller, context),
              body: Container(
                  decoration: const BoxDecoration(color: AppColorConstant.appWhite),
                  child: Column(children: [
                    Expanded(
                        child: GroupedListView(
                            reverse: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            order: GroupedListOrder.DESC,
                            useStickyGroupSeparators: true,
                            floatingHeader: true,
                            elements: controller.chatingPageViewModal.chatting,
                            groupBy: (element) => DateTime(element.messageTimestamps.year,
                                element.messageTimestamps.month, element.messageTimestamps.day),
                            groupHeaderBuilder: (dateTime) {
                              final monthFormat = DateFormat.MMM();
                              final formattedMonth = monthFormat.format(dateTime.messageTimestamps);
                              return Container(
                                  margin: EdgeInsets.only(top: 5.px),
                                  alignment: Alignment.center,
                                  height: fontSize == StringConstant.small
                                      ? 22.px
                                      : fontSize == StringConstant.large
                                          ? 35.px
                                          : fontSize == StringConstant.extraLarge
                                              ? 40.px
                                              : 28.px,
                                  child: Container(
                                      padding: EdgeInsets.all(5.px),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.px),
                                          color: AppColorConstant.offBlack),
                                      alignment: Alignment.center,
                                      height: fontSize == StringConstant.small
                                          ? 21.px
                                          : fontSize == StringConstant.large
                                              ? 30.px
                                              : fontSize == StringConstant.extraLarge
                                                  ? 35.px
                                                  : 28.px,
                                      width: fontSize == StringConstant.small
                                          ? 70.px
                                          : fontSize == StringConstant.large
                                              ? 110.px
                                              : fontSize == StringConstant.extraLarge
                                                  ? 135.px
                                                  : 100.px,
                                      child: AppText(
                                          '$formattedMonth ${dateTime.messageTimestamps.day}, ${dateTime.messageTimestamps.year}',
                                          color: AppColorConstant.appWhite,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: fontSize == StringConstant.small
                                              ? 9.px
                                              : fontSize == StringConstant.large
                                                  ? 15.px
                                                  : fontSize == StringConstant.extraLarge
                                                      ? 20.px
                                                      : 14.px)));
                            },
                            itemBuilder: (context, element) {
                              return buildMessage(element, context, controller);
                            })),
                    Row(children: [
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(
                                  right: 15.px, left: 15.px, bottom: 5.px, top: 5.px),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(35.px)),
                              height: 40.px,
                              child: textFormField(controller))),
                      AppButton(
                          margin: EdgeInsets.only(right: 15.px),
                          height: 40.px,
                          color: AppColorConstant.iconOrange,
                          stringChild: true,
                          width: 40.px,
                          borderRadius: BorderRadius.circular(40.px),
                          child: controller.chatingPageViewModal.iconChange
                              ? const Icon(Icons.send, color: AppColorConstant.offBlackSend)
                              : Icon(Icons.add, size: 27.px, color: AppColorConstant.offBlackSend),
                          onTap: () {
                            if (controller.chatingPageViewModal.chatController.text.isNotEmpty) {
                              Message message = Message(
                                  messages: controller.chatingPageViewModal.chatController.text,
                                  isSender: true,
                                  messageTimestamps: DateTime.now());
                              logs('messages: $message');
                              controller.chatingPageViewModal.chatting.add(message);
                              controller.chatingPageViewModal.chatController.clear();
                              controller.update();
                            }
                          }),
                      IconButton(
                          icon: Icon(Icons.record_voice_over, size: 27.px),
                          onPressed: () {
                            if (controller.chatingPageViewModal.chatController.text.isNotEmpty) {
                              Message message = Message(
                                  messages: controller.chatingPageViewModal.chatController.text,
                                  isSender: false,
                                  messageTimestamps: DateTime.now());
                              logs('messages: $message');

                              controller.chatingPageViewModal.chatting.add(message);
                              controller.update();
                              controller.chatingPageViewModal.chatController.clear();
                            }
                          })
                    ])
                  ])));
        });
  }



  Widget buildMessage(Message message, context, ChatingPageController controller) {
    final messageTime = message.messageTimestamps;
    final formattedTime =
        '${messageTime.hour > 12 ? messageTime.hour - 12 : messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')} ${messageTime.hour < 12 ? 'AM' : 'PM'}';

    final monthFormat = DateFormat.MMM();
    final formattedMonth = monthFormat.format(messageTime);

    final formattedDate =
        '$formattedMonth ${messageTime.day.toString().padLeft(2, '0')}, ${messageTime.year}';
    date = formattedDate;
    logs('small   : ${fontSize == StringConstant.small}');
    logs('large    : ${fontSize == StringConstant.large}');
    logs('normal    : ${fontSize == StringConstant.normal}');
    logs('extraLarge : ${fontSize == StringConstant.extraLarge}');
    return Slidable(
        child: (message.isSender)
            ? (Slidable(
                endActionPane:
                    ActionPane(extentRatio: 0.15.px, motion: const ScrollMotion(), children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.px),
                        child: const CircleAvatar(backgroundColor: AppColorConstant.orange),
                      ))
                ]),
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
                    alignment: Alignment.centerRight,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      ChatBubble(
                          elevation: 0,
                          margin: EdgeInsets.only(left: 100.px),
                          clipper: ChatBubbleClipper2(
                              type: BubbleType.sendBubble,
                              nipHeight: 10.px,
                              nipWidth: 6.px,
                              radius: 5.px),
                          alignment: Alignment.topRight,
                          backGroundColor: AppColorConstant.chatOrange,
                          child: AppText(message.messages,
                              fontSize: fontSize == StringConstant.small
                                  ? 10.px
                                  : fontSize == StringConstant.large
                                      ? 20.px
                                      : fontSize == StringConstant.extraLarge
                                          ? 25.px
                                          : 15.px)),
                      Padding(
                          padding: EdgeInsets.only(right: 5.px, top: 3.px),
                          child: AppText(formattedTime,
                              color: AppColorConstant.appBlack,
                              fontSize: fontSize == StringConstant.small
                                  ? 8.px
                                  : fontSize == StringConstant.large
                                      ? 15.px
                                      : fontSize == StringConstant.extraLarge
                                          ? 20.px
                                          : 12.px))
                    ]))))
            : (Slidable(
                startActionPane:
                    ActionPane(extentRatio: 0.139.px, motion: const ScrollMotion(), children: [
                  SizedBox(width: 10.px),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 10.px),
                          child: const CircleAvatar(backgroundColor: AppColorConstant.orange)))
                ]),
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
                    alignment: Alignment.centerLeft,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      ChatBubble(
                          elevation: 0,
                          margin: EdgeInsets.only(right: 100.px),
                          clipper: ChatBubbleClipper2(
                              type: BubbleType.receiverBubble,
                              nipHeight: 10.px,
                              nipWidth: 6.px,
                              radius: 5.px),
                          backGroundColor: AppColorConstant.chatOrange,
                          child: AppText(message.messages,
                              fontSize: fontSize == StringConstant.small
                                  ? 10.px
                                  : fontSize == StringConstant.large
                                      ? 20.px
                                      : fontSize == StringConstant.extraLarge
                                          ? 25.px
                                          : 15.px)),
                      Padding(
                          padding: EdgeInsets.only(left: 5.px, top: 3.px),
                          child: AppText(formattedTime,
                              color: AppColorConstant.appBlack,
                              fontSize: fontSize == StringConstant.small
                                  ? 8.px
                                  : fontSize == StringConstant.large
                                      ? 15.px
                                      : fontSize == StringConstant.extraLarge
                                          ? 20.px
                                          : 12.px))
                    ])))));
  }

  AppAppBar appBar(ChatingPageController controller, context) {
    return AppAppBar(
        backgroundColor: AppColorConstant.appTransparent,
        leadingWidth: 90.px,
        leading: Row(children: [
          SizedBox(width: 2.px),
          IconButton(
              icon: Icon(Icons.arrow_back_rounded, size: 30.px, color: AppColorConstant.offBlack),
              onPressed: () {
                // Get.toNamed('/appearance');
              }),
          CircleAvatar(maxRadius: 20.px, backgroundColor: AppColorConstant.orange)
        ]),
        title: AppText(StringConstant.userName, fontSize: 20.px, overflow: TextOverflow.ellipsis),
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
                        icon: Icon(Icons.more_vert, color: AppColorConstant.offBlack, size: 26.px))
                  ]))
        ]);
  }

  TextFormField textFormField(ChatingPageController controller) {
    return TextFormField(
        style: const TextStyle(color: AppColorConstant.appBlack),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        cursorColor: AppColorConstant.offBlack,
        onChanged: (value) {
          if (controller.chatingPageViewModal.chatController.text == '') {
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
            prefixIcon: emojiButton(),
            hintText: StringConstant.signalMessage,
            suffixIcon: SizedBox(
                height: 40.px,
                width: 78.px,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [cameraButton(), micButton()]))),
        controller: controller.chatingPageViewModal.chatController);
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
        child: Icon(Icons.camera_alt_outlined, size: 27.px, color: AppColorConstant.offBlack));
  }

  AppButton micButton() {
    return AppButton(
        onTap: () {},
        margin: EdgeInsets.only(right: 10.px),
        width: 27.px,
        height: 27.px,
        color: Colors.transparent,
        stringChild: true,
        borderRadius: BorderRadius.circular(27.px),
        child: Icon(Icons.mic_none_outlined, size: 27.px, color: AppColorConstant.offBlack));
  }
}
// double getFontSizeValue(String fontSize,
//     {double? small, double? large, double? extraLarge, double? normal}) {
//   logs('fontSize :  $fontSize');
//   switch (fontSize) {
//     case StringConstant.small:
//       return small ?? 14.0;
//     case StringConstant.large:
//       return large ?? 35.0;
//     case StringConstant.extraLarge:
//       return extraLarge ?? 40.0;
//     case StringConstant.normal:
//       return normal ?? 25.0;
//     default:
//       return 25;
//   }
// }
