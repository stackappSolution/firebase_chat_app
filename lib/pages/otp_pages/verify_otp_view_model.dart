import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:signal/pages/otp_pages/verify_otp_page.dart';

class VerifyOtpViewModel{
  late VerifyOtpPage? verifyOtpPage;

  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController otpcontroller = TextEditingController();
  CountryCode selectedCountry = CountryCode.fromCountryCode('IN');
  String smsCode = "";
  bool isValidOTP = false;
  bool isVerificationSuccessful = false;
  Map<String,dynamic> parameter = {};

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: const TextStyle(
      fontSize: 22,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: Colors.black),
    ),
  );

  VerifyOtpViewModel(this.verifyOtpPage);

  bool isValidOtp(String value) {
    return value.length == 6 && int.tryParse(value) != null;
  }
}