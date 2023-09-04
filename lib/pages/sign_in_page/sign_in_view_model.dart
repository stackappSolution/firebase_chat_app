
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signal/pages/sign_in_page/sign_in_page.dart';


class SignInViewModel{

  SignInPage? signInPage;

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController countrycode = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String countryCode = '';
  CountryCode selectedCountry = CountryCode.fromCountryCode('IN');
  bool isValidNumber = false;
  bool otpSend = false;

  var temp;
  var data;



  SignInViewModel(this.signInPage);

  bool isValidMobileNumber(String value) {
    return value.length == 10 && int.tryParse(value) != null;
  }
}
