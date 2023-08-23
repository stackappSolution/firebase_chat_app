import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/pages/settings/settings_screen.dart';
import 'package:signal/routes/routes_helper.dart';

class SettingViewModel {
  SettingScreen? settingsScreen;

  SettingViewModel(this.settingsScreen);

  mainTap(index) {
    switch (index) {

      case 1:
        {
          logs("goto  $index");
          Get.toNamed(RouteHelper.getAccountScreen());
        }
        break;
      case 2:
        {
          Get.toNamed(RouteHelper.getAppearanceScreen());
        }
        break;
      case 8:
        {
          Get.toNamed(RouteHelper.getHelpSettingsScreen());
        }
        break;
    }
  }
}
