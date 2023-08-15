import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:signal/pages/home/home_screen.dart';
import 'package:signal/pages/intro_page/intro_page.dart';
import 'package:signal/routes/routes_constant.dart';

class RouteHelper {
  static String getSignInPage() => RouteConstant.signInPage;

  static String getVerifyOtpPage() => RouteConstant.verifyOtpScreen;

  static String getHomeScreen() => RouteConstant.homeScreen;

  static List<GetPage> routes = [
    GetPage(name: RouteConstant.homeScreen, page: () => HomeScreen()),

    GetPage(name: RouteConstant.initial, page: () => IntroPage()),
  ];
}
