import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/appearance_controller.dart';
import 'package:signal/pages/appearance/appearance_screen.dart';
import 'package:signal/pages/edit_profile/edit_profile_screen.dart';

import '../../app/app/utills/app_utills.dart';
import '../../app/app/utills/shared_preferance.dart';
import '../../app/app/utills/theme_util.dart';

class AppearanceViewModel {
  AppearanceScreen? appearanceScreen;
  bool isLightTheme = false;
  ThemeMode _selectedTheme = ThemeUtil.selectedTheme;
  String? selectedLanguage;
  String? selectedFontSize;

  AppearanceViewModel(this.appearanceScreen) {}

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
              backgroundColor: AppColorConstant.blackOff,
              title: const AppText(StringConstant.theme),
              actions: [
                Column(
                  children: [
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.systemDefault),
                      value: ThemeMode.system,
                      groupValue: _selectedTheme,
                      onChanged: (value) {
                        setState(() {
                          _selectedTheme = value as ThemeMode;
                          Get.changeThemeMode(ThemeMode.light);
                          saveThemeMode(_selectedTheme);
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.light),
                      value: ThemeMode.light,
                      groupValue: _selectedTheme,
                      onChanged: (value) {
                        setState(() {
                          _selectedTheme = value as ThemeMode;
                          Get.changeThemeMode(ThemeMode.light);
                          saveThemeMode(_selectedTheme);
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.dark),
                      value: ThemeMode.dark,
                      groupValue: _selectedTheme,
                      onChanged: (value) {
                        setState(() {
                          _selectedTheme = value as ThemeMode;
                          Get.changeThemeMode(ThemeMode.dark);
                          saveThemeMode(_selectedTheme);
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

  languageDialog(
    context,
    AppearanceController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AppAlertDialog(
              backgroundColor: AppColorConstant.blackOff,

              title: const AppText(StringConstant.language),
              actions: [
                Column(
                  children: [
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.gujarati),
                      value: StringConstant.gujarati,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.english),
                      value: StringConstant.english,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
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
              backgroundColor: AppColorConstant.blackOff,

              title: const AppText(StringConstant.language),
              actions: [
                Column(
                  children: [
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColorConstant.appYellow),
                      title: const AppText(StringConstant.small),
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
                      title: const AppText(StringConstant.normal),
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
                      title: const AppText(StringConstant.large),
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
                      title: const AppText(StringConstant.extraLarge),
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
    setPrefStringValue(StringConstant.selectedFontSize, fontSize);
  }

  mainTap(index, context, AppearanceController controller) {
    switch (index) {
      case 1:
        {
          languageDialog(
            context,
            controller,
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
      case 6 :{
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EditProfileScreen();
        },));
      }
    }
  }

  loadSelectedFontSize() async {
    final fontSize =
        await getPrefStringValue(StringConstant.selectedFontSize) ??
            StringConstant.normal;
    selectedFontSize = fontSize.toString();
    logs("selectedFontSize-----$selectedFontSize");
    //controller.update();
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(StringConstant.theme, themeMode.index);
  }
}
