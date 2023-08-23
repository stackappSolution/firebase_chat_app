import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  String phoneNumber = "";
  String v_id='';


  Future<void> sendOTP(String phoneNumber, String selectedCountry) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    await FirebaseAuth.instance.verifyPhoneNumber(verificationCompleted: (phoneAuthCredential) async {
      await auth.signInWithCredential(phoneAuthCredential);

    }, verificationFailed: (error) {
      if(e.hashCode == 'invalid-phone-number'){
        print('the Provided phone number is not valid.');

      }

    }, codeSent: (verificationId, forceResendingToken) {
      v_id=verificationId;

    }, codeAutoRetrievalTimeout: (verificationId) {

    },);
  }

  Future<void> verifyOTP(String verificationId, String smsCode) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
      print("Phone number verified.");
    } catch (e) {
      print("Failed to verify phone number: $e");
    }
  }
}
