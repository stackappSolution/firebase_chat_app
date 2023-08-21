import 'package:get/get.dart';
import 'package:signal/routes/routes_helper.dart';


goToSignInPage(){
  Get.toNamed(RouteHelper.getSignInPage());
}

goToVerifyPage({required String arguments}){
  Get.toNamed(RouteHelper.getVerifyOtpPage(),arguments: arguments);
}

goToProfilePage(){
  Get.toNamed(RouteHelper.getProfileScreen());
}

goToSettingPage(){
  Get.toNamed(RouteHelper.getSettingScreen());
}

goToHomeScreen(){
  Get.toNamed(RouteHelper.getHomeScreen());
}

goToIntroScreen(){
  Get.toNamed(RouteHelper.getIntroScreen());
}

goToChatingScreen(){
  Get.toNamed(RouteHelper.getChattingScreen());
}
