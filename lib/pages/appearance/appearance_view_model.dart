import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/appearance_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/appearance/appearance_screen.dart';
import 'package:signal/pages/edit_profile/edit_profile_screen.dart';

import '../../app/app/utills/app_utills.dart';
import '../../app/app/utills/theme_util.dart';

class AppearanceViewModel {
  AppearanceScreen? appearanceScreen;
  bool isLightTheme = false;
  ThemeMode selectedTheme = ThemeUtil.selectedTheme;
  String? selectedLanguage;
  String? selectedFontSize;
  AppearanceController? controller;

  Locale? locale;

  AppearanceViewModel(this.appearanceScreen) {
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        controller = Get.find<AppearanceController>();
      },
    );
  }

  themeDialog(
    context,
    AppearanceController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AppAlertDialog(
              titlePadding:
                  EdgeInsets.only(top: 18.px, left: 35.px, bottom: 5.px),
              backgroundColor: AppColorConstant.blackOff,
              elevation: 0.0,
              contentPadding: EdgeInsets.zero,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              title: const AppText(
                StringConstant.theme,
                color: AppColorConstant.appWhite,
              ),
              actions: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      height: 2.px,
                      width: double.infinity,
                      color: AppColorConstant.grey.withOpacity(0.4),
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(
                        StringConstant.systemDefault,
                        color: AppColorConstant.appWhite,
                      ),
                      value: ThemeMode.system,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        setState(() {
                          selectedTheme = value as ThemeMode;
                          Get.changeThemeMode(ThemeMode.system);
                          saveThemeMode(selectedTheme);
                          ThemeUtil.loadThemeMode();
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.light,
                          color: AppColorConstant.appWhite),
                      value: ThemeMode.light,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        setState(() {
                          selectedTheme = value as ThemeMode;
                          Get.changeThemeMode(ThemeMode.light);
                          saveThemeMode(selectedTheme);
                          ThemeUtil.loadThemeMode();
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.dark,
                          color: AppColorConstant.appWhite),
                      value: ThemeMode.dark,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        setState(() {
                          selectedTheme = value as ThemeMode;
                          Get.changeThemeMode(ThemeMode.dark);
                          saveThemeMode(selectedTheme);
                          ThemeUtil.loadThemeMode();
                        });
                      },
                    )
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  languageDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AppAlertDialog(
              titlePadding: EdgeInsets.only(left: 15.px, top: 10.px),
              backgroundColor: AppColorConstant.appWhite,
              elevation: 0.0,
              contentPadding: EdgeInsets.zero,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              title: Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.all(10.px),
                  child: AppText(fontSize: 20.px, 'Language')),
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    height: 2.px,
                    width: double.infinity,
                    color: AppColorConstant.grey.withOpacity(0.4),
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.only(left: 10.px),
                    fillColor: const MaterialStatePropertyAll(
                        AppColorConstant.appTheme),
                    title: AppText(S.of(context).english),
                    value: const Locale('en_US'),
                    groupValue: locale,
                    onChanged: (value) {
                      setState(() {
                        locale = value!;
                        setStringValue(getLanguage, 'en_US');
                        S.load(const Locale('en_US'));
                        Get.updateLocale(locale!);
                        selectedLanguage = 'English';
                        setStringValue(language, selectedLanguage!);
                      });
                    },
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.only(left: 10.px),
                    fillColor: const MaterialStatePropertyAll(
                        AppColorConstant.appTheme),
                    title: AppText(S.of(context).gujarati),
                    value: const Locale('gu_IN'),
                    groupValue: locale,
                    onChanged: (value) {
                      setState(() {
                        locale = value!;
                        S.load(const Locale('gu_IN'));
                        setStringValue(getLanguage, 'gu_IN');
                        Get.updateLocale(locale!);
                        selectedLanguage = 'Gujarati';
                        setStringValue(language, selectedLanguage!);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  messageFontDialog(
    context,
    AppearanceController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AppAlertDialog(
              titlePadding:
                  EdgeInsets.only(top: 18.px, left: 35.px, bottom: 5.px),
              backgroundColor: AppColorConstant.blackOff,
              elevation: 0.0,
              contentPadding: EdgeInsets.zero,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              title: const AppText(StringConstant.language,
                  color: AppColorConstant.appWhite),
              actions: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      height: 2.px,
                      width: double.infinity,
                      color: AppColorConstant.grey.withOpacity(0.4),
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.small,
                          color: AppColorConstant.appWhite),
                      value: StringConstant.small,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                          saveSelectedFontSize(value!);
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.normal,
                          color: AppColorConstant.appWhite),
                      value: StringConstant.normal,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                          saveSelectedFontSize(value!);
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.large,
                          color: AppColorConstant.appWhite),
                      value: StringConstant.large,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                          saveSelectedFontSize(value!);
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.extraLarge,
                          color: AppColorConstant.appWhite),
                      value: StringConstant.extraLarge,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                          saveSelectedFontSize(value!);
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

  saveSelectedFontSize(String fontSize) async {
    setStringValue(StringConstant.selectedFontSize, fontSize);
  }

  mainTap(index, context, AppearanceController controller) {
    switch (index) {
      case 1:
        {
          languageDialog(
            context,
          );
        }
        break;
      case 2:
        {
          themeDialog(
            context,
            controller,
          );
        }
        break;
      case 5:
        {
          messageFontDialog(
            context,
            controller,
          );
        }
        break;
      case 6:
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return EditProfileScreen();
            },
          ));
        }
    }
  }

  loadSelectedFontSize() async {
    final fontSize = await getStringValue(StringConstant.selectedFontSize) ??
        StringConstant.normal;
    selectedFontSize = fontSize.toString();
    logs("selectedFontSize-----$selectedFontSize");
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(StringConstant.theme, themeMode.index);
  }
}
