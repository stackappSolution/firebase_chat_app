import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signal/pages/set_pin/set_pin_screen.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../app/app/utills/toast_util.dart';
import '../../controller/set_pin_controller.dart';
import '../../service/auth_service.dart';
import '../home/home_screen.dart';

class SetPinViewModel {
  SetPinScreen? setPinScreen;
  int? cursorPosition;
  final pinController = TextEditingController();
  final conformPinController = TextEditingController();
  Color primaryTheme = Theme.of(Get.context!).colorScheme.primary;
  Color secondaryTheme = Theme.of(Get.context!).colorScheme.secondary;
  final pageController = PageController();
  bool changeKeyBoard = false;
  bool isButtonActive = false;
  bool isConformPage = false;
  FocusNode focusNode = FocusNode();

  String newPin = "";

  SetPinViewModel(this.setPinScreen);

  void onPinChanged(newValue, SetPinController controller) {
    if (newValue.toString().length >= 4) {
      isButtonActive = true;
      logs("isButtonActive---------> $isButtonActive");
      controller.update();
    } else {
      isButtonActive = false;
      logs("isButtonActive---------> $isButtonActive");

      controller.update();
    }
  }

  void onPinConformChanged(newValue, SetPinController controller) {
    if (newValue.toString() == newPin) {
      isButtonActive = true;
      logs("isButtonActive---------> $isButtonActive");
      controller.update();
    } else {
      isButtonActive = false;
      logs("isButtonActive---------> $isButtonActive");

      controller.update();
    }
  }

  void onKeyBoardChangeTap(SetPinController controller) {
    changeKeyBoard = !changeKeyBoard;
    pinController.clear();
    logs("changeKeyBoard --------> $changeKeyBoard");
    controller.update();
  }

  void nextCreateButtonTap(SetPinController controller) {
    isConformPage = true;
    isButtonActive = false;
    newPin = pinController.text;
    pinController.clear();
    logs("next tapped");
    logs("new pin -------->  $newPin");
    controller.update();
  }

  void nextConformButtonTap(SetPinController controller) {
    logs("next conform tapped------> ${conformPinController.text}");
    controller.update();
  }
}

class EnterPinViewModel {
  EnterPinScreen? enterPin;
  bool changeKeyBoard = false;
  bool isButtonActive = false;
  bool isLoading = false;
  FocusNode focusNode = FocusNode();
  String? token;
  final users = FirebaseFirestore.instance.collection('users');

  EnterPinViewModel(this.enterPin);

  TextEditingController pinController = TextEditingController();

  void onPinChanged(newValue, EnterPinController controller) {
    if (newValue.toString().length >= 4) {
      isButtonActive = true;
      logs("isButtonActive---------> $isButtonActive");
      controller.update();
    } else {
      isButtonActive = false;
      logs("isButtonActive---------> $isButtonActive");
      controller.update();
    }
  }

  void rightPin(context, EnterPinController controller, pin) async {
    isLoading = true;
    controller.update();
    FocusScope.of(context).nextFocus();
    logs('Enter PIN ------> ${pinController.text}');
    if (pin == pinController.text) {
      Get.to(HomeScreen());
      ToastUtil.successToast("Pin Verify");
      token = await FirebaseMessaging.instance.getToken();
      logs('New Token ----> $token');
      updateUserName(controller, token ?? '');
    } else {
      ToastUtil.warningToast("Pin Wrong");
    }
    isButtonActive = false;
    pinController.clear();
    logs("next tapped");
    isLoading = false;
    controller.update();
  }

  Future<void> updateUserName(
      EnterPinController controller, String newToken) async {
    try {
      isLoading = true;
      controller.update();

      await users.doc(AuthService.auth.currentUser!.uid).update({
        'fcmToken': newToken,
      });
      logs('Successfully updated user profile picture');
      ToastUtil.successToast("Name Updated");
      controller.update();

      isLoading = false;
      controller.update();
    } catch (e) {
      logs('Error updating user profile picture: $e');
      isLoading = false;
      controller.update();
    }
  }
}
