import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/controller/sign_in_controller.dart';
import 'package:signal/controller/vreify_otp_controller.dart';
import 'package:signal/routes/app_navigation.dart';

import '../app/app/utills/toast_util.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static VerifyOtpController? verifyOtpController;
  static SignInController? signInController;

  AuthService._privateConstructor();

  static final AuthService instance = AuthService._privateConstructor();
  static String verificationID = '';

  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool isOtpSent = false;
  static bool isTimerRunning = false;
  static int countdownSeconds = 30; // Set the countdown duration in seconds
  static bool isVerifyLoading = false;
  static bool isResend = false;

  static bool canResendOTP() {
    return !isTimerRunning;
  }

  static Future verifyPhoneNumber(
    countryCode,
    contact,
  ) async {
    signInController = Get.find<SignInController>();
    //verifyOtpController = Get.put(VerifyOtpController());


    isResend = true;
    logs("isResend  --- $isResend");
   // verifyOtpController!.update();

    logs("entred contact IS------------->   $contact");

    verified(AuthCredential authResult) async {
      await auth.signInWithCredential(authResult);
    }

    verificationFailed(FirebaseAuthException authException) {
      logs(authException.message.toString());
    }

    smsSent(String verificationId, [int? forceResendingToken]) {
      verificationID = verificationId;
      signInController!.update();
      ToastUtil.successToast("OTP sent Successfully");
      logs("OTP Sent to your phone");
      isResend = false;

      startTimer(); // Start the timer when OTP is sent
      signInController!.update();
      //verifyOtpController!.update();

      logs("verfication id :::::${verificationID}");

      goToVerifyPage(phonenumber: contact, selectedCountry: countryCode);
      signInController!.update();
    }

    autoRetrievalTimeout(String verificationId) {
      verificationID = verificationId;
      signInController!.update();
      logs(verificationID);
    }

    await auth.verifyPhoneNumber(
      phoneNumber: contact.trim(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
    signInController!.update();
  }

  static Future signInWithOTP(String otp) async {
    logs("Entered OTP is: $otp");

    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationID,
        smsCode: otp.trim(),
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      if (userCredential.user != null) {
        logs("OTP verified and logged in");
        ToastUtil.successToast("OTP Verified");
        goToProfilePage();
      } else {
        isVerifyLoading = false;
        logs("Incorrect OTP");
        ToastUtil.warningToast("incorrect OTP");
      }
    } catch (e) {
      isVerifyLoading = false;
      logs("Login error Error: $e");
      ToastUtil.warningToast("Incorrect OTP");
    }
  }

  static void startTimer() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        verifyOtpController = Get.find<VerifyOtpController>();
      },
    );
    isTimerRunning = true;
    countdownSeconds = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownSeconds--;
      verifyOtpController!.update();

      if (countdownSeconds <= 0) {
        timer.cancel();
        isTimerRunning = false;
        verifyOtpController!.update();
      }
    });
  }
}
