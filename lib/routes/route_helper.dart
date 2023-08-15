
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:signal/pages/otp_pages/verify_otp_page.dart';
import 'package:signal/pages/signin_pages/sign_in_page.dart';
import 'package:signal/routes/route_constant.dart';

class RouteHelper {
  static String getSignInPage() => RouteConstant.signInPage;
  static String getVerifyOtpPage() => RouteConstant.verifyOtpScreen;

  static List<GetPage> routes = [
    GetPage(name: RouteConstant.signInPage, page: () => SignInPage()),
    GetPage(name: RouteConstant.verifyOtpScreen, page: () => VerifyOtpPage()),


  ];
}
