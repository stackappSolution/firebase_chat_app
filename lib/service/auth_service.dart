

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/routes/app_navigation.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  bool isOtpSent = false;

  TextEditingController otpcontroller = TextEditingController();
  static String verificationID = '';

  Future<bool?> verifyOtp({String? verificationID, String? smsCode, String? phoneNumber}) async {
    logs("v id--->$verificationID");
    logs("smsCode--->$smsCode");
    logs("phoneNumber--->$phoneNumber");

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID!,
        smsCode: smsCode!,
      );
      isOtpSent = true;
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
       goToProfilePage();
      } else {
        logs("User is null after OTP verification");
        return goToIntroPage();
      }

    } catch (e) {
      isOtpSent = false;
      logs("Exception in verifyOtp --> $e");
    }
    return  true;
  }
}

