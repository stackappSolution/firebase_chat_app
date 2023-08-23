
import 'package:get/get.dart';
import 'package:signal/routes/routes_helper.dart';

goToIntroPage(){
  Get.toNamed(RouteHelper.getIntroPage());
}

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

goToChatingPage(){
  Get.toNamed(RouteHelper.getChatingPage());
}

goToSettingChatScreen(){
  Get.toNamed(RouteHelper.getSettingChatsScreen());
}

