import 'package:get/get.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/model/settings_model.dart';
import 'package:signal/routes/route_helper.dart';

class SettingsController extends GetxController{



  List<SettingsModel> settingItems = [
    SettingsModel(
      title: S.of(Get.context!).account,
      icon: AppAsset.account,
      onTap: () {},
    ),
    SettingsModel(
      title: S.of(Get.context!).appearance,
      icon: AppAsset.appearance,
      onTap: () {
        Get.toNamed(RouteHelper.getAppearanceScreen());
      },
    ),
    SettingsModel(
      title: S.of(Get.context!).linkedDevice,
      icon: AppAsset.linkedDevice,
      onTap: () {},
    ),
    SettingsModel(
      title: S.of(Get.context!).donateToSignal,
      icon: AppAsset.donate,
      onTap: () {},
    ),
    SettingsModel(
      title: S.of(Get.context!).chats,
      icon: AppAsset.chats,
      onTap: () {},
    ),
    SettingsModel(
      title: S.of(Get.context!).privacyPolicy,
      icon: AppAsset.privacyPolicy,
      onTap: () {},
    ),
    SettingsModel(
      title: S.of(Get.context!).inviteFriends,
      icon: AppAsset.invite,
      onTap: () {},
    ),
  ];

}