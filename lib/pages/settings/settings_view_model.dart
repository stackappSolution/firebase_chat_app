import 'dart:ui';

import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/generated/l10n.dart';

import 'package:signal/pages/settings/settings_screen.dart';

class SettingViewModel {

  SettingScreen? settingsScreen;

  SettingViewModel(this.settingsScreen);
  getLocalizationKey() async {
    String? localeKey = await getStringValue(getLanguage);
    if (localeKey != null) {
      S.load(Locale(localeKey));
      logs('key---> $localeKey');
    }
  }
}
