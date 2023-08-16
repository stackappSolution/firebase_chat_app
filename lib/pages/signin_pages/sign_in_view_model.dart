import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signal/pages/signin_pages/sign_in_page.dart';

class SignInViewModel {

  late SignInPage? signInPage;

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController countrycode = TextEditingController();
  String countryCode = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  String v_id = "";
  CountryCode selectedCountry = CountryCode.fromCountryCode('IN');
  String mobileNumber = '';
  bool isValidNumber = false;
  var data;


  SignInViewModel(this.signInPage);

  bool isValidMobileNumber(String value) {
    return value.length == 10 && int.tryParse(value) != null;
  }
}

// class   AuthenticationHelper {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   get user => _auth.currentUser;
//
//
//   // Future signUp({required String countryCode, required String phoneNumber}) async {
//   //   try {
//   //     await _auth.signInWithPhoneNumber(
//   //         countryCode,
//   //         phoneNumber as RecaptchaVerifier?,
//   //     );
//   //     return 'sucess';
//   //   } on FirebaseAuthException catch (e) {
//   //     return e.message;
//   //   }
//   // }
//   //
//   //
//   // Future signIn({required String phoneNumber, required String countryCode}) async {
//   //   try {
//   //     await _auth.signInWithPhoneNumber(phoneNumber : PhoneNumber,countryCode : CountryCode);
//   //     return 'sucess';
//   //   } on FirebaseAuthException catch (e) {
//   //     return 'invalid mobile Number try again later';
//   //   }
//   // }
// }