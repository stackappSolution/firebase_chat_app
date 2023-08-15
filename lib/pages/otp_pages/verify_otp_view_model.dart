import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:signal/pages/otp_pages/verify_otp_page.dart';

class VerifyOtpViewModel{
  late VerifyOtpPage? verifyOtpPage;


  TextEditingController phoneNumber = TextEditingController();
  CountryCode selectedCountry = CountryCode.fromCountryCode('IN');
  String smsCode = "";


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
}