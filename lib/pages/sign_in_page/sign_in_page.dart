import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/sign_in_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/sign_in_page/sign_in_view_model.dart';
import 'package:signal/service/auth_service.dart';

import '../../app/app/utills/theme_util.dart';


class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  FirebaseAuth auth = FirebaseAuth.instance;
  CountryCode selectedCountry = CountryCode.fromCountryCode('IN');
  SignInViewModel? signInViewModel;

  @override
  Widget build(BuildContext context) {
    signInViewModel ?? (signInViewModel = SignInViewModel(this));
    return GetBuilder(
      init: SignInController(),
      initState: (state) {},
      builder: (SignInController controller) {
        return WillPopScope(
          onWillPop: () async {
            // Show a confirmation dialog
            return await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.transparent)),
                  title: const AppText('Exit App', fontWeight: FontWeight.bold),
                  content: const AppText('Are you sure you want to exit the app?'),
                  actions: [
                    Row(
                      children: [
                        const Spacer(),
                        AppElevatedButton(
                          buttonWidth: 50,
                          buttonColor: AppColorConstant.appYellow,
                          buttonHeight: 40,
                          widget:
                              const AppText('Yes', color: AppColorConstant.appWhite),
                          onPressed: () {
                            SystemNavigator.pop();
                            Navigator.of(context).pop(true); // Exit the app
                          },
                        ),
                        const SizedBox(width: 10),
                        AppElevatedButton(
                          buttonWidth: 50,
                          buttonColor: AppColorConstant.appYellow,
                          buttonHeight: 40,
                          widget:
                              const AppText(StringConstant.cansel, color: AppColorConstant.appWhite),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(false); // Don't exit the app
                          },
                        ),
                        // Add spacing between buttons
                      ],
                    ),
                  ],
                );
              },
            );
          },
          child: SafeArea(
            child:  Builder(builder: (context) {
              MediaQueryData mediaQuery = MediaQuery.of(context);
              ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
              return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: buildsignInPage(
                signInViewModel!.selectedCountry.toString(),
                signInViewModel!.phoneNumber.text,
                context,
                controller,
                signInViewModel!,
              ),
            );})
          ),
        );
      },
    );
  }

  Container buildsignInPage(
    String countryCode,
    String phoneNumber,
    BuildContext context,
    SignInController controller,
    SignInViewModel signInViewModel,
  ) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20.px),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80.px,
              ),
              Align(
                alignment: Alignment.center,
                child: AppImageAsset(
                  height: 190.px,
                  image: AppAsset.signIn,
                ),
              ),
              SizedBox(
                height: 30.px,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    S.of(Get.context!).signIn,
                    fontSize: 25.px,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  )),
               Padding(
                 padding:  EdgeInsets.symmetric(vertical: 5.px),
                 child: AppText(
                    S.of(Get.context!).signInDescription,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                  ),
               ),
              SizedBox(
                height: 10.px,
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 50.px,
                    width: 80.px,
                    decoration: BoxDecoration(
                        color: AppColorConstant.appYellow.withOpacity(0.1),
                        border: Border.all(color: AppColorConstant.appYellow),
                        borderRadius: BorderRadius.circular(13.px)),
                    child: CountryCodePicker(
                      dialogBackgroundColor:
                          Theme.of(context).colorScheme.background,
                      showFlag: false,
                      showFlagDialog: true,
                      onChanged: (country) {
                        signInViewModel.selectedCountry = country;
                      },
                      initialSelection: 'IN',
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      // Set initial country code
                      favorite: const ['IN'], // Specify favorite country codes
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.px),
                              color:
                                  AppColorConstant.appYellow.withOpacity(0.1)),
                          height: 50.px,
                          margin: EdgeInsets.only(left: 10.px, right: 10.px),
                          child: AppTextFormField(
                            focusNode: SignInViewModel.focusNode,
                            labelText: S.of(context).phoneNumber,
                            labelStyle: const TextStyle(
                                color: AppColorConstant.appYellow),
                            controller: signInViewModel.phoneNumber,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null && value!.isEmpty) {
                                return 'Mobile number is required';
                              } else if (signInViewModel
                                  .isValidMobileNumber(value)) {
                                return 'Invalid mobile number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.length == 10) {
                                signInViewModel.isValidNumber = true;
                                controller.update();
                              } else {
                                signInViewModel.isValidNumber = false;
                                controller.update();
                              }
                            },
                            keyboardType: TextInputType.number,
                            fontSize: 20.px,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 130.px,
              ),
              Align(
                alignment: Alignment.center,
                child: signInViewModel.isValidNumber != true
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.px),
                        child: AppElevatedButton(
                          isBorderShape: true,
                          buttonColor:
                              AppColorConstant.appYellow.withOpacity(0.5),
                          buttonHeight: 50.px,
                          widget: AppText(
                            S.of(context).continues,
                            fontSize: 16.px,
                            color: AppColorConstant.appWhite,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.px),
                        child: AppElevatedButton(
                            onPressed: signInViewModel.isLoading
                                ? null
                                : () async {
                                    try {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      pref.setString(
                                          "MobileNumber", phoneNumber);
                                      AuthService.verifyPhoneNumber(
                                          countryCode,"$countryCode$phoneNumber",
                                        );
                                      signInViewModel.isLoading = true;
                                      controller.update();
                                    } catch (e) {
                                      logs("Error: $e");
                                      signInViewModel.isLoading = false;
                                      controller.update();
                                    }
                                  },
                            buttonColor: AppColorConstant.appYellow,
                            buttonHeight: 50.px,
                            isBorderShape: true,
                            widget: signInViewModel.isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColorConstant.appWhite,
                                  )
                                : AppText(
                                    S.of(context).continues,
                                    fontSize: 16.px,
                                    color: AppColorConstant.appWhite,
                                  )),
                      ),
              ),
            ],
          ),
        ),
      );
}
