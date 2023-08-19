import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/home_controller.dart';
import 'package:signal/pages/calls/calls_screen.dart';
import 'package:signal/pages/chats/chat_screen.dart';
import 'package:signal/pages/home/home_view_model.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/routes/routes_helper.dart';


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

        homeViewModel!.getLocalizationKey();


      },
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
              appBar: getAppBar(),
          backgroundColor: AppColorConstant.appWhite,
          bottomNavigationBar: buildBottomBar(controller),
          body: getBody(controller),
        ));
      },
    );
  }
}
getAppBar() {
  return AppAppBar(
    leading: Padding(
      padding: EdgeInsets.all(16.px),
      child: const AppImageAsset(
        image: AppAsset.person,
      ),
    ),
    title: AppText(S.of(Get.context!).chats,
        color: AppColorConstant.appBlack, fontSize: 20.px),
    actions: [
      Padding(
        padding: EdgeInsets.all(18.px),
        child: const AppImageAsset(image: AppAsset.search),
      ),
      InkWell(onTap: () {
        Get.toNamed(RouteHelper.getSettingScreen());
      },
        child: Padding(
          padding: EdgeInsets.all(18.px),
          child: const AppImageAsset(image: AppAsset.popup),
        ),
      ),
    ],
  );
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
            label: S.of(Get.context!).chats,
            icon: AppImageAsset(
                height: 28.px,
                width: 28.px,
                image: (controller.tabIndex == 0)
                    ? AppAsset.chat
                    : AppAsset.chatOutline)),
        BottomNavigationBarItem(
            label: S.of(Get.context!).calls,
            icon: AppImageAsset(
                height: 28.px,
                width: 28.px,
                image: (controller.tabIndex == 1)
                    ? AppAsset.phone
                    : AppAsset.phoneOutline))
      ]);
}
