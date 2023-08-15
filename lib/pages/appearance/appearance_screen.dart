import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding:  EdgeInsets.only(top: 40.px),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          appearanceViewTile(
              StringConstant.language, StringConstant.systemDefault),
          appearanceViewTile(StringConstant.theme, StringConstant.systemDefault),
          appearanceViewTile(StringConstant.chatColor, ""),
          appearanceViewTile(StringConstant.appIcon, ""),
          appearanceViewTile(
              StringConstant.messageFontSize, StringConstant.normal),
          appearanceViewTile(
              StringConstant.navigationBarSize, StringConstant.normal),
        ]),
      ),
    ));
  }

  appearanceViewTile(title, subtitle) {
    return Container(margin:EdgeInsets.symmetric(horizontal: 25.px,vertical: 15.px),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title),
          AppText(subtitle,color:AppColorConstant.appBlack.withOpacity(0.5)),
        ],
      ),
    );
  }
}
