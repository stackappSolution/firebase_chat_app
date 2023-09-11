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
import '../../app/app/utills/theme_util.dart';
import 'package:signal/routes/routes_helper.dart';
import '../../app/app/utills/app_utills.dart';
import '../../app/app/utills/theme_util.dart';


class AppearanceViewModel {
  AppearanceScreen? appearanceScreen;
  bool isLightTheme = false;
  ThemeMode selectedTheme = ThemeUtil.selectedTheme;
  String? selectedLanguage;
  String? selectedFontSize;
  AppearanceController? controller;
  String? saveFontSize;
  Locale locale= Locale(Get.deviceLocale!.languageCode);

  AppearanceViewModel(this.appearanceScreen) {
    Future.delayed(
      const Duration(milliseconds: 100),
          () => controller = Get.find<AppearanceController>(),
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
              title: AppText(
                S.of(context).theme,
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
                      title: AppText(
                        S.of(context).systemDefault,
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
                      title: AppText(S.of(context).light,
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
                      title: AppText(S.of(context).dark,
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
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.px)),
              titlePadding: EdgeInsets.only(left: 15.px, top: 8.px),
              backgroundColor: AppColorConstant.appWhite,
              elevation: 0.0,
              contentPadding: EdgeInsets.zero,
              insetPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                    height: 1.px,
                    width: double.infinity,
                    color: AppColorConstant.grey.withOpacity(0.4),
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.only(left: 10.px),
                    fillColor: const MaterialStatePropertyAll(
                        AppColorConstant.appYellow),
                    title: AppText(S.of(context).systemDefault),
                    value: Locale(
                      Get.deviceLocale!.languageCode,
                    ),
                    groupValue: locale,
                    onChanged: (value) {
                      setState(() async {
                        locale = value!;
                        setStringValue(
                            getLanguage, Get.deviceLocale!.languageCode);
                        S.load((Locale(Get.deviceLocale!.languageCode)));
                        Get.updateLocale(locale!);
                        selectedLanguage = S.of(Get.context!).systemDefault;
                        setStringValue(language, selectedLanguage!);
                        saveFontSize =
                        await getStringValue(StringConstant.setFontSize);

                        if (selectedLanguage == S.of(Get.context!).gujarati) {
                          if (saveFontSize == "Large") {
                            logs('large');
                            saveSelectedFontSize("Large");
                          } else if (saveFontSize == "નાના") {
                            logs('Small');
                            saveSelectedFontSize('Small');
                          } else if (saveFontSize == "સામાન્ય") {
                            logs('Normal');
                            saveSelectedFontSize('Normal');
                          } else if (saveFontSize == "વધારાનું મોટું") {
                            logs('ExtraLarge');
                            saveSelectedFontSize('ExtraLarge');
                          }
                        }

                        if (selectedLanguage == S.of(Get.context!).english) {
                          if (saveFontSize == "Large") {
                            logs('વિશાળ');
                            saveSelectedFontSize("વિશાળ");
                          } else if (saveFontSize == "Small") {
                            logs('નાના');
                            saveSelectedFontSize('નાના');
                          } else if (saveFontSize == "Normal") {
                            logs('સામાન્ય');
                            saveSelectedFontSize('સામાન્ય');
                          } else if (saveFontSize == "ExtraLarge") {
                            logs('વધારાનું મોટું');
                            saveSelectedFontSize('વધારાનું મોટું');
                          }
                        }
                      });
                    },
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.only(left: 10.px),
                    fillColor: const MaterialStatePropertyAll(
                        AppColorConstant.appYellow),
                    title: AppText(S.of(context).english),
                    value: const Locale('en_US'),
                    groupValue: locale,
                    onChanged: (value) async {
                      saveFontSize = await getStringValue(StringConstant.setFontSize);

                      setState(()  {
                        locale = value!;
                        setStringValue(getLanguage, 'en_US');
                        S.load(const Locale('en_US'));
                        Get.updateLocale(locale!);
                        selectedLanguage = S.of(Get.context!).english;
                        setStringValue(language, selectedLanguage!);

                        if (selectedLanguage == "English") {
                          if (saveFontSize == "વિશાળ") {
                            logs('large');
                            saveSelectedFontSize("Large");
                          }

                          else if (saveFontSize == "નાના") {
                            logs('Small');
                            saveSelectedFontSize('Small');
                          }

                          else if (saveFontSize == "સામાન્ય" || saveFontSize == "Normal") {
                            logs('Normal');
                            saveSelectedFontSize('Normal');
                          }

                          else if (saveFontSize == "વધારાનું મોટું") {
                            logs('ExtraLarge');
                            saveSelectedFontSize('ExtraLarge');
                          }
                        }

                      });
                    },
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.only(left: 10.px),
                    fillColor: const MaterialStatePropertyAll(
                        AppColorConstant.appYellow),
                    title: AppText(S.of(context).gujarati),
                    value: const Locale('gu_IN'),
                    groupValue: locale,
                    onChanged: (value) async {
                      saveFontSize = await getStringValue(StringConstant.setFontSize);

                      setState(() async {

                        locale = value!;
                        S.load(const Locale('gu_IN'));
                        setStringValue(getLanguage, 'gu_IN');
                        Get.updateLocale(locale!);
                        selectedLanguage = S.of(Get.context!).gujarati;
                        setStringValue(language, selectedLanguage!);
                        saveFontSize = await getStringValue(StringConstant.setFontSize);

                        if (selectedLanguage == "ગુજરાતી") {
                          if (saveFontSize == "Large") {
                            logs('વિશાળ');
                            saveSelectedFontSize("વિશાળ");
                          } else if (saveFontSize == "Small") {
                            logs('નાના');
                            saveSelectedFontSize('નાના');
                          } else if (saveFontSize == "Normal") {
                            logs('સામાન્ય');
                            saveSelectedFontSize('સામાન્ય');
                          } else if (saveFontSize == "ExtraLarge") {
                            logs('વધારાનું મોટું');
                            saveSelectedFontSize('વધારાનું મોટું');
                          }
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.px,
                  )
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
              title: AppText(S.of(context).selectMember,
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
                      title: AppText(S.of(context).small,
                          color: AppColorConstant.appWhite),
                      value: S.of(context).small,
                      groupValue: saveFontSize,
                      onChanged: (value) async {
                        setState(() {
                          saveFontSize = S.of(context).small;
                        });
                        await saveSelectedFontSize(saveFontSize!);
                        controller.update();
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                              (states) => AppColorConstant.appYellow),
                      title: AppText(S.of(context).normal,
                          color: AppColorConstant.appWhite),
                      value: S.of(context).normal,
                      groupValue: saveFontSize,
                      onChanged: (value) async {
                        setState(() {
                          saveFontSize = S.of(context).normal;
                        });
                        await saveSelectedFontSize(saveFontSize!);
                        controller.update();
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                              (states) => AppColorConstant.appYellow),
                      title: AppText(S.of(context).large,
                          color: AppColorConstant.appWhite),
                      value: S.of(context).large,
                      groupValue: saveFontSize,
                      onChanged: (value) async {
                        setState(() {
                          saveFontSize = S.of(context).large;
                        });
                        await saveSelectedFontSize(saveFontSize!);
                        controller.update();
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateColor.resolveWith(
                              (states) => AppColorConstant.appYellow),
                      title: AppText(S.of(context).extraLarge,
                          color: AppColorConstant.appWhite),
                      value: S.of(context).extraLarge,
                      groupValue: saveFontSize,
                      onChanged: (value) async {
                        setState(() {
                          saveFontSize = S.of(context).extraLarge;
                        });
                        await saveSelectedFontSize(saveFontSize!);
                        controller.update();
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
    // logs(
    //     'setStringValue(StringConstant.selectedFontSize) : - $fontSize');
    setStringValue(StringConstant.setFontSize, fontSize);


    saveFontSize = await getStringValue(StringConstant.setFontSize);
    logs('getStringValue(StringConstant.selectedFontSize) : $saveFontSize');
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
      case 3:
        {
          Get.toNamed(RouteHelper.getChatColorWallpaperScreen());
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
        {}
    }
  }

  loadSelectedFontSize(context) async {
    final fontSize = await getStringValue(StringConstant.selectedFontSize) ??
        S.of(context).normal;
    selectedFontSize = fontSize.toString();
    logs("selectedFontSize-----$selectedFontSize");
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(StringConstant.theme, themeMode.index);
  }
}
