import 'dart:ui';

import 'package:get/get.dart';

import 'package:signal/pages/settings/settings_screen.dart';

class SettingViewModel {
  SettingScreen? settingsScreen;

  static Locale locale = const Locale('en');

  SettingViewModel(this.settingsScreen);

  static updateLanguage(Locale locale) {
    Get.updateLocale(locale);
    Get.back();
  }
}
