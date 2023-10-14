import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/chanage_phone_controller.dart';
import 'package:signal/generated/l10n.dart';

import '../../../app/app/utills/theme_util.dart';
import '../../../service/network_connectivity.dart';
import 'change_phone_view_model.dart';

// ignore: must_be_immutable
class ChangePhoneScreen extends StatelessWidget {
  ChangePhoneViewModel? changePhoneViewModel;

  ChangePhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    changePhoneViewModel ?? (changePhoneViewModel = ChangePhoneViewModel(this));

    return GetBuilder<ChangePhoneController>(
      init: ChangePhoneController(),
      initState: (state) {
        NetworkConnectivity.checkConnectivity(context);
      },
      builder: (controller) {
        return  Builder(builder: (context) {
          MediaQueryData mediaQuery = MediaQuery.of(context);
          ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
          return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: (!changePhoneViewModel!.isPhoneNumberChange)
              ? const AppAppBar(title: AppText(""))
              : AppAppBar(
                  title: AppText(
                  S.of(context).changeNumber,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 22.px,
                )),
          body: getBody(context, controller),
        );});
      },
    );
  }

  Padding getBody(
    BuildContext context,
    ChangePhoneController controller,
  ) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: EdgeInsets.only(top: 30.px, left: 25.px, right: 25.px),
      child: (!changePhoneViewModel!.isPhoneNumberChange)
          ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 110.px,
                width: 110.px,
                padding: EdgeInsets.all(20.px),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColorConstant.yellowLight),
                child: const AppImageAsset(
                  image: AppAsset.phoneIcon,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.px, bottom: 20.px),
                child: AppText(
                  S.of(context).changePhoneNumber,
                  color: primaryTheme,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.px,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15.px,
                  right: 15.px,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      textAlign: TextAlign.center,
                      S.of(context).useThisToChange,
                      color: secondaryTheme,
                      fontSize: 14.px,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.px),
                      child: AppText(
                        textAlign: TextAlign.center,
                        S.of(context).beforeContinuing,
                        color: secondaryTheme,
                        fontSize: 14.px,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 120.px),
                      child: AppElevatedButton(
                          buttonRadius: 30.px,
                          buttonColor: AppColorConstant.appYellow,
                          buttonHeight: 42.px,
                          onPressed: () {
                            changePhoneViewModel!.continueTap(controller);
                          },
                          widget: AppText(
                            S.of(context).continues,
                            fontSize: 13.px,
                            color: primaryTheme,
                          )),
                    )
                  ],
                ),
              )
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5.px),
                child: AppText(
                  S.of(context).yourOldNumber,
                  color: primaryTheme,
                ),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 5.px.px),
                    height: 47.px,
                    width: 90.px,
                    decoration: BoxDecoration(
                        color: AppColorConstant.appYellow.withOpacity(0.1),
                        border: Border.all(color: AppColorConstant.appYellow),
                        borderRadius: BorderRadius.circular(13.px)),
                    child: CountryCodePicker(
                      showFlag: false,
                      showFlagDialog: true,
                      onChanged: (country) {
                        changePhoneViewModel!.oldNumCountryCode =
                            country.toString();
                      },
                      initialSelection: 'IN',
                      textStyle: TextStyle(
                        color: primaryTheme,
                        fontWeight: FontWeight.w600,
                      ),
                      // Set initial country code
                      favorite: const ['IN'], // Specify favorite country codes
                    ),
                  ),
                  Expanded(
                    child: AppTextFormField(
                      keyboardType: TextInputType.number,
                      controller: changePhoneViewModel!.oldNumberController,
                      labelText: S.of(context).phoneNumber,
                      onChanged: (value) =>
                          changePhoneViewModel!.onChangedNumber(controller),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.px, bottom: 5.px),
                child: AppText(
                  S.of(context).yourNewNumber,
                  color: primaryTheme,
                ),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 5.px.px),
                    height: 47.px,
                    width: 90.px,
                    decoration: BoxDecoration(
                        color: AppColorConstant.appYellow.withOpacity(0.1),
                        border: Border.all(color: AppColorConstant.appYellow),
                        borderRadius: BorderRadius.circular(13.px)),
                    child: CountryCodePicker(
                      showFlag: false,
                      showFlagDialog: true,
                      onChanged: (country) {
                        changePhoneViewModel!.newNumCountryCode =
                            country.toString();
                      },
                      initialSelection: 'IN',
                      textStyle: TextStyle(
                        color: primaryTheme,
                        fontWeight: FontWeight.w600,
                      ),
                      // Set initial country code
                      favorite: const ['IN'], // Specify favorite country codes
                    ),
                  ),
                  Expanded(
                    child: AppTextFormField(
                      keyboardType: TextInputType.number,
                      controller: changePhoneViewModel!.newNumberController,
                      labelText: S.of(context).phoneNumber,
                      onChanged: (value) =>
                          changePhoneViewModel!.onChangedNumber(controller),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 30.px),
                child: AppElevatedButton(
                    buttonRadius: 30.px,
                    buttonColor: (changePhoneViewModel!.isButtonActive)
                        ? AppColorConstant.appYellow
                        : AppColorConstant.grey,
                    buttonHeight: 42.px,
                    onPressed: (changePhoneViewModel!.isButtonActive)
                        ? () {
                            changePhoneViewModel!
                                .finalContinueTap(controller, context);
                          }
                        : null,
                    widget: AppText(
                      S.of(context).continues,
                      fontSize: 13.px,
                      color: primaryTheme,
                    )),
              )
            ]),
    );
  }
}
