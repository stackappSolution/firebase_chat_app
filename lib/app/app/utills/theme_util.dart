import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/constant/string_constant.dart';

import '../../../constant/color_constant.dart';
import 'app_utills.dart';

class ThemeUtil {
  static ThemeMode selectedTheme = ThemeMode.system;
  static bool isDark = false;

  static Future loadThemeMode() async {
    return await ThemeUtil.getThemeMode().then((value) {
      selectedTheme = value;
      logs("loadThemeMode----> $value");
      if (selectedTheme == ThemeMode.dark) {
        ThemeUtil.isDark = true;
      } else {
        isDark = false;
      }
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
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: AppColorConstant.darkPrimary,
        primary: Colors.white,
        secondary: AppColorConstant.darkSecondary,
      ));

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black)),
      colorScheme: const ColorScheme.light(
        background: Colors.white,
        primary: Colors.black,
        secondary: AppColorConstant.darkSecondary,
      ));
}
