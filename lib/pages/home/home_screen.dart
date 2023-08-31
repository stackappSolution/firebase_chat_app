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
import 'package:signal/routes/app_navigation.dart';

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
      padding: EdgeInsets.only(left: 15.px),
      child: CircleAvatar(
        backgroundColor: AppColorConstant.appYellow.withOpacity(0.2),
        child: AppText('S', fontSize: 20.px, color: AppColorConstant.appYellow),
      ),
    ),
    title: Padding(
      padding: EdgeInsets.only(left: 20.px),
      child: AppText(S.of(Get.context!).signal,
          color: AppColorConstant.appBlack, fontSize: 20.px),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.all(18.px),
        child: const AppImageAsset(image: AppAsset.search),
      ),
      buildPopupMenu(),
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
      selectedItemColor: AppColorConstant.appYellow,
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

buildPopupMenu() {
  return PopupMenuButton(
    onSelected: (value) {
      if (value == 0) {
        goToNewGroupScreen();
      }
      if (value == 2) {
        goToSettingPage();
      }
    },
    elevation: 0.5,
    position: PopupMenuPosition.under,
    color: AppColorConstant.appLightGrey,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.px)),
    icon: Padding(
      padding: EdgeInsets.all(10.px),
      child: const AppImageAsset(image: AppAsset.popup),
    ),
    itemBuilder: (context) {
      return [
        PopupMenuItem(
          value: 0,
          child: AppText(S.of(Get.context!).newGroup),
        ),
        PopupMenuItem(value: 1, child: AppText(S.of(Get.context!).markAllRead)),
        PopupMenuItem(value: 2, child: AppText(S.of(Get.context!).settings)),
        PopupMenuItem(
            value: 3, child: AppText(S.of(Get.context!).inviteFriends)),
      ];
    },
  );
}
