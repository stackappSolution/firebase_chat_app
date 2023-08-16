import 'dart:ui';

import 'package:get/get.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/pages/home/home_screen.dart';

class HomeViewModel {
  HomeScreen? homeScreen;

  HomeViewModel(this.homeScreen);

  getLocalizationKey() async {
    String? localeKey = await getStringValue(getLanguage);
    if (localeKey != null) {
      await Get.updateLocale(Locale(localeKey));
    }
  }
}
