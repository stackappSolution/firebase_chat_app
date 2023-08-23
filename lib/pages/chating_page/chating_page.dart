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
import '../../controller/chating_page_controller.dart';

class ChatingPage extends StatelessWidget {
  const ChatingPage({super.key});

  static String date = '';

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ChatingPageController(),
        builder: (ChatingPageController controller) {
          return Scaffold(
              appBar: appBar(controller),
              body: Container(
                  decoration: const BoxDecoration(color: AppColorConstant.appWhite),
                  child: Column(children: [
                    Expanded(
                        child: GroupedListView(
                            reverse: true,clipBehavior: Clip.antiAliasWithSaveLayer,
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
                                  height: 25.px,
                                  child: Container(
                                      padding: EdgeInsets.all(5.px),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.px),
                                        color: AppColorConstant.appYellow,
                                      ),
                                      alignment: Alignment.center,
                                      height: 25.px,
                                      width: 100.px,
                                      child: Text(
                                          '$formattedMonth ${dateTime.messageTimestamps.day}, ${dateTime.messageTimestamps.year}',
                                          style:
                                              const TextStyle(color: AppColorConstant.appWhite))));
                            },
                            itemBuilder: (context, element) {
                              return buildMessage(element, context);
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

  Widget buildMessage(Message message, context) {
    final messageTime = message.messageTimestamps;
    final formattedTime =
        '${messageTime.hour > 12 ? messageTime.hour - 12 : messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')} ${messageTime.hour < 12 ? 'AM' : 'PM'}';

    final monthFormat = DateFormat.MMM();
    final formattedMonth = monthFormat.format(messageTime);

    final formattedDate =
        '$formattedMonth ${messageTime.day.toString().padLeft(2, '0')}, ${messageTime.year}';
    date = formattedDate;

    return Slidable(
        child: (message.isSender)
            ? (Slidable(
                endActionPane:
                    ActionPane(extentRatio: 0.15.px, motion: const ScrollMotion(), children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.px),
                        child: const CircleAvatar(backgroundColor: AppColorConstant.appYellow),
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
                          child: AppText(message.messages)),
                      Padding(
                          padding: EdgeInsets.only(right: 5.px, top: 3.px),
                          child: AppText(formattedTime,
                              color: AppColorConstant.appBlack, fontSize: 12.px))
                    ]))))
            : (Slidable(
                startActionPane:
                    ActionPane(extentRatio: 0.139.px, motion: const ScrollMotion(), children: [
                  SizedBox(width: 10.px),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.px),
                        child: const CircleAvatar(backgroundColor: AppColorConstant.appYellow),
                      ))
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
                          child: AppText(message.messages)),
                      Padding(
                          padding: EdgeInsets.only(left: 5.px, top: 3.px),
                          child: AppText(formattedTime,
                              color: AppColorConstant.appBlack, fontSize: 12.px))
                    ])))));
  }

  AppAppBar appBar(ChatingPageController controller) {
    return AppAppBar(
        backgroundColor: AppColorConstant.appTransparent,
        leadingWidth: 90.px,
        leading: Row(children: [
          SizedBox(width: 2.px),
          IconButton(
              icon: Icon(Icons.arrow_back_rounded, size: 30.px, color: AppColorConstant.offBlack),
              onPressed: () {}),
          CircleAvatar(maxRadius: 20.px, backgroundColor: AppColorConstant.appYellow)
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
                        onSelected: (value) {},
                        itemBuilder: (context) {
                          return controller.chatingPageViewModal.popupMenu;
                        },
                        icon: Icon(Icons.more_vert, color: AppColorConstant.offBlack, size: 26.px))
                  ]))
        ]);
  }

  TextFormField textFormField(ChatingPageController controller) {
    return TextFormField(
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
            children: [cameraButton(), micButton()],
          ),
        ),
      ),
      controller: controller.chatingPageViewModal.chatController,
      // Use helperText to conditionally display additional content
    );
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
/*     Container(
                      width: 45.px,
                      height: 45.px,
                      child: AppText(StringConstant.oneTwoOne,
                          fontSize: 25.px, color: AppColorConstant.appWhite),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColorConstant.purple,
                          borderRadius: BorderRadius.circular(45.px))),*/
/*
 ListView.builder(
        itemCount: controller.chatingPageViewModal.chatting.length,
        itemBuilder: (context, index) {
          final messageTime = controller.chatingPageViewModal.chatting[index]['messageTimestamps'];
          final formattedTime =
              '${messageTime.hour > 12 ? messageTime.hour - 12 : messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')} ${messageTime.hour < 12 ? 'AM' : 'PM'}';

          Widget slidable;

          if (controller.chatingPageViewModal.chatting[index]['isSender']) {
            slidable = Slidable(
                endActionPane: ActionPane(extentRatio: 0.15.px, motion: ScrollMotion(), children: [
                  CircleAvatar(
                    backgroundColor: AppColorConstant.orange,
                  )
                ]),
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
                    alignment: controller.chatingPageViewModal.chatting[index]['isSender']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                        crossAxisAlignment: controller.chatingPageViewModal.chatting[index]['isSender']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          ChatBubble(
                            clipper: ChatBubbleClipper2(
                                type: BubbleType.sendBubble, nipHeight: 8, nipWidth: 8),
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(top: 20),
                            backGroundColor: AppColorConstant.chatOrange,
                            child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: AppText(controller.chatingPageViewModal.chatting[index]['message'])),
                          ),
                          Padding(
                              padding: controller.chatingPageViewModal.chatting[index]['isSender']
                                  ? EdgeInsets.only(right: 5.px)
                                  : EdgeInsets.only(left: 10.px),
                              child: Text(formattedTime,
                                  style: TextStyle(color: AppColorConstant.appBlack)))
                        ])));
          } else {
            slidable = Slidable(
                startActionPane:
                    ActionPane(extentRatio: 0.139.px, motion: ScrollMotion(), children: [
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                  )
                ]),
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
                    alignment: controller.chatingPageViewModal.chatting[index]['isSender']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                        crossAxisAlignment: controller.chatingPageViewModal.chatting[index]['isSender']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          ChatBubble(
                            clipper: ChatBubbleClipper2(
                                type: BubbleType.receiverBubble, nipWidth: 7, nipHeight: 7),
                            backGroundColor: AppColorConstant.chatOrange,
                            margin: EdgeInsets.only(top: 20),
                            child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: AppText(controller.chatingPageViewModal.chatting[index]['message'])),
                          ),
                          Padding(
                              padding: controller.chatingPageViewModal.chatting[index]['isSender']
                                  ? EdgeInsets.only(right: 10.px)
                                  : EdgeInsets.only(left: 10.px),
                              child: Text(formattedTime,
                                  style: TextStyle(color: AppColorConstant.appBlack)))
                        ])));
          }
          return slidable;
        })
*/
/*
  Widget chatList(ChatingPageController controller) {
    return ListView.builder(
      itemCount: controller.chatingPageViewModal.chatting.length,
      itemBuilder: (context, index) {
        final messageTime = controller.chatingPageViewModal.chatting[index]['messageTimestamps'];
        final formattedTime =
            '${messageTime.hour > 12 ? messageTime.hour - 12 : messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')} ${messageTime.hour < 12 ? 'AM' : 'PM'}';

        // Extract the date from messageTime
        final formattedDate =
            '${messageTime.year}-${messageTime.month.toString().padLeft(2, '0')}-${messageTime.day.toString().padLeft(2, '0')}';

        Widget slidable;

        if (controller.chatingPageViewModal.chatting[index]['isSender']) {
          slidable = Slidable(
            endActionPane: ActionPane(
              extentRatio: 0.15.px,
              motion: ScrollMotion(),
              children: [
                CircleAvatar(
                  backgroundColor: AppColorConstant.orange,
                )
              ],
            ),
            child: Column(
              children: [
                buildChatBubble(controller.chatingPageViewModal.chatting[index], context,
                    formattedTime, formattedDate),
              ],
            ),
          );
        } else {
          slidable = Slidable(
            startActionPane: ActionPane(
              extentRatio: 0.139.px,
              motion: ScrollMotion(),
              children: [
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.black,
                ),
              ],
            ),
            child: Column(
              children: [

                Text(formattedDate),
                buildChatBubble(controller.chatingPageViewModal.chatting[index], context,formattedTime, formattedDate),
              ],
            ),
          );
        }
        return slidable;
      },
    );
  }

  Widget buildChatBubble(
    Message message,
    BuildContext context, String formattedTime, String formattedDate,
  ) {
    return Column(
      children: [
        StickyHeader(
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              formattedDate,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: Container(
            margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
            alignment: message.isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment:
                  message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ChatBubble(
                  clipper: message.isSender
                      ? ChatBubbleClipper2(type: BubbleType.sendBubble, nipHeight: 8, nipWidth: 8)
                      : ChatBubbleClipper2(
                          type: BubbleType.receiverBubble, nipWidth: 7, nipHeight: 7),
                  alignment: message.isSender ? Alignment.topRight : Alignment.topLeft,
                  margin: EdgeInsets.only(top: 20),
                  backGroundColor: AppColorConstant.chatOrange,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7.px,
                    ),
                    child: AppText(message.messages),
                  ),
                ),
                Padding(
                  padding: message.isSender
                      ? EdgeInsets.only(right: 5.px)
                      : EdgeInsets.only(left: 10.px),
                  child: Text(
                    formattedTime,
                    style: TextStyle(color: AppColorConstant.appBlack),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

 */
/*Slidable(
                startActionPane: ActionPane(
                    extentRatio: 0.139.px,
                    dismissible: AppText(formattedDate),
                    motion: const ScrollMotion(),
                    children: [
                      SizedBox(width: 10.px, height: 50.px),
                      CircleAvatar(backgroundColor: AppColorConstant.appBlack)
                    ]),
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
                    alignment: Alignment.centerLeft,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      ChatBubble(
                          margin: EdgeInsets.only(right: 100.px),
                          clipper: ChatBubbleClipper2(
                              type: BubbleType.receiverBubble,
                              nipHeight: 10.px,
                              nipWidth: 6.px,
                              radius: 5.px),
                          backGroundColor: AppColorConstant.chatOrange,
                          child: AppText(message.messages)),
                      Padding(
                          padding: EdgeInsets.only(left: 10.px, top: 5.px),
                          child: AppText(formattedTime,
                              color: AppColorConstant.appBlack, fontSize: 12.px))
                    ])))*/
/*ListView.builder(
                          itemCount: controller.chatingPageViewModal.chatting.length,
                          itemBuilder: (context, index) {
                            return buildMessage(
                                controller.chatingPageViewModal.chatting[index], context);
                          },
                        )*/
