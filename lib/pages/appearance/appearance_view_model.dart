import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/appearance_controller.dart';
import 'package:signal/pages/appearance/appearance_screen.dart';


class AppearanceViewModel {
  AppearanceScreen? appearanceScreen;
  bool isLightTheme = false;
  ThemeMode _selectedTheme = ThemeMode.light;
  AppearanceViewModel(this.appearanceScreen) {}
  themeTap(
    context,
    AppearanceController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AppAlertDialog(
              title: const AppText(StringConstant.theme),
              actions: [
                Column(
                  children: [
                    RadioListTile(
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
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', themeMode.index);
  }

}
