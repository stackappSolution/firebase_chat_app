import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_alert_dialog.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/acccount_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/routes/app_navigation.dart';

import '../../../app/app/utills/theme_util.dart';
import '../../../app/widget/app_textForm_field.dart';
import '../../../service/auth_service.dart';
import 'account_screen.dart';

class AccountViewModel {
  AccountScreen? accountScreen;
  bool isPinReminderActive = true;
  bool isRegistrationLockActive = false;
  bool changeKeyBoard = false;
  bool isError = false;
  bool isButtonActive = false;

  String firebaseStoredPin = "";
  String countryCode = "+91";
  final textController = TextEditingController();

  final pinController = TextEditingController();

  AccountViewModel(this.accountScreen);

  changePinTap() {
    goToPinSettingScreen();
  }

  deleteAccountTap(AttachmentController controller, context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.px)),
                    titlePadding: EdgeInsets.only(left: 15.px, top: 8.px),
                    backgroundColor: (ThemeUtil.isDark)
                        ? AppColorConstant.blackOff
                        : AppColorConstant.appWhite,
                    elevation: 0.0,
                    contentPadding: EdgeInsets.zero,
                    insetPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    title: Container(
                        margin: EdgeInsets.all(10.px),
                        child: AppText(
                          fontSize: 20.px,
                          S.of(context).phoneNumber,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    content: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.px, vertical: 20.px),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 5.px.px),
                            height: 47.px,
                            width: 90.px,
                            decoration: BoxDecoration(
                                color:
                                    AppColorConstant.appYellow.withOpacity(0.1),
                                border: Border.all(
                                    color: AppColorConstant.appYellow),
                                borderRadius: BorderRadius.circular(13.px)),
                            child: CountryCodePicker(
                              showFlag: false,
                              showFlagDialog: true,
                              onChanged: (country) {
                                countryCode = country.toString();
                              },
                              initialSelection: 'IN',
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              // Set initial country code
                              favorite: const [
                                'IN'
                              ], // Specify favorite country codes
                            ),
                          ),
                          Expanded(
                            child: AppTextFormField(
                              keyboardType: TextInputType.number,
                              controller: textController,
                              labelText: S.of(context).phoneNumber,
                              onChanged: (value) {
                                setState(
                                  () {
                                    onChangedNumber(controller);
                                  },
                                );
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: AppText(
                                  S.of(context).cancel,
                                  color: AppColorConstant.appYellow,
                                )),
                            InkWell(
                                onTap: (isButtonActive)
                                    ? () {
                                        AuthService.auth.signOut();
                                        controller.deleteCollection();
                                        Get.back();
                                      }
                                    : null,
                                child: AppText(
                                  S.of(context).deleteAccount,
                                  color: (isButtonActive)
                                      ? AppColorConstant.red
                                      : AppColorConstant.darkSecondary,
                                )),
                          ],
                        ),
                      )
                    ],
                  );
                },
              );
            },
          );
        });
  }

  onChangedNumber(controller) {
    if (("$countryCode${textController.text}") ==
        AuthService.auth.currentUser!.phoneNumber) {
      isButtonActive = true;
      controller.update();
    } else {
      isButtonActive = false;
      controller.update();
    }
    logs("isButtonActive-----> ${isButtonActive}");
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

  pinReminderTap(context, AttachmentController controller) {
    isPinReminderActive = !isPinReminderActive;
    logs("isSwitchActive------$isPinReminderActive");
    if (!isPinReminderActive) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AppAlertDialog(
                title: AppText(
                  fontSize: 18.px,
                  S.of(context).conformYourChatAppPIN,
                  color: Theme.of(context).colorScheme.primary,
                ),
                insetPadding: EdgeInsets.zero,
                widget: SizedBox(
                  height: 170.px,
                  child: Column(children: [
                    AppText(
                      S.of(context).makeSureYou,
                      color: AppColorConstant.darkSecondary,
                      fontSize: 14.px,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 30.px, left: 30.px, right: 30.px),
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
                                    child: AppText(S.of(context).switchKeyboard,
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
                          S.of(context).incorrectPinTryAgain,
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
                        logs("isPinReminderActive=======>$isPinReminderActive");
                        Navigator.pop(context);
                        controller.update();
                      },
                      child: AppText(
                        S.of(context).cancel,
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
                      child: AppText(S.of(context).turnOff,
                          color: AppColorConstant.appYellow),
                    ),
                  )
                ],
              );
            },
          );
        },
      );
    }

    controller.update();
  }

  registrationLockTap(context, AttachmentController controller) {
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
                  ? AppText(
                      S.of(context).turnOffRegistration,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16.px,
                    )
                  : AppText(
                      S.of(context).turnOnRegistration,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16.px,
                    ),
              insetPadding: EdgeInsets.zero,
              widget: SizedBox(
                height: (!isRegistrationLockActive) ? 110.px : 20.px,
                width: 100.px,
                child: Column(children: [
                  if (!isRegistrationLockActive)
                    AppText(
                      S.of(context).ifYouForgetYourPIN,
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
                    child: AppText(
                      S.of(context).cancel,
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
                          child: AppText(S.of(context).turnOff,
                              color: AppColorConstant.appYellow))
                      : InkWell(
                          onTap: () {
                            isRegistrationLockActive = true;
                            controller.update();
                            Get.back();
                          },
                          child: AppText(S.of(context).turnOn,
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
