import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/acccount_controller.dart';
import 'package:signal/routes/app_navigation.dart';

import 'account_screen.dart';

class AccountViewModel {
  AccountScreen? accountScreen;
  bool isPinReminderActive = true;
  bool isRegistrationLockActive = false;
  bool changeKeyBoard = false;
  bool isError = false;
  String firebaseStoredPin = "";
  final pinController = TextEditingController();

  AccountViewModel(this.accountScreen) {}

  changePinTap() {
    goToPinSettingScreen();
  }

  onKeyBoardChangeTap(controller) {
    changeKeyBoard = !changeKeyBoard;
    pinController.clear();
    logs("changeKeyBoard ------- > $changeKeyBoard");
    controller.update();
  }

  onAdvancePinSettingTap() {
    goToAdvancePinSettingScreen();
  }

  changePhoneTap() {
    goToChangePhoneScreen();
  }

  pinReminderTap(context, AccountController controller) {
    isPinReminderActive = !isPinReminderActive;
    logs("isSwitchActive------$isPinReminderActive");
    if (!isPinReminderActive) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return OrientationBuilder(
                builder: (context, orientation) {
                  return AppAlertDialog(
                    title: AppText(
                      StringConstant.conformYourChatAppPIN,
                      fontSize: 16.px,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    insetPadding: EdgeInsets.zero,
                    widget: SizedBox(
                     // height: 200.px,
                      width: orientation == Orientation.portrait
                          ? 100.px
                          : 300.px,
                      height: orientation == Orientation.portrait ?200.px:100.px,
                      child: Column(children: [
                        Expanded(
                          child: AppText(textAlign:TextAlign.center,
                            StringConstant.makeSureYou,
                            color: AppColorConstant.darkSecondary,
                            fontSize: 14.px,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 20.px, left: 30.px, right: 30.px),
                            child: TextField(
                              controller: pinController,
                              obscureText: true,
                              keyboardType: (changeKeyBoard)
                                  ? TextInputType.text
                                  : TextInputType.number,
                              textAlign: TextAlign.center,
                              autofocus: true,
                              inputFormatters: (!changeKeyBoard)
                                  ? [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ]
                                  : [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z0-9]')),
                                    ],
                              decoration: const InputDecoration(
                                  filled: true, border: UnderlineInputBorder()),
                              onChanged: (value) {
                                // pinSettingViewModel!.onPinChanged(value, controller);
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.px, right: 20.px, top: 30.px),
                              child: InkWell(
                                  onTap: () {
                                    setState(
                                      () {
                                        onKeyBoardChangeTap(controller);
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      if (changeKeyBoard)
                                        const Icon(
                                          Icons.keyboard_alt_outlined,
                                          color: AppColorConstant.blue,
                                        )
                                      else
                                        const Icon(
                                          Icons.keyboard_alt,
                                          color: AppColorConstant.blue,
                                        ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.px),
                                        child: AppText(
                                            StringConstant.switchKeyboard,
                                            fontSize: 13.px,
                                            color: AppColorConstant.blue),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        if (isError)
                          Padding(
                            padding: EdgeInsets.only(top: 10.px),
                            child: AppText(
                              StringConstant.incorrectPinTryAgain,
                              color: AppColorConstant.red,
                              fontSize: 12.px,
                            ),
                          )
                      ]),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.px),
                        child: InkWell(
                          onTap: () {
                            isPinReminderActive = true;
                            logs(
                                "isPinReminderActive=======>$isPinReminderActive");
                                Get.back();
                            controller.update();
                          },
                          child: const AppText(
                            StringConstant.cansel,
                            color: AppColorConstant.appYellow,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 20.px, left: 10.px, right: 10.px),
                        child: InkWell(
                          onTap: () {
                            if (pinController.text != firebaseStoredPin) {
                              setState(
                                () {
                                  isError = true;
                                },
                              );
                            } else {
                              setState(
                                () {
                                  isError = false;
                                },
                              );
                            }
                          },
                          child: const AppText(StringConstant.turnOff,
                              color: AppColorConstant.appYellow),
                        ),
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      );
    }

    controller.update();
  }

  registrationLockTap(context, AccountController controller) {
    // isRegistrationLockActive = !isRegistrationLockActive;
    logs("isSwitchActive------$isRegistrationLockActive");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AppAlertDialog(
              title: (isRegistrationLockActive)
                  ?null
                  : AppText(
                      StringConstant.turnOnRegistration,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16.px,
                    ),
              insetPadding: EdgeInsets.zero,

              widget:(isRegistrationLockActive) ?AppText(
                StringConstant.turnOffRegistration,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16.px,
              ):SizedBox(
                height: (!isRegistrationLockActive) ? 100.px : 50.px,
                width: 100.px,
                child: Column(children: [
                  if (!isRegistrationLockActive)
                    AppText(
                      StringConstant.ifYouForgetYourPIN,
                      color: AppColorConstant.darkSecondary,
                      fontSize: 14.px,
                    )
                ]),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20.px),
                  child: InkWell(
                    onTap: () {
                          Get.back();
                      controller.update();
                    },
                    child: const AppText(
                      StringConstant.cansel,
                      color: AppColorConstant.appYellow,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 20.px, left: 10.px, right: 10.px),
                  child: (isRegistrationLockActive)
                      ? InkWell(
                          onTap: () {
                            isRegistrationLockActive = false;
                            controller.update();
                                Get.back();
                          },
                          child: const AppText(StringConstant.turnOff,
                              color: AppColorConstant.appYellow))
                      : InkWell(
                          onTap: () {
                            isRegistrationLockActive = true;
                            controller.update();
                                Get.back();
                          },
                          child: const AppText(StringConstant.turnOn,
                              color: AppColorConstant.appYellow)),
                )
              ],
            );
          },
        );
      },
    );
    controller.update();
  }
}
