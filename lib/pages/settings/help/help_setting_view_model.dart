import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/help_setting_controller.dart';
import 'package:signal/pages/settings/help/help_settings_screen.dart';

class HelpSettingViewModel{

  HelpSettingsScreen? helpSettingsScreen;
  String? localVersion;
  HelpSettingController? controller;



  HelpSettingViewModel(this.helpSettingsScreen){
    Future.delayed(Duration(milliseconds: 0),() {
      controller = Get.find<HelpSettingController>();
    },);
  }

  getVersionStatus() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
   localVersion =  packageInfo.version;
   controller!.update();
    logs("verson---> $localVersion");
  }


}