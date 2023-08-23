
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/chanage_phone_controller.dart';
import 'package:signal/pages/account/change_phone/change_phone_screen.dart';

import '../../../app/app/utills/app_utills.dart';

class ChangePhoneViewModel {
  ChangePhoneScreen? changePhoneNumberScreen;
  bool isPhoneNumberChange = false;
  final oldNumberController = TextEditingController();
  final newNumberController = TextEditingController();
  String fireBaseStoredAccountNumber = "";
  String oldNumCountryCode = "+91";
  String newNumCountryCode = "+91";

  ChangePhoneViewModel(this.changePhoneNumberScreen) {}

  continueTap(ChangePhoneController controller) {
    isPhoneNumberChange = true;
    controller.update();
  }

  finalContinueTap(ChangePhoneController controller, BuildContext context) {
    // if ("$oldNumCountryCode${oldNumberController.text}" ==
    //     fireBaseStoredAccountNumber) {
    if (true) {

      showDialog(
        context: context,
        builder: (context) {
          return AppAlertDialog(
            insetPadding: EdgeInsets.zero,
            title: AppText("${newNumCountryCode}${newNumberController.text}",fontSize: 25.px),
            widget: AppText(
              StringConstant.checkAgainYourNumber,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              fontSize: 12.px,
            ),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.px, bottom: 10.px),
                    child: const AppText(StringConstant.cansel),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.px, bottom: 10.px),
                    child: const AppText(StringConstant.continues),
                  ))
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AppAlertDialog(
            insetPadding: EdgeInsets.zero,
            widget: AppText(
              StringConstant.phoneNumberDoesNot,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              fontSize: 12.px,
            ),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.px, bottom: 10.px),
                    child: const AppText(StringConstant.ok),
                  ))
            ],
          );
        },
      );
      logs("do not match");
    }
    controller.update();
  }
}