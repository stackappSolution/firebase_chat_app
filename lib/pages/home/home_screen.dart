import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/home_controller.dart';
import 'package:signal/pages/calls/calls_screen.dart';
import 'package:signal/pages/chats/chat_screen.dart';
import 'package:signal/pages/home/home_view_model.dart';
import 'package:signal/generated/l10n.dart';

import '../../app/app/utills/theme_util.dart';
import '../../service/network_connectivity.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  HomeViewModel? homeViewModel;

  @override
  Widget build(BuildContext context) {
    homeViewModel ?? (homeViewModel = HomeViewModel(this));
    logs('Current screen --> $runtimeType');

    return GetBuilder<HomeScreenController>(
      init: HomeScreenController(),
      initState: (state) {
          NetworkConnectivity.checkConnectivity(context);
        homeViewModel!.getLocalizationKey();
      },
      builder: (controller) {
        return SafeArea(
          child: Builder(builder: (context) {
            MediaQueryData mediaQuery = MediaQuery.of(context);
            ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              bottomNavigationBar: buildBottomBar(controller, context),
              body: getBody(controller),
            );
          }),
        );
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

buildBottomBar(HomeScreenController controller, BuildContext context) {
  return BottomNavigationBar(
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.background,
      selectedItemColor: AppColorConstant.appYellow,
      onTap: controller.changeTabIndex,
      currentIndex: controller.tabIndex,
      items: [
        BottomNavigationBarItem(
            label: S.of(Get.context!).chats,
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5.px),
              child: AppImageAsset(
                  height: 23.px,
                  width: 243.px,
                  image: (controller.tabIndex == 0)
                      ? AppAsset.chat
                      : AppAsset.chatOutline),
            )),
        BottomNavigationBarItem(
            label: S.of(Get.context!).calls,
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5.px),
              child: AppImageAsset(
                  height: 23.px,
                  width: 23.px,
                  image: (controller.tabIndex == 1)
                      ? AppAsset.phone
                      : AppAsset.phoneOutline),
            ))
      ]);
}
