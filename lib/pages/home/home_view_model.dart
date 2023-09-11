import 'dart:ui';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/home/home_screen.dart';

class HomeViewModel {
  HomeScreen? homeScreen;
  HomeViewModel(this.homeScreen);

  getLocalizationKey() async {
    String? localeKey = await getStringValue(getLanguage);
    if (localeKey != null) {
      S.load(Locale(localeKey));
      Get.updateLocale(Locale(localeKey));
      logs('key---> $localeKey');
    }
    localeKey= Get.deviceLocale!.languageCode;
    Get.updateLocale(Locale(localeKey));
  }
}
