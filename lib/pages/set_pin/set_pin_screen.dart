import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/profile/profile_screen.dart';
import 'package:signal/pages/set_pin/set_pin_view_model.dart';
import 'package:signal/routes/app_navigation.dart';

import '../../app/widget/app_elevated_button.dart';
import '../../controller/set_pin_controller.dart';

// ignore: must_be_immutable
class SetPinScreen extends StatelessWidget {
  SetPinViewModel? setPinViewModel;

  SetPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    setPinViewModel ?? (setPinViewModel = SetPinViewModel(this));

    return GetBuilder<SetPinController>(
      init: SetPinController(),
      initState: (state) {},
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: getBody(context, controller),
            // floatingActionButton: getFloatingActionButton(context, controller),
          ),
        );
      },
    );
  }

  getBody(
    context,
    SetPinController controller,
  ) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return (!setPinViewModel!.isConformPage)
        ? createPinView(primaryTheme, secondaryTheme, controller, context)
        : conformPinView(primaryTheme, secondaryTheme, controller, context);
  }

  createPinView(Color primaryTheme, Color secondaryTheme,
      SetPinController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.px, left: 20.px, right: 20.px),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                  onPressed: () {
                    Get.to(ProfileScreen(''));
                  },
                  child:
                      const AppText('Skip', color: AppColorConstant.appYellow)),
            ),
            AppText(
              S.of(context).createYourPIN,
              fontSize: 27.px,
              color: primaryTheme,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.px),
              child: AppText(
                S.of(context).pinCanHelp,
                color: secondaryTheme,
                fontSize: 13.px,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.px, bottom: 8.px),
              child: TextField(
                style: const TextStyle(color: AppColorConstant.appBlack),
                controller: setPinViewModel!.pinController,
                keyboardType: (setPinViewModel!.changeKeyBoard)
                    ? TextInputType.text
                    : TextInputType.number,
                textAlign: TextAlign.center,
                focusNode: setPinViewModel!.focusNode,
                autofocus: true,
                obscureText: true,
                inputFormatters: (!setPinViewModel!.changeKeyBoard)
                    ? [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ]
                    : [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]')),
                      ],
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColorConstant.yellowLight,
                    border: UnderlineInputBorder()),
                onChanged: (value) {
                  setPinViewModel!.onPinChanged(value, controller);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: (!setPinViewModel!.changeKeyBoard)
                  ? AppText(
                      S.of(context).pinMustBeChar,
                      color: secondaryTheme,
                      fontSize: 12.px,
                    )
                  : AppText(
                      S.of(context).pinMustBeChar,
                      color: secondaryTheme,
                      fontSize: 12.px,
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 70.px, right: 50.px, top: 30.px),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).nextFocus();
                  setPinViewModel!.onKeyBoardChangeTap(controller);
                },
                child: (setPinViewModel!.changeKeyBoard)
                    ? Row(
                        children: [
                          const Icon(
                            Icons.keyboard_alt_outlined,
                            color: AppColorConstant.blue,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.px),
                            child: AppText(S.of(context).createAlphaNumericPin,
                                fontSize: 13.px, color: AppColorConstant.blue),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          const Icon(
                            Icons.keyboard_alt,
                            color: AppColorConstant.blue,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.px),
                            child: AppText(S.of(context).createNumericPin,
                                fontSize: 13.px, color: AppColorConstant.blue),
                          )
                        ],
                      ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.px),
              child: AppElevatedButton(
                onPressed: (setPinViewModel!.isButtonActive)
                    ? () {
                        FocusScope.of(context).nextFocus();
                        setPinViewModel!.nextCreateButtonTap(controller);
                      }
                    : null,
                buttonColor: (setPinViewModel!.isButtonActive)
                    ? AppColorConstant.appYellow
                    : Theme.of(context).colorScheme.secondary,
                buttonHeight: 50.px,
                isBorderShape: true,
                widget: AppText(S.of(context).next,
                    fontSize: 18.px, color: AppColorConstant.appWhite),
              ),
            ),
            SizedBox(
              height: 15.px,
            )
          ]),
    );
  }

  conformPinView(Color primaryTheme, Color secondaryTheme,
      SetPinController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 65.px, left: 20.px, right: 20.px),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppText(
          S.of(context).conformYourPin,
          fontSize: 27.px,
          color: primaryTheme,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.px),
          child: AppText(
            S.of(context).reEnterThePin,
            color: secondaryTheme,
            fontSize: 13.px,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.px, bottom: 8.px),
          child: TextField(
            style: const TextStyle(color: AppColorConstant.appBlack),
            controller: setPinViewModel!.conformPinController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            focusNode: setPinViewModel!.focusNode,
            autofocus: true,
            obscureText: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
            decoration: const InputDecoration(
                filled: true,
                fillColor: AppColorConstant.yellowLight,
                border: UnderlineInputBorder()),
            onChanged: (value) {
              setPinViewModel!.onPinConformChanged(value, controller);
            },
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.px),
          child: AppElevatedButton(
            onPressed: (setPinViewModel!.isButtonActive)
                ? () {
                    FocusScope.of(context).nextFocus();
                    setPinViewModel!.nextConformButtonTap(controller);
                    Get.to(ProfileScreen(
                        setPinViewModel!.conformPinController.text));
                  }
                : null,
            buttonColor: (setPinViewModel!.isButtonActive)
                ? AppColorConstant.appYellow
                : Theme.of(context).colorScheme.secondary,
            buttonHeight: 50.px,
            isBorderShape: true,
            widget: AppText(S.of(context).next,
                fontSize: 18.px, color: AppColorConstant.appWhite),
          ),
        ),
        SizedBox(
          height: 15.px,
        )
      ]),
    );
  }
}
