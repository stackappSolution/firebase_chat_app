import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/home_controller.dart';
import 'package:signal/pages/calls/calls_screen.dart';
import 'package:signal/pages/chats/chat_screen.dart';
import 'package:signal/pages/home/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  HomeViewModel? homeViewModel;

  @override
  Widget build(BuildContext context) {
    homeViewModel ?? (homeViewModel = HomeViewModel(this));
    logs('Current screen --> $runtimeType');


    return GetBuilder<HomeScreenController>(
      init: HomeScreenController(),
      initState: (state) {},
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: AppColorConstant.appWhite,
          bottomNavigationBar: buildBottomBar(controller),
          body: getBody(controller),
        ));
      },
    );
  }
}

getBody(HomeScreenController controller) {
  return IndexedStack(
    index: controller.tabIndex,
    children: [
      ChatScreen(),
      const CallsScreen(),
    ],
  );
}

buildBottomBar(HomeScreenController controller) {
  return BottomNavigationBar(
      elevation: 0.0,
      backgroundColor: AppColorConstant.appWhite,
      selectedItemColor: AppColorConstant.appTheme,
      onTap: controller.changeTabIndex,
      currentIndex: controller.tabIndex,
      items: [
        BottomNavigationBarItem(
            label: StringConstant.calls,
            icon: AppImageAsset(
                height: 28.px,
                width: 28.px,
                image: (controller.tabIndex == 0)
                    ? AppAsset.chat
                    : AppAsset.chatOutline)),
        BottomNavigationBarItem(
            label: StringConstant.calls,
            icon: AppImageAsset(
                height: 28.px,
                width: 28.px,
                image: (controller.tabIndex == 1)
                    ? AppAsset.phone
                    : AppAsset.phoneOutline))
      ]);
}
