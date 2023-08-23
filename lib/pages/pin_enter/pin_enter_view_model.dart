import 'package:flutter/material.dart';
import 'package:signal/pages/pin_enter/pin_enter_screen.dart';
import 'package:signal/routes/app_navigation.dart';

import '../../app/app/utills/app_utills.dart';

class PinEnterViewModel {
  PinEnterScreen? pinEnterScreen;
  final pinController = TextEditingController();
  bool isButtonActive = false;
  bool changeKeyBoard = false;
  TextInputType keyboardType = TextInputType.text;

  PinEnterViewModel(this.pinEnterScreen);

  onPinChanged(newValue, controller) {
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

  void onKeyBoardChangeTap(controller) {
    pinController.clear();
    changeKeyBoard = !changeKeyBoard;
    logs("changeKeyBoard ------- > $changeKeyBoard");
    controller.update();
  }

  onNextTap(context) {
    goToProfilePage();
  }
}
