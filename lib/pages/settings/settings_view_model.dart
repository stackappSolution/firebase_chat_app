import 'package:get/get.dart';
import 'package:signal/pages/settings/settings_screen.dart';
import 'package:signal/routes/routes_helper.dart';

class SettingViewModel {
  SettingScreen? settingsScreen;
  String? userName;

  SettingViewModel(this.settingsScreen);

  mainTap(index) {
    switch (index) {

      case 1:
        {

          Get.toNamed(RouteHelper.getAccountScreen());
        }
        break;
      case 2:
        {
          Get.toNamed(RouteHelper.getAppearanceScreen());
        }
        break;
      case 6:
        {
          Get.toNamed(RouteHelper.getPrivacyScreen());
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
