import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/model/settings_model.dart';
import 'package:signal/pages/settings/settings_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  SettingViewModel? settingViewModel;

  @override
  Widget build(BuildContext context) {
    logs('Current Screen---> $runtimeType');
    settingViewModel ?? (settingViewModel = SettingViewModel(this));
    return GetBuilder<SettingsController>(
      initState: (state) {},
      init: SettingsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColorConstant.appWhite,
          appBar: getAppbar(),
          body: buildSettingsList(controller),
        );
      },
    );
  }

  getAppbar() {
    return AppAppBar(
      title:
          AppText(AppLocalizations.of(Get.context!)!.settings, fontSize: 20.px),
    );
  }

  List<SettingsModel> settingItems = [
    SettingsModel(
      title: AppLocalizations.of(Get.context!)!.account,
      icon: AppAsset.account,
      onTap: () {
        languageDialog(Get.context!);
      },
    ),
    SettingsModel(
      title: AppLocalizations.of(Get.context!)!.appearance,
      icon: AppAsset.appearance,
      onTap: () {},
    ),
    SettingsModel(
      title: AppLocalizations.of(Get.context!)!.linkedDevice,
      icon: AppAsset.linkedDevice,
      onTap: () {},
    ),
    SettingsModel(
      title: AppLocalizations.of(Get.context!)!.donateToSignal,
      icon: AppAsset.donate,
      onTap: () {},
    ),
    SettingsModel(
      title: AppLocalizations.of(Get.context!)!.chats,
      icon: AppAsset.chats,
      onTap: () {},
    ),
    SettingsModel(
      title: AppLocalizations.of(Get.context!)!.privacyPolicy,
      icon: AppAsset.privacyPolicy,
      onTap: () {},
    ),
    SettingsModel(
      title: AppLocalizations.of(Get.context!)!.inviteFriends,
      icon: AppAsset.invite,
      onTap: () {},
    ),
  ];

  buildSettingsList(SettingsController controller) {
    return ListView.builder(
      padding: EdgeInsets.all(12.px),
      shrinkWrap: true,
      itemCount: settingItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              onTap: settingItems[index].onTap,
              leading: Container(
                height: 50.px,
                width: 50.px,
                padding: EdgeInsets.all(12.px),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.px),
                    border: Border.all(color: AppColorConstant.appTheme)),
                child: AppImageAsset(
                  image: settingItems[index].icon,
                ),
              ),
              title: AppText(
                fontSize: 15.px,
                settingItems[index].title,
              )),
        );
      },
    );
  }

  static languageDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: AppText(fontSize: 20.px, 'language'),
              actions: [
                Column(
                  children: [
                    RadioListTile(
                      fillColor: const MaterialStatePropertyAll(
                          AppColorConstant.appTheme),
                      title: AppText(AppLocalizations.of(context)!.english),
                      value: const Locale('en'),
                      groupValue: SettingViewModel.locale,
                      onChanged: (value) {
                        setState(() {
                          SettingViewModel.locale = value!;
                          SettingViewModel.updateLanguage(value);
                          setStringValue(getLanguage, 'en');
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: const MaterialStatePropertyAll(
                          AppColorConstant.appTheme),
                      title: AppText(AppLocalizations.of(context)!.gujarati),
                      value: const Locale('gu'),
                      groupValue: SettingViewModel.locale,
                      onChanged: (value) {
                        setState(() {
                          SettingViewModel.locale = value!;
                          SettingViewModel.updateLanguage(value);
                          setStringValue(getLanguage, 'gu');
                        });
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
