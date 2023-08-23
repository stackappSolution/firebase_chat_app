import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/theme_util.dart';
import 'package:signal/pages/pin_enter/pin_enter_view_model.dart';

import '../../app/widget/app_elevated_button.dart';
import '../../app/widget/app_text.dart';
import '../../constant/color_constant.dart';
import '../../constant/string_constant.dart';
import '../../controller/pin_enter_controller.dart';

class PinEnterScreen extends StatelessWidget {
  PinEnterViewModel? pinEnterViewModel;

  PinEnterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    pinEnterViewModel ?? (pinEnterViewModel = PinEnterViewModel(this));

    return GetBuilder<pinEnterController>(
      init: pinEnterController(),
      initState: (state) {

      },
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: getBody(context, controller),
        ));
      },
    );
  }

  Padding getBody(context, pinEnterController controller) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: EdgeInsets.only(top: 65.px, left: 25.px, right: 25.px),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        AppText(
          StringConstant.enterYourPin,
          fontSize: 27.px,
          color: primaryTheme,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.px),
          child: AppText(
            StringConstant.enterThePIN,
            color: secondaryTheme,
            fontSize: 13.px,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.px, bottom: 8.px),
          child: TextField(
            controller: pinEnterViewModel!.pinController,
            keyboardType: (pinEnterViewModel!.changeKeyBoard)
                ? TextInputType.text
                : TextInputType.number,
            textAlign: TextAlign.center,
            autofocus: true,
            obscureText: true,
            inputFormatters: (!pinEnterViewModel!.changeKeyBoard)
                ? [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ]
                : [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
            decoration: InputDecoration(
                filled: true,
                fillColor: (ThemeUtil.isDark)
                    ? secondaryTheme
                    : AppColorConstant.yellowLight,
                border: const UnderlineInputBorder()),
            onChanged: (value) {
              pinEnterViewModel!.onPinChanged(value, controller);
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: (!pinEnterViewModel!.changeKeyBoard)
              ? AppText(
                  StringConstant.pinMustBeChar,
                  color: secondaryTheme,
                  fontSize: 12.px,
                )
              : AppText(
                  StringConstant.pinMustBeGigit,
                  color: secondaryTheme,
                  fontSize: 12.px,
                ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.px),
          child: InkWell(
            onTap: () {
              pinEnterViewModel!.onKeyBoardChangeTap(controller);
            },
            child: (pinEnterViewModel!.changeKeyBoard)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.keyboard_alt_outlined,
                        color: AppColorConstant.blue,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.px),
                        child: AppText(StringConstant.createAlphaNumericPin,
                            fontSize: 13.px, color: AppColorConstant.blue),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.keyboard_alt,
                        color: AppColorConstant.blue,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.px),
                        child: AppText(StringConstant.createNumericPin,
                            fontSize: 13.px, color: AppColorConstant.blue),
                      )
                    ],
                  ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 45.px, vertical: 40.px),
          child: AppElevatedButton(
            buttonHeight: 50.px,
            widget: AppText(
              StringConstant.next,
              color: AppColorConstant.appWhite,
              fontSize: 20.px,
            ),
            isBorderShape: true,
            buttonColor: (pinEnterViewModel!.isButtonActive)
                ? AppColorConstant.appYellow
                : AppColorConstant.appYellow.withOpacity(0.5),
            onPressed: (pinEnterViewModel!.isButtonActive)
                ? () {
                    pinEnterViewModel!.onNextTap(context);
                  }
                : null,
          ),
        ),
      ]),
    );
  }
}
