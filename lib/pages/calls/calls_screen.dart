import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/routes/app_navigation.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logs("Current Screen --> $runtimeType");

    return GetBuilder<ContactController>(
      init: ContactController(),
      initState: (state) {},
      builder: (controller) {
        return  SafeArea(
            child: Scaffold(appBar: getAppBar(context),
          backgroundColor: AppColorConstant.appWhite,
        ));
      },
    );
  }

  buildFloatingButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(
            elevation: 0.0,
            heroTag: 'calls',
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.px)),
            backgroundColor: AppColorConstant.appYellow,
            child: AppImageAsset(
                image: AppAsset.phonePlus, height: 25.px, width: 25.px),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  getAppBar(BuildContext context) {
    return AppAppBar(backgroundColor: Theme.of(context).colorScheme.background,
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
            color: Theme.of(Get.context!).colorScheme.primary, fontSize: 20.px),
      ),
      actions: [
        InkWell(onTap: () {

        },
          child: Padding(
            padding: EdgeInsets.all(18.px),
            child: const AppImageAsset(image: AppAsset.search),
          ),
        ),
        buildPopupMenu(),
      ],
    );
  }


  buildPopupMenu() {
    return PopupMenuButton(
      onSelected: (value) {
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
          PopupMenuItem(
              value: 1,
              child: AppText(S.of(Get.context!).markAllRead)),
          PopupMenuItem(
              value: 2,
              child: AppText(S.of(Get.context!).settings)),
          PopupMenuItem(
              value: 3,
              child: AppText(S.of(Get.context!).inviteFriends)),
        ];
      },
    );
  }

}
