import 'dart:ui';

import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/generated/l10n.dart';

import 'package:signal/pages/settings/settings_screen.dart';
import 'package:signal/routes/routes_helper.dart';

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

  mainTap(index) {
    switch (index) {
      case 1:
        {}
        break;
      case 2:
        {
          Get.toNamed(RouteHelper.getAppearanceScreen());
        }
        break;
    }
  }
}
