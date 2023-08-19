import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/sign_in_controller.dart';
import 'package:signal/pages/signin_pages/sign_in_view_model.dart';
import 'package:signal/routes/routes_helper.dart';

// ignore: must_be_immutable
class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  SignInViewModel? signInViewModel;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    signInViewModel ?? (signInViewModel = SignInViewModel(this));
    return GetBuilder(
      init: SignInController(),
      initState: (state) {},
      builder: (SignInController controller) {
        return SafeArea(
          child: Scaffold(
              body: buildSignInpage(signInViewModel!.countryCode,
                signInViewModel!.phoneNumber.text, context, controller,)),
        );
      },
    );
  }

  Container buildSignInpage(String countryCode, String phoneNumber, BuildContext context, SignInController controller) => Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColorConstant.appWhite.withOpacity(0.1),
          AppColorConstant.appTheme.withOpacity(0.1),
        ],
      ),
    ),
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
              height: 250.px,
              image: AppAsset.signIn,
            ),
          ),
          SizedBox(
            height: 20.px,
          ),
          Container(
              margin: EdgeInsets.only(left: 20.px),
              alignment: Alignment.centerLeft,
              child: AppText(
                'Sign In',
                //StringConstant.signIn,
                fontSize: 30.px,
                fontWeight: FontWeight.w600,
              )),
          Container(
            margin: EdgeInsets.only(left: 20.px),
            child: AppText(
              StringConstant.signInDis,
              color: AppColorConstant.appLightBlack.withOpacity(0.4),
              fontWeight: FontWeight.w400,
              fontSize: 15.px,
            ),
          ),
          SizedBox(
            height: 15.px,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20.px),
                height: 50.px,
                width: 90.px,
                decoration: BoxDecoration(
                    color: AppColorConstant.appTheme.withOpacity(0.1),
                    border: Border.all(color: AppColorConstant.appTheme),
                    borderRadius: BorderRadius.circular(13.px)),
                child: CountryCodePicker(
                  showFlag: false,
                  showFlagDialog: true,
                  onChanged: (country) {
                    signInViewModel!.selectedCountry = country;
                  },
                  initialSelection: 'IN',
                  textStyle: const TextStyle(
                    color: AppColorConstant.appBlack,
                    fontWeight: FontWeight.w600,),
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
                          AppColorConstant.appTheme.withOpacity(0.1)),
                      height: 50.px,
                      margin: EdgeInsets.only(left: 10.px, right: 10.px),
                      child: AppTextFormField(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                            color: AppColorConstant.appTheme,
                            fontSize: 20.px),
                        controller: signInViewModel!.phoneNumber,
                        style: TextStyle(
                          fontSize: 22.px,
                          fontWeight: FontWeight.w400,
                          color: AppColorConstant.appBlack,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null && value!.isEmpty) {
                            return 'Mobile number is required';
                          } else if (signInViewModel!
                              .isValidMobileNumber(value)) {
                            return 'Invalid mobile number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.length == 10) {
                            signInViewModel!.isValidNumber = true;
                            controller.update();
                          } else {
                            signInViewModel!.isValidNumber = false;
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
            height: 150.px,
          ),
          if (signInViewModel!.isValidNumber != true)
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                    backgroundColor: MaterialStatePropertyAll(
                        AppColorConstant.appTheme.withOpacity(0.5)),
                    fixedSize:
                    MaterialStatePropertyAll(Size(230.px, 50.px))),
                child: AppText(
                  'Continue',
                  //StringConstant.continueButton,
                  fontSize: 22.px,
                  color: AppColorConstant.appWhite,
                ),
              ),
            )
          else
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  Get.toNamed(RouteHelper.getVerifyOtpPage(),
                      arguments: "${signInViewModel!.countryCode}${signInViewModel!.phoneNumber.text}");
                },
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    backgroundColor: const MaterialStatePropertyAll(
                        AppColorConstant.appTheme),
                    fixedSize:
                    MaterialStatePropertyAll(Size(230.px, 50.px))),
                child: AppText(
                  'Continue',
                  //StringConstant.continueButton,
                  fontSize: 22.px,
                  color: AppColorConstant.appWhite,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}