import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/generated/l10n.dart';

// ignore: must_be_immutable
class ChatColorScreen extends StatelessWidget {
  ChatColorScreen({Key? key}) : super(key: key);

  SettingsController? controller;
  Color selectedColor = AppColorConstant.darkBlue;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      initState: (state) {
        Future.delayed(
          const Duration(milliseconds: 100),
          () async {
            controller = Get.find<SettingsController>();
            selectedColor = await getChatBubbleColor();
            controller!.update();
          },
        );
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppBar(context),
          body: getBody(context),
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
      height: 170.px,
      width: double.infinity,
      color:AppColorConstant.grey,
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
                    color:  Theme.of(context).colorScheme.secondary,
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
      AppColorConstant.darkPink,
      AppColorConstant.darkGreen,
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
            setStringValue(chatColor, selectedColor.value.toRadixString(16));
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

  Future<Color> getChatBubbleColor() async {
    final colorCode = await getStringValue(chatColor);
    if (colorCode != null) {
      return Color(int.parse(colorCode, radix: 16));
    } else {
      return Colors.black;
    }
  }
}
