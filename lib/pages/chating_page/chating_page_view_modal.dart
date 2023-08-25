import 'package:flutter/material.dart';

import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:get/get.dart';
import 'package:signal/controller/chating_page_controller.dart';


import '../../app/app/utills/app_utills.dart';

import '../../constant/string_constant.dart';
import '../../modal/message.dart';


class ChatingPageViewModal {
  ChatingPage? chatingPage;


  Color? chatBubbleColor;
  Color? wallpaperColor;
  Map<String,dynamic> parameter= {};

  String? wallpaperPath;




  ChatingPageController? controller;


  ChatingPageViewModal([this.chatingPage]) {
    Future.delayed(const Duration(milliseconds: 100), () async {
      controller = Get.find<ChatingPageController>();
      ChatingPage.fontSize = await getStringValue(StringConstant.setFontSize);
      controller!.update();
    });
  }
 Future<String?> fontSizeInitState() async {

   ChatingPage.fontSize   = await getStringValue(StringConstant.setFontSize);
   logs('getStringValue(StringConstant.selectedFontSize) : ${ChatingPage.fontSize}');
    return ChatingPage.fontSize;
  }


  List<PopupMenuEntry<String>> popupMenu = [
    const PopupMenuItem<String>(value: '/appearance', child: Text('Option 1')),
    const PopupMenuItem<String>(value: '/intro', child: Text('Option 2')),
    const PopupMenuItem<String>(value: '/SignInPage', child: Text('Option 3'))
  ];

  TextEditingController chatController = TextEditingController();
  List<Message> chatting = [
    Message(messages: 'Hello!', isSender: true, messageTimestamps: DateTime(2023, 8, 17, 10, 30)),
    Message(messages: "Hello!", isSender: false, messageTimestamps: DateTime(2023, 8, 17, 12, 00)),
    Message(messages: "Hi there!", isSender: false, messageTimestamps: DateTime(2023, 8, 17, 1, 1)),
    Message(
        messages: "How are you?", isSender: true, messageTimestamps: DateTime(2023, 8, 18, 9, 45)),
    Message(
        messages: "Howaxcvdfxcvreyou?",
        isSender: false,
        messageTimestamps: DateTime(2023, 8, 19, 10, 40)),
    Message(
        messages: "How are you?", isSender: true, messageTimestamps: DateTime(2023, 8, 20, 9, 31)),
    Message(
        messages: "Howarevxcadfxcvt?",
        isSender: true,
        messageTimestamps: DateTime(2023, 8, 21, 9, 54)),
    Message(
        messages: "fhxgbcvrthcfgb ?",
        isSender: false,
        messageTimestamps: DateTime(2023, 8, 22, 9, 21)),
    Message(
        messages: "thnxfgvbthgbdv?",
        isSender: true,
        messageTimestamps: DateTime(2023, 8, 23, 9, 12)),
    Message(
        messages: "xfgvbrb ?", isSender: false, messageTimestamps: DateTime(2023, 8, 24, 9, 45)),
    Message(messages: "xnfvb ?", isSender: true, messageTimestamps: DateTime(2023, 8, 25, 9, 45)),

    Message(messages: "jsdkxcnjkjksdnjnj ?", isSender: false, messageTimestamps: DateTime(2023, 8, 26, 9, 8)),
    Message(messages: "tywefazcjhbxn b ui", isSender: false, messageTimestamps: DateTime(2023, 8, 26, 9, )),
    Message(messages: "lsvkwropjsvpdiopjfvfvdfvxcc fdv c", isSender: true, messageTimestamps: DateTime(2023, 8, 27, 9, 7)),
    Message(messages: "jjjasijjjkcjzxuihiowdcsmnjnoioeiccjweioji", isSender: false, messageTimestamps: DateTime(2023, 8, 28, 9, 2)),
    Message(messages: "isdjcwekmniweimeimm", isSender: true, messageTimestamps: DateTime(2023, 8, 29, 9, 24)),
    Message(messages: "irwjisdvjioijrijiosdioj", isSender: false, messageTimestamps: DateTime(2023, 8, 30, 9, 7)),

    Message(
        messages: "jsdkxcnjkjksdnjnj ?",
        isSender: false,
        messageTimestamps: DateTime(2023, 8, 26, 9, 8)
    ),
    Message(
        messages: "tywefazcjhbxn b ui",
        isSender: false,
        messageTimestamps: DateTime(2023, 8, 26, 9)),
    Message(
        messages: "lsvkwropjsvpdiopjfvfvdfvxcc fdv c",
        isSender: true,
        messageTimestamps: DateTime(2023, 8, 27, 9, 7)),
    Message(
        messages: "jjjasijjjkcjzxuihiowdcsmnjnoioeiccjweioji",
        isSender: false,
        messageTimestamps: DateTime(2023, 8, 28, 9, 2)),
    Message(        messages: "isdjcwekmniweimeimm",        isSender: true,
        messageTimestamps: DateTime(2023, 8, 29, 9, 24)),
    Message(
        messages: "irwjisdvjioijrijiosdioj",
        isSender: false,
        messageTimestamps: DateTime(2023, 8, 30, 9, 7)),

  ];
  bool iconChange = false;
  Future<Color> getColorFromPreferences() async {
    final colorCode = await getStringValue(wallPaperColor);
    if (colorCode != null) {
      return Color(int.parse(colorCode, radix: 16));
    } else {
      return Colors.white;
    }
  }

  Future<Color> getChatBubbleColor() async {
    final colorCode = await getStringValue(chatColor);
    if (colorCode != null) {
      return Color(int.parse(colorCode, radix: 16));
    } else {
      return AppColorConstant.appYellow;
    }
  }





}
