import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
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
      initState: (state) {
        settingViewModel!.getLocalizationKey();
      },
      init: SettingsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColorConstant.appWhite,
          appBar: getAppbar(),
          body: getBody(controller),
        );
      },
    );
  }

  getAppbar() {
    return AppAppBar(
      title: AppText(S.of(Get.context!).settings, fontSize: 20.px),
    );
  }


  getBody(SettingsController controller) {
    return Column(
      children: [
        buildProfileView(),
        buildSettingsList(controller),
      ],
    );
  }

  buildProfileView() {
    return Row(
      children: [
        SizedBox(
          width: 30.px,
        ),
        CircleAvatar(
          maxRadius: 40.px,
          backgroundColor: AppColorConstant.appTheme.withOpacity(0.2),
          child:
              AppText('JB', fontSize: 25.px, color: AppColorConstant.appBlack),
        ),
        SizedBox(
          width: 30.px,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              S.of(Get.context!).userName,
              fontSize: 20.px,
            ),
            AppText('9904780294',
                color: AppColorConstant.appLightBlack, fontSize: 12.px),
          ],
        )
      ],
    );
  }

  buildSettingsList(SettingsController controller) {
    return ListView.builder(
      padding: EdgeInsets.all(12.px),
      shrinkWrap: true,
      itemCount: controller.settingItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              onTap: controller.settingItems[index].onTap,
              leading: Container(
                height: 50.px,
                width: 50.px,
                padding: EdgeInsets.all(12.px),
                decoration: BoxDecoration(
                    color: AppColorConstant.appTheme.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.px),
                    border: Border.all(color: AppColorConstant.appTheme)),
                child: AppImageAsset(
                  image:controller.settingItems[index].icon,
                ),
              ),
              title: AppText(
                fontSize: 15.px,
                controller.settingItems[index].title,
              )),
        );
      },
    );
  }
}
