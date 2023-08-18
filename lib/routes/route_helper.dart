import 'package:get/get_navigation/src/routes/get_route.dart';

import 'package:signal/pages/home/home_screen.dart';
import 'package:signal/pages/otp_pages/verify_otp_page.dart';

import 'package:signal/pages/appearance/appearance_screen.dart';
import 'package:signal/pages/home/home_screen.dart';
import 'package:signal/pages/intro_page/intro_page.dart';
import 'package:signal/pages/otp_pages/verify_otp_page.dart';
import 'package:signal/pages/profile/profile_screen.dart';

import 'package:signal/pages/settings/settings_screen.dart';
import 'package:signal/pages/signin_pages/sign_in_page.dart';
import 'package:signal/routes/route_constant.dart';

class RouteHelper {
  static String getSignInPage() => RouteConstant.signInPage;

  static String getVerifyOtpPage() => RouteConstant.verifyOtpScreen;
  static String getSettingsScreen() => RouteConstant.settingsScreen;
  static String getHomeScreen() => RouteConstant.homeScreen;



  static String getSettingScreen() => RouteConstant.settingScreen;

  static String getProfileScreen() => RouteConstant.profileScreen;
  static String getAppearanceScreen() => RouteConstant.appearanceScreen;

  static List<GetPage> routes = [
    GetPage(name: RouteConstant.signInPage, page: () => SignInPage()),
    GetPage(name: RouteConstant.verifyOtpScreen, page: () => VerifyOtpPage()),

    GetPage(name: RouteConstant.settingsScreen, page: () => SettingScreen()),
    GetPage(name: RouteConstant.homeScreen, page: () => HomeScreen()),



    GetPage(name: RouteConstant.profileScreen, page: () => ProfileScreen()),
    GetPage(name: RouteConstant.initial, page: () => IntroPage()),
    GetPage(name: RouteConstant.profileScreen, page: () => ProfileScreen()),
    GetPage(name: RouteConstant.appearanceScreen, page: () => AppearanceScreen()),
    GetPage(
      name: RouteConstant.signInPage,
      page: () => SignInPage(),
    ),
    GetPage(
      name: RouteConstant.verifyOtpScreen,
      page: () => VerifyOtpPage(),
    ),
    GetPage(
      name: RouteConstant.homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: RouteConstant.settingScreen,
      page: () => SettingScreen(),
    ),

  ];
}
