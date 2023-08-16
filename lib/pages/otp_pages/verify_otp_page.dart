import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/vreify_otp_controller.dart';
import 'package:signal/pages/otp_pages/verify_otp_view_model.dart';

class VerifyOtpPage extends StatelessWidget {
   VerifyOtpPage({super.key});

  VerifyOtpViewModel? verifyOtpViewModel;
  VerifyOtpController? verifyOtpController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: VerifyOtpController(),
      initState: (state) {

      },
      builder: (VerifyOtpController controller) {
        return SafeArea(
          child: Scaffold(
            body: buildVerifyotpScreen(),
          ),
        );
      },);
  }

  buildVerifyotpScreen() => SingleChildScrollView(
    child: Container(
      height: Device.height,
      width: Device.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColorConstant.appWhite.withOpacity(0.2),
            AppColorConstant.appTheme.withOpacity(0.2),
          ],
        ),
      ),
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
          SizedBox(height: 20.px,),
          Container(
              margin: EdgeInsets.only(left: 20.px),
              alignment: Alignment.centerLeft,
              child: AppText(
                 'Verify OTP',
                fontSize: 30.px,
                fontWeight: FontWeight.w600,
              )),
          SizedBox(
            height: 5.px,
          ),
          Container(
            margin: EdgeInsets.only(left: 20.px),
            child: AppText(
              StringConstant.verifyOtp,
              color: AppColorConstant.appBlack,
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
                child: Container(
                  margin: EdgeInsets.only(left: 20.px,right: 20.px),
                  height: 65.px,
                  width: 80.px,
                  decoration: BoxDecoration(
                      color: AppColorConstant.appTheme.withOpacity(0.1),
                      border: Border.all(color: AppColorConstant.appTheme),
                      borderRadius: BorderRadius.circular(13.px)),
                  child: Pinput(
                    errorText: 'This pin has expired click Resend OTP for new OTP',
                    validator: (value) {
                      return value == verifyOtpViewModel!.smsCode ? null : '';
                    },
                    androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsUserConsentApi,
                    length: 6,
                    onChanged: (value) {
                      verifyOtpViewModel!.smsCode != value;
                    },
                    showCursor: true,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 150.px,),
          Align(alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {

              },
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  backgroundColor:
                  const MaterialStatePropertyAll(AppColorConstant.appTheme),
                  fixedSize: MaterialStatePropertyAll(Size(230.px, 50.px))),
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
