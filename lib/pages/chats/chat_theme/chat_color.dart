import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_theme/chat_color_wallapaper_screen.dart';

class ChatColorScreen extends StatelessWidget {
  ChatColorScreen({Key? key}) : super(key: key);

  SettingsController? controller;
  Color selectedColor = AppColorConstant.appYellow;
  final firestore = FirebaseFirestore.instance;
  Color? bubbleColor;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      initState: (state) {
        Future.delayed(
          const Duration(milliseconds: 0),
              () async {
            controller = Get.find<SettingsController>();
            controller!.update();
          },
        );
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppBar(context),
          body: getBody(context),
          bottomNavigationBar: buildSaveButton(context),
        );
      },
    );
  }

  getAppBar(BuildContext context) {
    return AppAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText(
        S.of(context).chatColor,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      children: [
        buildDemoChatView(context),
        buildColorsGridView(),
      ],
    );
  }

  buildDemoChatView(BuildContext context) {
    return Container(
      height: 150.px,
      width: double.infinity,
      color: AppColorConstant.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10.px),
                height: 40.px,
                width: 230.px,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12.px)),
                child: AppText(S.of(context).colorIsOnlyVisibleYou)),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10.px),
                height: 40.px,
                width: 230.px,
                decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(12.px)),
                child: AppText(
                  S.of(context).colorIsOnlyVisibleYou,
                  color: AppColorConstant.appWhite,
                )),
          )
        ],
      ),
    );
  }

  buildColorsGridView() {
    List<Color> chatColors = [
      AppColorConstant.appYellow,
      AppColorConstant.darkBlue,
      AppColorConstant.darkPink,
      AppColorConstant.darkOrange,
      AppColorConstant.yellowGrey,
      AppColorConstant.darkGreen,
      AppColorConstant.teal,
      AppColorConstant.pinkPurple,
      AppColorConstant.greyPink,
      AppColorConstant.darkGrey,
      AppColorConstant.extraLightPurple,
      AppColorConstant.extraDarkOrange,
      AppColorConstant.pink,
      AppColorConstant.lightSky,
      AppColorConstant.purple,
      AppColorConstant.red,
    ];

    return GridView.builder(
      padding: EdgeInsets.all(10.px),
      itemCount: chatColors.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, crossAxisSpacing: 25.px, mainAxisSpacing: 25.px),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            selectedColor = chatColors[index];
            logs("selected Color--> $selectedColor");
            controller!.update();
          },
          child: (chatColors[index] == selectedColor)
              ? Container(
            height: 50.px,
            width: 50.px,
            decoration: BoxDecoration(
                border: Border.all(
                    color: AppColorConstant.appBlack, width: 5.px),
                color: chatColors[index],
                shape: BoxShape.circle),
          )
              : Container(
            height: 50.px,
            width: 50.px,
            decoration: BoxDecoration(
                color: chatColors[index], shape: BoxShape.circle),
          ),
        );
      },
    );
  }

  buildSaveButton(BuildContext context) {
    return InkWell(onTap: () async {
      await setChatBubbleColor(selectedColor);
      controller!.update();
      Get.back();
      Get.off(ChatColorWallpaperScreen());
    },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 100.px,vertical: 10.px),
        alignment: Alignment.center,
        height: 35.px,
        width: 110.px,
        decoration: BoxDecoration(
            color: AppColorConstant.appWhite,
            borderRadius: BorderRadius.circular(12.px),
            border: Border.all(color: AppColorConstant.grey, width: 2.px)),
        child: const AppText(
          StringConstant.save,
          color: AppColorConstant.appBlack,
        ),
      ),
    );
  }


  Future<void> setChatBubbleColor(Color selectedColor) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final colorHex = selectedColor.value.toRadixString(16);
      final colorRef = firestore.collection('users').doc(user.uid);
      try {
        await colorRef.set({
          'bubbleColor': colorHex,
        }, SetOptions(merge: true));
        print('Selected color saved successfully');
      } catch (error) {
        print('Error saving color: $error');
      }
    }
  }


}



