import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/chanage_phone_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/account/change_phone/change_phone_screen.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../service/auth_service.dart';

class ChangePhoneViewModel {
  ChangePhoneScreen? changePhoneNumberScreen;
  bool isPhoneNumberChange = false;
  bool isButtonActive = false;
  final oldNumberController = TextEditingController();
  final newNumberController = TextEditingController();
  String fireBaseStoredAccountNumber =
      AuthService.auth.currentUser!.phoneNumber.toString();
  String oldNumCountryCode = "+91";
  String newNumCountryCode = "+91";
  ChangePhoneController? controller;

  ChangePhoneViewModel(this.changePhoneNumberScreen) {
    Future.delayed(
      const Duration(milliseconds: 20),
      () {
        controller = Get.find<ChangePhoneController>();
      },
    );
  }

  continueTap(ChangePhoneController controller) {
    isPhoneNumberChange = true;
    controller.update();
  }

  finalContinueTap(ChangePhoneController controller, BuildContext context) {
    logs("current user num  ====>  ${fireBaseStoredAccountNumber}");

    if (isButtonActive) {
      showDialog(
        context: context,
        builder: (context) {
          return AppAlertDialog(
            insetPadding: EdgeInsets.zero,
            title: AppText("$newNumCountryCode${newNumberController.text}",
                fontSize: 25.px,color: Theme.of(context).colorScheme.primary),
            widget: AppText(
              S.of(context).checkAgainYourNumber,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12.px,
            ),
            actions: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.px, bottom: 10.px),
                    child: AppText(S.of(context).cancel,color: Theme.of(context).colorScheme.primary),
                  )),
              InkWell(
                  onTap: () {
                    controller.getDocId(
                        "$newNumCountryCode${newNumberController.text}",fireBaseStoredAccountNumber);
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.px, bottom: 10.px),
                    child: AppText(S.of(context).continues,color: Theme.of(context).colorScheme.primary,),
                  ))
            ],
          );
        },
      );
    }
  }

  onChangedNumber(ChangePhoneController controller) {
    if (("$oldNumCountryCode${oldNumberController.text}" ==
            fireBaseStoredAccountNumber) &&
        newNumberController.text.length == 10) {
      isButtonActive = true;
      controller.update();
    } else {
      isButtonActive = false;
      controller.update();
    }
  }
}
