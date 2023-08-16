import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/constant/string_constant.dart';

class ThemeUtil {
  static ThemeMode selectedTheme = ThemeMode.system;

  static Future loadThemeMode() async {
    await ThemeUtil.getThemeMode()
        .then((value) => ThemeUtil.selectedTheme = value);
  }

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.amber,
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.amber,
        disabledColor: Colors.grey,
      ));

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue,
        disabledColor: Colors.grey,
      ));

  static Future<ThemeMode> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeIndex = prefs.getInt(StringConstant.theme) ?? 0;
    return ThemeMode.values[themeIndex];
  }
}
