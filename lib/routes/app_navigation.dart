import 'package:get/get.dart';
import 'package:signal/routes/routes_helper.dart';

goToIntroPage() {
  Get.toNamed(RouteHelper.getIntroScreen());
}

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

goToAppearanceScreen() {
  Get.toNamed(RouteHelper.getAppearanceScreen());
}

goToAdvancePinSettingScreen() {
  Get.toNamed(RouteHelper.getAdvancePinSettingScreen());
}

goToChangePhoneScreen() {
  Get.toNamed(RouteHelper.getChangePhoneScreen());
}

goToIntroScreen() {
  Get.toNamed(RouteHelper.getIntroScreen());
}

goToChatingScreen() {
  Get.toNamed(RouteHelper.getChattingScreen());
}

goToPinEnterScreen() {
  Get.toNamed(RouteHelper.getPinEnterScreen());
}
goToNewMessageScreen(){
  Get.toNamed(RouteHelper.getNewMessageScreen());
}
