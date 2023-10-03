import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:signal/controller/pin_setting_controller.dart';
import 'package:signal/pages/account/pin_setting/pin_setting_screen.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../app/app/utills/toast_util.dart';
import '../../../service/auth_service.dart';

class PinSettingViewModel {
  PinSettingScreen? pinSettingScreen;
  int? cursorPosition;
  final pinController = TextEditingController();
  final conformPinController = TextEditingController();
  final pageController = PageController();
  bool changeKeyBoard = false;
  bool isLoading = false;
  bool isButtonActive = false;
  bool isConformPage = false;
  FocusNode focusNode = FocusNode();
  final users = FirebaseFirestore.instance.collection("users");

  String newPin = "";

  PinSettingViewModel(this.pinSettingScreen);

  onPinChanged(newValue, PinSettingController controller) {
    if (newValue.toString().length >= 4) {
      isButtonActive = true;
      logs("isButtonActive---------$isButtonActive");
      controller.update();
    } else {
      isButtonActive = false;
      logs("isButtonActive---------$isButtonActive");

      controller.update();
    }
  }

  onPinConformChanged(newValue, PinSettingController controller) {
    if (newValue.toString() == newPin) {
      isButtonActive = true;
      logs("isButtonActive---------$isButtonActive");
      controller.update();
    } else {
      isButtonActive = false;
      logs("isButtonActive---------$isButtonActive");

      controller.update();
    }
  }

  onKeyBoardChangeTap(PinSettingController controller) {
    changeKeyBoard = !changeKeyBoard;
    pinController.clear();
    logs("changeKeyBoard ------- > $changeKeyBoard");
    controller.update();
  }

  nextCreateButtonTap(PinSettingController controller) {
    isConformPage = true;
    isButtonActive = false;
    newPin = pinController.text;
    pinController.clear();
    logs("next tapped");
    logs("new pin ======>  $newPin");
    controller.update();
  }

  nextConformButtonTap(PinSettingController controller) {
    logs("next conform tapped------> ${conformPinController.text}");
    updatePin(controller);
    controller.update();
  }

  Future<void> updatePin(PinSettingController controller) async {
    isLoading = true;
    controller.update();
    try {
      await users.doc(AuthService.auth.currentUser!.uid).update({
        'pin': conformPinController.text,
      });
      ToastUtil.successToast("Successfully pin update");
      logs('Successfully pin update');
      Get.back();
      isLoading = false;
      controller.update();
    } catch (e) {
      ToastUtil.successToast("Error pin update: $e");
      logs('Error pin update: $e');
      isLoading = false;
      controller.update();
    }
  }
}
