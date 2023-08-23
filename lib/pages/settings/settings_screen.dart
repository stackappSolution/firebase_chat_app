import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/pages/settings/settings_view_model.dart';
import 'package:signal/generated/l10n.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  SettingViewModel? settingViewModel;

  @override
  Widget build(BuildContext context) {
    settingViewModel ?? (settingViewModel = SettingViewModel(this));
    logs('Current Screen---> $runtimeType');

    return GetBuilder<SettingsController>(
      initState: (state) {},
      init: SettingsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .background,
          appBar: getAppbar(context),
          body: getBody(context, controller),
        );
      },
    );
  }

  getAppbar(context) {
    return AppAppBar(
      title: AppText(
        S
            .of(Get.context!)
            .settings,
        fontSize: 20.px,
        color: Theme
            .of(context)
            .colorScheme
            .primary,
      ),
    );
  }

  getBody(BuildContext context, SettingsController controller) {
    return ListView(
      children: [
        SizedBox(
          height: 10.px,
        ),
        buildProfileView(context),
        buildSettingsList(context, controller),
        buildProfileView(context),
        buildSettingsList(context, controller),
      ],
    );
  }

  buildProfileView(context) {
    Color primaryTheme = Theme
        .of(context)
        .colorScheme
        .primary;
    Color secondaryTheme = Theme
        .of(context)
        .colorScheme
        .secondary;
    return Row(
      children: [
        SizedBox(
          width: 20.px,
          height: 20.px,
        ),
        CircleAvatar(
          maxRadius: 40.px,
          backgroundColor: AppColorConstant.appTheme.withOpacity(0.2),
          child: AppText('JB', fontSize: 25.px, color: primaryTheme),
        ),
        SizedBox(
          width: 30.px,
          height: 20.px,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              S
                  .of(Get.context!)
                  .userName,
              fontSize: 20.px,
              color: primaryTheme,
            ),
            AppText('9904780294', color: secondaryTheme, fontSize: 12.px),
          ],
        )
      ],
    );
  }

  buildSettingsList(BuildContext context, SettingsController controller) {
    return ListView(physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        settingsView(
          context,
          1,
          AppAsset.account,
          S
              .of(Get.context!)
              .account,
        ),
        settingsView(
          context,
          2,
          AppAsset.appearance,
          S
              .of(Get.context!)
              .appearance,
        ),
        settingsView(
          context,
          3,
          AppAsset.linkedDevice,
          S
              .of(Get.context!)
              .linkedDevice,
        ),
        settingsView(
          context,
          4,
          AppAsset.donate,
          S
              .of(Get.context!)
              .donateToSignal,
        ),
        settingsView(
          context,
          5,
          AppAsset.chats,
          S
              .of(Get.context!)
              .chats,
        ),
        settingsView(
          context,
          6,
          AppAsset.privacyPolicy,
          S
              .of(Get.context!)
              .privacyPolicy,
        ),
        settingsView(
          context,
          7,
          AppAsset.invite,
          S
              .of(Get.context!)
              .inviteFriends,
        ),
        settingsView(
          context,
          8,
          AppAsset.help,
          S
              .of(Get.context!)
              .help,
        ),
      ],
    );
  }

  settingsView(context,
      index,
      image,
      tittle) {
    return Padding(
      padding: EdgeInsets.all(10.px),
      child: ListTile(
        onTap: () {
          settingViewModel!.mainTap(index);
        },
        title: AppText(
          tittle,
          fontSize: 15.px,
          color: Theme
              .of(context)
              .colorScheme
              .primary,
        ),
        leading: Container(
          height: 50.px,
          width: 50.px,
          padding: EdgeInsets.all(12.px),
          decoration: BoxDecoration(
              color: AppColorConstant.appTheme.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.px),
              border: Border.all(color: AppColorConstant.appTheme)),
          child: AppImageAsset(
            image: image,
          ),
        ),
      ),
    );
  }
}
