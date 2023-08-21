import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/generated/l10n.dart';
import '../../controller/chating_page_controller.dart';

class ChatingPage extends StatelessWidget {
  const ChatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ChatingPageController(),
        builder: (ChatingPageController controller) {
          return Scaffold(
              appBar: appBar(controller),
              body: Container(
                  decoration: const BoxDecoration(color: AppColorConstant.lightpurple),
                  child: Column(children: [
                    Expanded(
                        child: chatList(controller)),
                    Row(children: [
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(right: 10.px, left: 10.px, bottom: 10.px),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(55.px)),
                              height: 55.px,
                              child: textFormField(controller))),
                      addButton()
                    ])
                  ])));
        });
  }

  ListView chatList(ChatingPageController controller) {
    return ListView.builder(
                          itemCount: controller.chatingPageViewModal.message.length,
                          itemBuilder: (context, index) {
                            final messageTime =
                                controller.chatingPageViewModal.messageTimestamps[index];
                            final formattedTime =
                                '${messageTime.hour > 12 ? messageTime.hour - 12 : messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')} ${messageTime.hour < 12 ? 'AM' : 'PM'}';

                            Widget slidable;

                            if (controller.chatingPageViewModal.isSender[index]) {
                              slidable = Slidable(
                                  endActionPane: ActionPane(
                                      extentRatio: 0.2.px,
                                      motion: ScrollMotion(),
                                      children: [
                                        Container(
                                            width: 65.px,
                                            height: 65.px,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: AppColorConstant.purple,
                                                borderRadius: BorderRadius.circular(60.px)),
                                            child: AppText(StringConstant.oneTwoOne,
                                                fontSize: 25.px,
                                                color: AppColorConstant.appWhite))
                                      ]),
                                  child: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
                                      alignment: controller.chatingPageViewModal.isSender[index]
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Column(
                                          crossAxisAlignment:
                                              controller.chatingPageViewModal.isSender[index]
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.px),
                                                    color: AppColorConstant.appWhite),
                                                padding: EdgeInsets.all(8.px),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 4.px, horizontal: 8.px),
                                                child: Text(
                                                    controller
                                                        .chatingPageViewModal.message[index],
                                                    textAlign: controller
                                                            .chatingPageViewModal.isSender[index]
                                                        ? TextAlign.right
                                                        : TextAlign.left)),
                                            Padding(
                                                padding: controller
                                                        .chatingPageViewModal.isSender[index]
                                                    ? EdgeInsets.only(right: 10.px)
                                                    : EdgeInsets.only(left: 10.px),
                                                child: Text(formattedTime,
                                                    style:
                                                        const TextStyle(color: AppColorConstant.grey)))
                                          ])));
                            } else {
                              slidable = Slidable(
                                  startActionPane: ActionPane(
                                      extentRatio: 0.2.px,
                                      motion: const ScrollMotion(),
                                      children: [
                                        SizedBox(width: 5.px),
                                        Container(
                                            width: 65.px,
                                            height: 65.px,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: AppColorConstant.purple,
                                                borderRadius: BorderRadius.circular(60.px)),
                                            child: AppText(StringConstant.oneTwoOne,
                                                fontSize: 25.px,
                                                color: AppColorConstant.appWhite))
                                      ]),
                                  child: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 4.px, horizontal: 8.px),
                                      alignment: controller.chatingPageViewModal.isSender[index]
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Column(
                                          crossAxisAlignment:
                                              controller.chatingPageViewModal.isSender[index]
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.px),
                                                    color: AppColorConstant.appWhite),
                                                padding: EdgeInsets.all(8.px),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 4.px, horizontal: 8.px),
                                                child: Text(
                                                    controller
                                                        .chatingPageViewModal.message[index],
                                                    textAlign: controller
                                                            .chatingPageViewModal.isSender[index]
                                                        ? TextAlign.right
                                                        : TextAlign.left)),
                                            Padding(
                                                padding: controller
                                                        .chatingPageViewModal.isSender[index]
                                                    ? EdgeInsets.only(right: 10.px)
                                                    : EdgeInsets.only(left: 10.px),
                                                child: Text(formattedTime,
                                                    style:
                                                        const TextStyle(color: AppColorConstant.grey)))
                                          ])));
                            }

                            return slidable;
                          });
  }

  AppAppBar appBar(ChatingPageController controller) {
    return AppAppBar(
                leadingWidth: 101.px,
                leading: Row(children: [
                  SizedBox(width: 2.px),
                  IconButton(
                      icon: Icon(Icons.arrow_back_rounded, size: 35.px),
                      onPressed: () {
                        // Handle back button press
                      }),
                  Container(
                      width: 48.px,
                      height: 48.px,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.px),
                          image: DecorationImage(image: AssetImage(AppAsset.profile))))
                ]),
                title: AppText(StringConstant.userName,
                    fontSize: 20.px, overflow: TextOverflow.ellipsis),
                actions: [
                  Container(
                      width: 120.px,
                      child: Row(children: [
                        AppButton(
                            onTap: () {},
                            width: 30.px,
                            height: 30.px,
                            color: Colors.transparent,
                            stringChild: true,
                            borderRadius: BorderRadius.circular(35.px),
                            child: Icon(Icons.video_camera_back_outlined, size: 30.px)),
                        AppButton(
                            margin: EdgeInsets.only(left: 10.px),
                            onTap: () {},
                            width: 30.px,
                            height: 30.px,
                            color: Colors.transparent,
                            stringChild: true,
                            borderRadius: BorderRadius.circular(35.px),
                            child: Icon(Icons.call_outlined, size: 30.px)),
                        PopupMenuButton(
                            onSelected: (value) {
                              print("Selected: $value");
                            },
                            itemBuilder: (context) {
                              return controller.chatingPageViewModal.popupMenu;
                            },
                            icon: const Icon(Icons.more_vert))
                      ]))
                ]);
  }

  TextFormField textFormField(ChatingPageController controller) {
    return TextFormField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            prefixIcon: emojiButton(),
            hintText: S.of(Get.context!).signalMessage,
            suffixIcon: Container(
                height: 50.px,
                width: 105.px,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [cameraButton(), micButton()]))),
        controller: controller.chatingPageViewModal.chatController);
  }

  AppButton emojiButton() {
    return AppButton(
        onTap: () {},
        margin: EdgeInsets.only(left: 5.px),
        width: 35.px,
        height: 35.px,
        color: Colors.transparent,
        stringChild: true,
        borderRadius: BorderRadius.circular(35.px),
        child: Icon(Icons.mood, size: 35.px));
  }

  AppButton cameraButton() {
    return AppButton(
        onTap: () {},
        margin: EdgeInsets.only(right: 10.px),
        width: 35.px,
        height: 35.px,
        color: Colors.transparent,
        stringChild: true,
        borderRadius: BorderRadius.circular(35.px),
        child: Icon(Icons.camera_alt_outlined, size: 35.px));
  }

  AppButton micButton() {
    return AppButton(
        onTap: () {},
        margin: EdgeInsets.only(right: 10.px),
        width: 35.px,
        height: 35.px,
        color: Colors.transparent,
        stringChild: true,
        borderRadius: BorderRadius.circular(35.px),
        child: Icon(Icons.mic_none_outlined, size: 35.px));
  }

  AppButton addButton() {
    return AppButton(
        onTap: () {},
        margin: EdgeInsets.only(right: 10.px, bottom: 10.px),
        width: 50.px,
        height: 50.px,
        color: AppColorConstant.blue,
        stringChild: true,
        borderRadius: BorderRadius.circular(60.px),
        child: Icon(Icons.add, size: 40.px, color: AppColorConstant.appWhite));
  }
}
