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

// ignore: must_be_immutable
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
        logs("parameter data---->${verifyOtpViewModel!.parameter['phoneNo']}");
        logs(
            "parameter data---->${verifyOtpViewModel!.parameter['selectedCountry']}");
        logs(
            "parameter data---->${verifyOtpViewModel!.parameter['verificationid']}");
      },
      builder: (VerifyOtpController controller) {
        return SafeArea(
          child: Scaffold(
            body: buildVerifyotpScreen(controller),
          ),
        );
      },
    );
  }

  buildVerifyotpScreen(VerifyOtpController controller) => Container(
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
                  )),
              Container(
                margin: EdgeInsets.only(left: 20.px),
                child: AppText(
                  '${S.of(Get.context!).verifyOtp}${verifyOtpViewModel!.parameter["selectedCountry"]}${verifyOtpViewModel!.parameter["phoneNo"]}',
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
                          textStyle: const TextStyle(
                              fontSize: 20,
                              color: AppColorConstant.appBlack,
                              fontWeight: FontWeight.w600),
                        ),
                        validator: (value) {
                          if (value == null && value!.isEmpty) {
                            //return 'OTP is required';
                          } else if (verifyOtpViewModel!.isValidOtp(value)) {
                            //return 'Invalid OTP number';
                          }
                          return null;
                        },
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
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
              if (verifyOtpViewModel!.isValidOTP != true)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
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
                  ),
                )
              else
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      AuthService()
                          .verifyOtp(
                              code: verifyOtpViewModel!
                                  .parameter['selectedCountry'],
                              verificationId:
                                  verifyOtpViewModel!.parameter.values.last,
                              smsCode: verifyOtpViewModel!.otpcontroller.text,
                              phoneNo: verifyOtpViewModel!.parameter['phoneNo'])
                          .then((isVerificationSuccessful) {})
                          .catchError((error) {
                        logs("Error during OTP verification: $error");
                      });

                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                        backgroundColor: const MaterialStatePropertyAll(
                            AppColorConstant.appYellow),
                        fixedSize:
                            MaterialStatePropertyAll(Size(230.px, 50.px))),
                    child: AppText(
                      'Verify',
                      //StringConstant.verifyButton,
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
