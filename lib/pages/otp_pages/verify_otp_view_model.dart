import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pinput/pinput.dart';
import 'package:signal/pages/otp_pages/verify_otp_page.dart';

class VerifyOtpViewModel{
  late VerifyOtpPage? verifyOtpPage;


  TextEditingController Otp = TextEditingController();
  CountryCode selectedCountry = CountryCode.fromCountryCode('IN');
  String smsCode = "";
  bool isValidOTP = false;
  final Map<String, dynamic> arguments = Get.arguments;

  // final arg1 = arguments['arg1'];
  // final arg2 = arguments['arg2'];



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