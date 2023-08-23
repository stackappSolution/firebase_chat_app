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

import '../../app/app/utills/app_utills.dart';
import '../../app/app/utills/shared_preferance.dart';
import '../../app/app/utills/theme_util.dart';

class AppearanceViewModel {
  AppearanceScreen? appearanceScreen;
  bool isLightTheme = false;
  ThemeMode _selectedTheme = ThemeUtil.selectedTheme;
  String? selectedLanguage;
  String selectedFontSize = StringConstant.normal;
  AppearanceController? controller;

  Locale? locale;


  AppearanceViewModel([this.appearanceScreen]) {
    Future.delayed(const Duration(milliseconds: 100), () {
      controller = Get.find<AppearanceController>();
    });
  }

  messageFontDialog(context, AppearanceController controller) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AppAlertDialog(
                backgroundColor: AppColorConstant.blackOff,
                title: const AppText(StringConstant.language),
                actions: [
                  Column(children: [
                    RadioListTile(
                        fillColor:
                            MaterialStateColor.resolveWith((states) => AppColorConstant.appYellow),
                        title: const AppText(StringConstant.small),
                        value: StringConstant.small,
                        groupValue: selectedFontSize,
                        onChanged: (value) {
                          setState(() {
                            selectedFontSize = value!;
                            logs(value);
                            setStringValue(getFontSize, 'small');
                            setStringValue(fontSizes, selectedFontSize);
                            // loadSelectedFontSize();
                            logs('getPrefStringValue : $selectedFontSize');
                            saveSelectedFontSize(value);
                            logs('selectedFontSize :$selectedFontSize');
                      controller.update();
                          });
                        }),
                    RadioListTile(
                        fillColor:
                            MaterialStateColor.resolveWith((states) => AppColorConstant.appYellow),
                        title: const AppText(StringConstant.normal),
                        value: StringConstant.normal,
                        groupValue: selectedFontSize,
                        onChanged: (value) {
                          setState(() {
                            selectedFontSize = value!;
                            logs(value);

                            setStringValue(getFontSize, 'normal');
                            setStringValue(fontSizes, selectedFontSize);
                            // loadSelectedFontSize();
                            logs('getPrefStringValue : $selectedFontSize');
                            saveSelectedFontSize(value);

                            logs('selectedFontSize :$selectedFontSize');
                            controller.update();
                          });
                        }),
                    RadioListTile(
                        fillColor:
                            MaterialStateColor.resolveWith((states) => AppColorConstant.appYellow),
                        title: const AppText(StringConstant.large),
                        value: StringConstant.large,
                        groupValue: selectedFontSize,
                        onChanged: (value) {
                          setState(() {
                            selectedFontSize = value!;
                            logs(value);

                            setStringValue(getFontSize, 'large');
                            setStringValue(fontSizes, selectedFontSize);
                            // loadSelectedFontSize();
                            logs('getPrefStringValue : $selectedFontSize');
                            saveSelectedFontSize(value);
                            logs('selectedFontSize :$selectedFontSize');

                            controller.update();
                          });
                        }),
                    RadioListTile(
                        fillColor:
                            MaterialStateColor.resolveWith((states) => AppColorConstant.appYellow),
                        title: const AppText(StringConstant.extraLarge),
                        value: StringConstant.extraLarge,
                        groupValue: selectedFontSize,
                        onChanged: (value) {
                          setState(() {
                            selectedFontSize = value!;
                            logs(value);

                            setStringValue(getFontSize, 'extraLarge');
                            getStringValue(getFontSize);
                            // loadSelectedFontSize();

                            saveSelectedFontSize(value);

                            logs('selectedFontSize :$selectedFontSize');
                            controller.update();
                          });
                        })
                  ])
                ]);
          });
        });
  }

  saveSelectedFontSize(String fontSize) async {
    setPrefStringValue(StringConstant.selectedFontSize, fontSize);
  }

  loadSelectedFontSize() async {
    final fontSize = await getPrefStringValue(StringConstant.selectedFontSize);
    selectedFontSize = fontSize.toString();
    logs("selectedFontSize-----$selectedFontSize");
  }

  themeDialog(context, AppearanceController controller) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AppAlertDialog(
                backgroundColor: AppColorConstant.blackOff,
                title: const AppText(StringConstant.theme),
                actions: [
                  Column(children: [
                    RadioListTile(
                        fillColor:
                            MaterialStateColor.resolveWith((states) => AppColorConstant.appYellow),
                        title: const AppText(StringConstant.systemDefault),
                        value: ThemeMode.system,
                        groupValue: _selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value as ThemeMode;
                            Get.changeThemeMode(ThemeMode.light);
                            saveThemeMode(_selectedTheme);
                          });
                        }),
                    RadioListTile(
                        fillColor:
                            MaterialStateColor.resolveWith((states) => AppColorConstant.appYellow),
                        title: const AppText(StringConstant.light),
                        value: ThemeMode.light,
                        groupValue: _selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value as ThemeMode;
                            Get.changeThemeMode(ThemeMode.light);
                            saveThemeMode(_selectedTheme);
                          });
                        }),
                    RadioListTile(
                        fillColor:
                            MaterialStateColor.resolveWith((states) => AppColorConstant.appYellow),
                        title: const AppText(StringConstant.dark),
                        value: ThemeMode.dark,
                        groupValue: _selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value as ThemeMode;
                            Get.changeThemeMode(ThemeMode.dark);
                            saveThemeMode(_selectedTheme);
                          });
                        })
                  ])
                ]);
          });
        });
  }

  languageDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                titlePadding: EdgeInsets.only(left: 15.px, top: 10.px),
                backgroundColor: AppColorConstant.appWhite,
                elevation: 0.0,
                contentPadding: EdgeInsets.zero,
                insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                title: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.all(10.px),
                    child: AppText(fontSize: 20.px, 'Language')),
                content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.zero,
                          height: 2.px,
                          width: double.infinity,
                          color: AppColorConstant.grey.withOpacity(0.4)),
                      RadioListTile(
                          contentPadding: EdgeInsets.only(left: 10.px),
                          fillColor: const MaterialStatePropertyAll(AppColorConstant.appTheme),
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
                          }),
                      RadioListTile(
                          contentPadding: EdgeInsets.only(left: 10.px),
                          fillColor: const MaterialStatePropertyAll(AppColorConstant.appTheme),
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
                          })
                    ]));
          });
        });
  }

  mainTap(index, context, AppearanceController controller) {
    switch (index) {
      case 1:
        languageDialog(context);
        break;
      case 2:
        themeDialog(context, controller);
        break;
      case 5:
        messageFontDialog(context, controller);
        break;
    }
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(StringConstant.theme, themeMode.index);
  }

  String getSelectedFontSize() {
    return selectedFontSize;
  }
}
