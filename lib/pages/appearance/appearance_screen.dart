import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/appearance_controller.dart';
import 'package:signal/pages/appearance/appearance_view_model.dart';


class AppearanceScreen extends StatelessWidget {
  AppearanceViewModel? appearanceViewModel;

  AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    appearanceViewModel ?? (appearanceViewModel = AppearanceViewModel(this));

    return GetBuilder<AppearanceController>(
      init: AppearanceController(),
      initState: (state) async {},
      builder: (AppearanceController controller) {
        return SafeArea(
            child: Scaffold(
          appBar: getAppBar(),
          body: getBody(context, controller),
        ));
      },
    );
  }

  getAppBar() {
    return AppAppBar(
        title: AppText(
      StringConstant.appearance,
      fontSize: 22.px,
    ));
  }

  getBody(BuildContext context, AppearanceController controller) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColorConstant.appWhite, AppColorConstant.lightOrange],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Padding(
        padding: EdgeInsets.only(top: 40.px),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          appearanceViewTile(1, context, StringConstant.language,
              StringConstant.systemDefault, controller),
          appearanceViewTile(2, context, StringConstant.theme,
              StringConstant.systemDefault, controller),
          appearanceViewTile(
              3, context, StringConstant.chatColor, "", controller),
          appearanceViewTile(
              4, context, StringConstant.appIcon, "", controller),
          appearanceViewTile(5, context, StringConstant.messageFontSize,
              StringConstant.normal, controller),
          appearanceViewTile(6, context, StringConstant.navigationBarSize,
              StringConstant.normal, controller),
        ]),
      ),
    );
  }

  appearanceViewTile(
    index,
    context,
    title,
    subtitle,
    AppearanceController controller,
  ) {
    return InkWell(
      onTap: () {
        appearanceViewModel!.mainTap(index, context, controller);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.px, vertical: 13.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(title),
            AppText(
              subtitle,
              color: AppColorConstant.appBlack.withOpacity(0.5),
              fontSize: 13,
            ),
          ],
        ),
      ),
    );
  }
}
