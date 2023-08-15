import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signal/pages/signin_pages/sign_in_page.dart';

class SignInViewModel {

  late SignInPage? signInPage;

  TextEditingController phoneNumber = TextEditingController();
  String countryCode = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  String v_id = "";
  CountryCode selectedCountry = CountryCode.fromCountryCode('IN');
  String mobileNumber = '';
  bool isValidNumber = false;


  SignInViewModel(this.signInPage);

  bool isValidMobileNumber(String value) {
    return value.length == 10 && int.tryParse(value) != null;
  }
}

class   AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;


  Future signUp({required String countryCode, required String phoneNumber}) async {
    try {
      await _auth.signInWithPhoneNumber(
          countryCode,
          phoneNumber as RecaptchaVerifier?,
      );
      return 'sucess';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'sucess';
    } on FirebaseAuthException catch (e) {
      return 'invalid mobile Number try again later';
    }
  }
}