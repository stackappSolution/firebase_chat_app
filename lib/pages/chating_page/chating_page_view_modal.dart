import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:get/get.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app/utills/app_utills.dart';

import '../../constant/string_constant.dart';


class ChatingPageViewModal {
  ChatingPage? chatingPage;

  Color? chatBubbleColor;
  Color? wallpaperColor;
  Map<String, dynamic> parameter = {};
  Map<String, dynamic> arguments = {};
  String? wallpaperPath;
  bool isGroup=false;
  String? formatedTime;
  // List<String> members=[];


  List<String> mobileNumbers = [];
  List<String> chats = [];
  TextEditingController chatController = TextEditingController();

  ChatingPageController? controller;

  ChatingPageViewModal([this.chatingPage]) {
    Future.delayed(const Duration(milliseconds: 100), () async {
      controller = Get.find<ChatingPageController>();
      ChatingPage.fontSize = await getStringValue(StringConstant.setFontSize);
      controller!.update();
    });
  }

  Future<String?> fontSizeInitState() async {
    ChatingPage.fontSize = await getStringValue(StringConstant.setFontSize);
    logs(
        'getStringValue(StringConstant.selectedFontSize) : ${ChatingPage.fontSize}');
    return ChatingPage.fontSize;
  }

  List<PopupMenuEntry<String>> popupMenu = [
    const PopupMenuItem<String>(value: '/appearance', child: Text('Option 1')),
    const PopupMenuItem<String>(value: '/intro', child: Text('Option 2')),
    const PopupMenuItem<String>(value: '/SignInPage', child: Text('Option 3'))
  ];


  bool iconChange = false;

  Future<Color> getWallpaperColor() async {
    final colorCode = await getStringValue(wallPaperColor);
    if (colorCode != null) {
      return Color(int.parse(colorCode, radix: 16));
    } else {
      return Colors.white;
    }
  }


  inviteFriends() async {
    if (Platform.isAndroid) {
      String uri =
          'sms:${parameter['phoneNo']}?body=${Uri.encodeComponent("Lets switch to signal: \n http://signal.org/install")}';
      await launchUrl(Uri.parse(uri));
    } else if (Platform.isIOS) {
      String uri =
          'sms:${parameter['phoneNo']}&body=${Uri.encodeComponent("Lets switch to signal: \n http://signal.org/install")}';
      await launchUrl(Uri.parse(uri));
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

  Future<List<String>> getMobileNumbers() async {
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var value in usersSnapshot.docs) {
      String mobileNumber = value.get('phone');
      mobileNumbers.add(mobileNumber);
    }

    return mobileNumbers;
  }

}
