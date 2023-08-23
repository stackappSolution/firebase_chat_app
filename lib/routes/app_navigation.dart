import 'package:get/get.dart';
import 'package:signal/routes/routes_helper.dart';


goToIntroPage(){
  Get.toNamed(RouteHelper.getIntroPage());
}

goToSignInPage(){
  Get.toNamed(RouteHelper.getSignInPage());
}

goToVerifyPage({required String arguments}){
  Get.toNamed(RouteHelper.getVerifyOtpPage());
}

goToProfilePage(){
  Get.toNamed(RouteHelper.getProfileScreen());
}

goToSettingPage(){
  Get.toNamed(RouteHelper.getSettingScreen());
}
