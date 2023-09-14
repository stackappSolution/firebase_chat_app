import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:signal/pages/settings/settings_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import '../../routes/app_navigation.dart';
import '../../service/auth_service.dart';

class SettingViewModel {
  SettingScreen? settingsScreen;
  String? userName;

  SettingViewModel(this.settingsScreen);

  mainTap(index) async {
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
      case 5:
        {
          goToChatContactScreen();
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
      case 9:
        {
          logOut();
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          String? fcmToken = await messaging.getToken();
          if (fcmToken != null) {
            await messaging.deleteToken();
            print('Deleted FCM Token: $fcmToken');
          }
          goToIntroPage();

        }
        break;
    }
  }

  void logOut()
  {
    AuthService.auth.signOut();
  }
}
