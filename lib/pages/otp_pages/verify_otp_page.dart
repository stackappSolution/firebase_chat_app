import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
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
        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: buildVerifyotpScreen(context, controller),
          ),
        );
      },
    );
  }

  buildVerifyotpScreen(context, VerifyOtpController controller) => Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColorConstant.appWhite.withOpacity(0.1),
              AppColorConstant.appYellow.withOpacity(0.1),
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
                height: 150.px,
              ),
              Align(
                alignment: Alignment.center,
                child: verifyOtpViewModel!.isValidOTP != true
                    ? ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            backgroundColor: MaterialStatePropertyAll(
                                AppColorConstant.appYellow.withOpacity(0.5)),
                            fixedSize:
                                MaterialStatePropertyAll(Size(230.px, 50.px))),
                        child: AppText(
                          'Verify',
                          //StringConstant.verifyButton,
                          fontSize: 22.px,
                          color: AppColorConstant.appWhite,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          await AuthService()
                              .verifyOtp(
                                verificationID: AuthService.verificationID,
                                smsCode: verifyOtpViewModel!.otpcontroller.text,
                                phoneNumber:
                                    verifyOtpViewModel!.parameter.values.first,
                              )
                              .then((isVerificationSuccessful) {})
                              .catchError((error) {
                            logs("Error during OTP verification----> $error");
                          });
                        },
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            backgroundColor: const MaterialStatePropertyAll(
                                AppColorConstant.appYellow),
                            fixedSize:
                                MaterialStatePropertyAll(Size(230.px, 50.px))),
                        child: AppText(
                          'Verify',
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
