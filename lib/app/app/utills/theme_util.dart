import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/appearance_controller.dart';

import '../../../constant/color_constant.dart';
import 'app_utills.dart';

class ThemeUtil {
  static ThemeMode selectedTheme = ThemeMode.system;
  static bool isDark = false;

  static Future loadThemeMode() async {
    final controller = Get.put(AppearanceController());

    return await ThemeUtil.getThemeMode().then((value) {
      selectedTheme = value;
      logs("loadThemeMode----> $value");
      if (selectedTheme == ThemeMode.dark) {
        isDark = true;
        controller.update();
      } else {
        isDark = false;
        controller.update();
      }
      logs("loadThemeMode Is Dark----> $isDark");
    });
  }

  static Future<ThemeMode> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeIndex = prefs.getInt(StringConstant.theme) ?? 0;
    return ThemeMode.values[themeIndex];
  }
}

class Themes {
  static ThemeData darkTheme = ThemeData(
      appBarTheme:
          const AppBarTheme(backgroundColor: AppColorConstant.appBlack),
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: AppColorConstant.darkPrimary,
        primary: AppColorConstant.appWhite,
        secondary: AppColorConstant.darkSecondary,
      ));

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: AppColorConstant.appBlack),
          titleTextStyle: TextStyle(color: AppColorConstant.appBlack)),
      colorScheme: const ColorScheme.light(
        background: AppColorConstant.appWhite,
        primary: AppColorConstant.appBlack,
        secondary: AppColorConstant.darkSecondary,
      ),
  );
}
