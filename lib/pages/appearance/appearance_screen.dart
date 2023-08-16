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
  AppearanceController? appearanceController;

  AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    appearanceViewModel ?? (appearanceViewModel = AppearanceViewModel(this));

    return GetBuilder<AppearanceController>(
      init: AppearanceController(),
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          appBar: AppAppBar(
              title: AppText(
            StringConstant.appearance,
            fontSize: 22.px,
          )),
          body: getBody(context, controller),
        ));
      },
    );
  }

  getBody(BuildContext context, AppearanceController controller) {

    return Padding(
      padding: EdgeInsets.only(top: 40.px),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          appearanceViewTile(context, StringConstant.language,
              StringConstant.systemDefault, controller),
          appearanceViewTile(context, StringConstant.theme,
              StringConstant.systemDefault, controller),
          appearanceViewTile(context, StringConstant.chatColor, "", controller),
          appearanceViewTile(context, StringConstant.appIcon, "", controller),
          appearanceViewTile(context, StringConstant.messageFontSize,
              StringConstant.normal, controller),
          appearanceViewTile(context, StringConstant.navigationBarSize,
              StringConstant.normal, controller),

        ]),
      ),
    );
  }

  appearanceViewTile(
    context,
    title,
    subtitle,
    AppearanceController controller,
  ) {
    return InkWell(
      onTap: () {
        appearanceViewModel!.themeTap(context, controller);
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
