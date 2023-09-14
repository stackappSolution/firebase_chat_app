import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/vreify_otp_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/otp_pages/verify_otp_view_model.dart';
import 'package:signal/service/auth_service.dart';

class VerifyOtpPage extends StatelessWidget {
  VerifyOtpPage({super.key});

  VerifyOtpViewModel? verifyOtpViewModel;

  @override
  Widget build(BuildContext context) {
    verifyOtpViewModel ?? (verifyOtpViewModel = VerifyOtpViewModel(this));
    return GetBuilder(
      init: VerifyOtpController(),
      initState: (state) {
        verifyOtpViewModel!.parameter = Get.parameters;
        logs("parameter data---->${verifyOtpViewModel!.parameter.values}");
      },
      builder: (VerifyOtpController controller) {
        return WillPopScope(
          onWillPop: () async {
            return await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.px),
                      borderSide: const BorderSide(color: Colors.transparent)),
                  title: const AppText('Exit App', fontWeight: FontWeight.bold),
                  content:
                      const AppText('Are you sure you want to exit the app?'),
                  actions: [
                    Row(
                      children: [
                        const Spacer(),
                        AppElevatedButton(
                          buttonWidth: 50.px,
                          buttonColor: AppColorConstant.appYellow,
                          buttonHeight: 40.px,
                          widget: const AppText('Yes',
                              color: AppColorConstant.appWhite),
                          onPressed: () {
                            SystemNavigator.pop();
                            //Navigator.of(context).pop(true); // Exit the app
                          },
                        ),
                        SizedBox(width: 10.px),
                        AppElevatedButton(
                          buttonWidth: 50.px,
                          buttonColor: AppColorConstant.appYellow,
                          buttonHeight: 40.px,
                          widget: const AppText('No',
                              color: AppColorConstant.appWhite),
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
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: buildVerifyotpScreen(controller, context),
            ),
          ),
        );
      },
    );
  }

  buildVerifyotpScreen(VerifyOtpController controller, BuildContext context) =>
      Container(
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
                  height: 230.px,
                  image: AppAsset.verifyOtp,
                ),
              ),
              SizedBox(
                height: 20.px,
              ),
              Container(
                  margin: EdgeInsets.only(left: 20.px),
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    S.of(Get.context!).verify,
                    fontSize: 30.px,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  )),
              Container(
                margin: EdgeInsets.only(left: 20.px),
                child: AppText(
                  '${S.of(Get.context!).verifyOtp}${verifyOtpViewModel!.parameter["selectedCountry"]}${verifyOtpViewModel!.parameter["phoneNo"]}',
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.px,
                ),
              ),
              SizedBox(
                height: 15.px,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.px, right: 20.px),
                      child: Pinput(
                        controller: verifyOtpViewModel!.otpcontroller,
                        defaultPinTheme: PinTheme(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColorConstant.appYellow,
                                  width: 2.px),
                              borderRadius: BorderRadius.circular(15.px)),
                          height: 50.px,
                          textStyle: TextStyle(
                              fontSize: 20.px,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600),
                        ),
                        validator: (value) {
                          if (value == null && value!.isEmpty) {
                          } else if (verifyOtpViewModel!.isValidOtp(value)) {}
                          return null;
                        },
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        length: 6,
                        onChanged: (value) {
                          if (value.length == 6) {
                            verifyOtpViewModel!.isValidOTP = true;
                            controller.update();
                          } else {
                            verifyOtpViewModel!.isValidOTP = false;
                            controller.update();
                          }
                        },
                        showCursor: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 130.px,
              ),
              Align(
                  alignment: Alignment.center,
                  child: verifyOtpViewModel!.isValidOTP != true
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60.px),
                          child: AppElevatedButton(
                              buttonColor:
                                  AppColorConstant.appYellow.withOpacity(0.5),
                              buttonHeight: 50,
                              isBorderShape: true,
                              widget: AppText(S.of(context).verifyButton,
                                  fontSize: 22.px,
                                  color: AppColorConstant.appWhite)),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60.px),
                          child: AppElevatedButton(
                            onPressed: () async {
                              verifyOtpViewModel!.isLoading = true;
                              controller.update();

                              setIntValue('verification', 2);
                              await AuthService()
                                  .verifyOtp(
                                verificationID: AuthService.verificationID,
                                smsCode: verifyOtpViewModel!.otpcontroller.text,
                                phoneNumber:
                                    verifyOtpViewModel!.parameter.values.first,
                              )
                                  .then((isVerificationSuccessful) async {
                              }).catchError(
                                (error) {
                                  logs("Error during OTP verification----> $error");
                                },
                              );
                              controller.update();
                            },
                            buttonColor: AppColorConstant.appYellow,
                            buttonHeight: 50.px,
                            isBorderShape: true,
                            widget: (verifyOtpViewModel!.isLoading)
                                ? const CircularProgressIndicator(
                                    color: AppColorConstant.appWhite,
                                  )
                                : AppText(S.of(context).verifyButton,
                                    fontSize: 18.px,
                                    color: AppColorConstant.appWhite),
                          ),
                        )),
            ],
          ),
        ),
      );
}
