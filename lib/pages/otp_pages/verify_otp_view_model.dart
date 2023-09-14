import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/pages/otp_pages/verify_otp_page.dart';

class VerifyOtpViewModel{
  late VerifyOtpPage? verifyOtpPage;

  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();
  CountryCode selectedCountry = CountryCode.fromCountryCode('IN');
  String smsCode = "";
  bool isValidOTP = false;
  bool isLoading = false;
  Map<String,dynamic> parameter = {};
  String? fcmToken;

  final defaultPinTheme = PinTheme(
    width: 50.px,
    height: 50.px,
    textStyle:  TextStyle(
      fontSize: 22.px,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19.px),
      border: Border.all(color: Colors.black),
    ),
  );

  VerifyOtpViewModel(this.verifyOtpPage);

  bool isVerificationSuccessful = false;

  bool isValidOtp(String value) {
    return value.length == 6 && int.tryParse(value) != null;
  }

  void getFCMToken() async {
    var messaging;
    fcmToken = await messaging.getToken();
    logs('FCM TOKEN222222222-->$fcmToken');
  }
}