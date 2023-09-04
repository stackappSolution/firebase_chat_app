import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/routes/app_navigation.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../app/widget/app_text.dart';
import 'advance_pin_setting.dart';

class AdvancePinViewModel {
  AdvancePinSettingScreen? advancePinSettingScreen;
  String firebaseStoredPin = "";

  AdvancePinViewModel(this.advancePinSettingScreen);

  disablePinTap(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AppAlertDialog(
          insetPadding: EdgeInsets.zero,
          title: AppText(
            S.of(context).warning,
            fontSize: 18.px,
          ),
          widget: AppText(
            S.of(context).ifYouDisable,
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 13.px,
          ),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.px),
                  child:  AppText(S.of(context).cancel),
                )),
            Padding(
              padding:
                  EdgeInsets.only(right: 20.px, left: 20.px, bottom: 15.px),
              child: InkWell(
                onTap: () {
                  if (firebaseStoredPin == "") {
                    goToPinSettingScreen();
                  } else {
                    logs("pin disabled, changes in firebase");
                  }
                },
                child:  AppText(
                  S.of(context).disablePIN,
                  color: AppColorConstant.red,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
