import 'package:flutter/material.dart';
import 'package:signal/controller/pin_setting_controller.dart';
import 'package:signal/pages/account/pin_setting/pin_setting_screen.dart';
import 'package:signal/pages/set_pin/set_pin_screen.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../controller/set_pin_controller.dart';

class SetPinViewModel {
  SetPinScreen? setPinScreen;
  int? cursorPosition;
  final pinController = TextEditingController();
  final conformPinController = TextEditingController();
  final pageController = PageController();
  bool changeKeyBoard = false;
  bool isButtonActive = false;
  bool isConformPage = false;
  FocusNode focusNode = FocusNode();

  String newPin = "";

  SetPinViewModel(this.setPinScreen);

  onPinChanged(newValue, SetPinController controller) {
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

  onPinConformChanged(newValue, SetPinController controller) {
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

  onKeyBoardChangeTap(SetPinController controller) {
    changeKeyBoard = !changeKeyBoard;
    pinController.clear();
    logs("changeKeyBoard --------> $changeKeyBoard");
    controller.update();
  }

  nextCreateButtonTap(SetPinController controller) {
    isConformPage = true;
    isButtonActive = false;
    newPin = pinController.text;
    pinController.clear();
    logs("next tapped");
    logs("new pin -------->  $newPin");
    controller.update();
  }

  nextConformButtonTap(SetPinController controller) {
    logs("next conform tapped------> ${conformPinController.text}");
    controller.update();
  }
}
