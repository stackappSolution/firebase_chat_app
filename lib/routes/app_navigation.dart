import 'package:get/get.dart';
import 'package:signal/routes/routes_helper.dart';





goToSignInPage() {
  Get.toNamed(RouteHelper.getSignInPage());
}

goToVerifyPage({required String arguments}) {
  Get.toNamed(RouteHelper.getVerifyOtpPage(), arguments: arguments);
}

goToProfilePage() {
  Get.toNamed(RouteHelper.getProfileScreen());
}

goToSettingPage() {
  Get.toNamed(RouteHelper.getSettingScreen());
}

goToHomeScreen() {
  Get.toNamed(RouteHelper.getHomeScreen());
}

goToChattingPage() {
  Get.toNamed(RouteHelper.getChattingScreen());
}

goToAddPhotoScreen() {
  Get.toNamed(RouteHelper.getAddPhotoScreen());
}

goToAccountScreen() {
  Get.toNamed(RouteHelper.getAccountScreen());
}

goToPinSettingScreen() {
  Get.toNamed(RouteHelper.getChangePinScreen());
}


goToAdvancePinSettingScreen() {
  Get.toNamed(RouteHelper.getAdvancePinSettingScreen());
}

goToChangePhoneScreen() {
  Get.toNamed(RouteHelper.getChangePhoneScreen());

goToSignInPage(){
  Get.toNamed(RouteHelper.getSignInPage());
}

goToVerifyPage({required String arguments}){
  Get.toNamed(RouteHelper.getVerifyOtpPage());
  Get.toNamed(RouteHelper.getVerifyOtpPage(),arguments: arguments);
}

goToProfilePage(){
  Get.toNamed(RouteHelper.getProfileScreen());
}

goToSettingPage(){
  Get.toNamed(RouteHelper.getSettingScreen());
}
}



goToIntroScreen(){
  Get.toNamed(RouteHelper.getIntroScreen());
}

goToChatingScreen(){
  Get.toNamed(RouteHelper.getChattingScreen());
}
