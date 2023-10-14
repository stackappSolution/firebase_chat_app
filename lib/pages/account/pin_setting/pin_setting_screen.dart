import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/pin_setting_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/account/pin_setting/pin_setting_view_model.dart';

import '../../../app/app/utills/theme_util.dart';

// ignore: must_be_immutable
class PinSettingScreen extends StatelessWidget {
  PinSettingViewModel? pinSettingViewModel;

  PinSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    pinSettingViewModel ?? (pinSettingViewModel = PinSettingViewModel(this));

    return GetBuilder<PinSettingController>(
      init: PinSettingController(),
      initState: (state) {},
      builder: (controller) {
        return SafeArea(child: Builder(builder: (context) {
          MediaQueryData mediaQuery = MediaQuery.of(context);
          ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: getBody(context, controller),
            floatingActionButton: getFloatingActionButton(context, controller),
          );
        }));
      },
    );
  }

  getBody(
    context,
    PinSettingController controller,
  ) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return (!pinSettingViewModel!.isConformPage)
        ? createPinView(primaryTheme, secondaryTheme, controller, context)
        : conformPinView(primaryTheme, secondaryTheme, controller, context);
  }

  createPinView(Color primaryTheme, Color secondaryTheme,
      PinSettingController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 65.px, left: 20.px, right: 20.px),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            controller: pinSettingViewModel!.pinController,
            keyboardType: (pinSettingViewModel!.changeKeyBoard)
                ? TextInputType.text
                : TextInputType.number,
            textAlign: TextAlign.center,
            focusNode: pinSettingViewModel!.focusNode,
            autofocus: true,
            obscureText: true,
            inputFormatters: (!pinSettingViewModel!.changeKeyBoard)
                ? [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ]
                : [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
            decoration: const InputDecoration(
                filled: true,
                fillColor: AppColorConstant.yellowLight,
                border: UnderlineInputBorder()),
            onChanged: (value) {
              pinSettingViewModel!.onPinChanged(value, controller);
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: (!pinSettingViewModel!.changeKeyBoard)
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
              pinSettingViewModel!.onKeyBoardChangeTap(controller);
            },
            child: (pinSettingViewModel!.changeKeyBoard)
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
        )
      ]),
    );
  }

  conformPinView(Color primaryTheme, Color secondaryTheme,
      PinSettingController controller, BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 65.px, left: 20.px, right: 20.px),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                controller: pinSettingViewModel!.conformPinController,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                focusNode: pinSettingViewModel!.focusNode,
                autofocus: true,
                obscureText: true,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                ],
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColorConstant.yellowLight,
                    border: UnderlineInputBorder()),
                onChanged: (value) {
                  pinSettingViewModel!.onPinConformChanged(value, controller);
                },
              ),
            ),
          ]),
        ),
        if (pinSettingViewModel!.isLoading) AppLoader()
      ],
    );
  }

  getFloatingActionButton(context, PinSettingController controller) {
    return Padding(
      padding: EdgeInsets.only(right: 30.px, bottom: 12.px),
      child: (!pinSettingViewModel!.isConformPage)
          ? InkWell(
              onTap: (pinSettingViewModel!.isButtonActive)
                  ? () {
                      FocusScope.of(context).nextFocus();
                      pinSettingViewModel!.nextCreateButtonTap(controller);
                    }
                  : null,
              child: Container(
                alignment: Alignment.center,
                height: 50.px,
                width: 110.px,
                decoration: BoxDecoration(
                    color: (!pinSettingViewModel!.isButtonActive)
                        ? Theme.of(context).colorScheme.secondary
                        : AppColorConstant.appYellow,
                    borderRadius: BorderRadius.all(Radius.circular(30.px))),
                child: AppText(
                  S.of(context).next,
                  fontSize: 14.px,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            )
          : InkWell(
              onTap: (pinSettingViewModel!.isButtonActive)
                  ? () {
                      FocusScope.of(context).nextFocus();
                      pinSettingViewModel!.nextConformButtonTap(controller);
                    }
                  : null,
              child: Container(
                alignment: Alignment.center,
                height: 50.px,
                width: 110.px,
                decoration: BoxDecoration(
                    color: (!pinSettingViewModel!.isButtonActive)
                        ? Theme.of(context).colorScheme.secondary
                        : AppColorConstant.appYellow,
                    borderRadius: BorderRadius.all(Radius.circular(30.px))),
                child: AppText(
                  S.of(context).next,
                  fontSize: 14.px,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
    );
  }
}
