import 'package:package_info_plus/package_info_plus.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/pages/settings/help/help_settings_screen.dart';

class HelpSettingViewModel{

  HelpSettingsScreen? helpSettingsScreen;
  String? localVersion;
  HelpSettingViewModel(this.helpSettingsScreen);

  getVersionStatus() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
   localVersion =  packageInfo.version;
    logs("verson---> $localVersion");
  }


}