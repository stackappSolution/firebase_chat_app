import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/constant/string_constant.dart';

import 'app_utills.dart';

class ThemeUtil {
  static ThemeMode selectedTheme = ThemeMode.system;
  static bool isDark = false;

  static Future loadThemeMode() async {
    return await ThemeUtil.getThemeMode().then((value) {
      selectedTheme = value;
      logs("loadThemeMode----> ${value}");
      if (selectedTheme == ThemeMode.dark) {
        ThemeUtil.isDark = true;
      } else {
        isDark = false;
      }
    });
  }

  static ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
      textTheme: Theme.of(context)
          .textTheme
          .copyWith(
            titleSmall:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 11),
          )
          .apply(
            bodyColor: isDarkTheme ? Colors.white : Colors.black,
            displayColor: Colors.grey,
          ),
      listTileTheme: ListTileThemeData(
          iconColor: isDarkTheme ? Colors.orange : Colors.purple),
      appBarTheme: AppBarTheme(
          backgroundColor: isDarkTheme ? Colors.black : Colors.white,
          iconTheme: IconThemeData(
              color: isDarkTheme ? Colors.white : Colors.black54)),
    );
  }

  static Future<ThemeMode> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeIndex = prefs.getInt(StringConstant.theme) ?? 0;
    return ThemeMode.values[themeIndex];
  }
}

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.white,
    bottomAppBarColor: Colors.cyan,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.cyan,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      bodyText2: TextStyle(
        //color: Colors.black, // Set the body text color for light theme
      ),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
   // backgroundColor: Colors.black,
    bottomAppBarColor: Colors.deepPurple,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      bodyText2: TextStyle(
        color: Colors.white, // Set the body text color for dark theme
      ),
    ),
  );
}
