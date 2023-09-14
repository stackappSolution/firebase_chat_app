import 'dart:io';

import 'package:get/get.dart';
import 'package:signal/routes/routes_helper.dart';

goToIntroPage() {
  Get.toNamed(RouteHelper.getIntroScreen());
}

goToSignInPage() {
  Get.offAllNamed(RouteHelper.getSignInPage());
}

goToVerifyPage({required String phonenumber, selectedCountry}) {
  Get.toNamed(RouteHelper.getVerifyOtpPage(), parameters: {
    "phoneNo": phonenumber,
     "selectedCountry": selectedCountry.toString(),
  }, );
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

goToNewMessageScreen() {
  Get.toNamed(RouteHelper.getNewMessageScreen());
}
goToNewGroupScreen() {
  Get.toNamed(RouteHelper.getNewGroupScreen());
}

goToChatContactScreen() {
  Get.toNamed(RouteHelper.getChatContactScreen());
}

goToAttachmentScreen(selectedImage, members) {
  Get.toNamed(RouteHelper.getAttachmentScreen(), arguments: {
    "image": selectedImage,
    "members": members,
  },);
}
