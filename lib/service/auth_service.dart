import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/routes/routes_helper.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;


  Future<void> phoneAuth(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          Get.toNamed(RouteHelper.getVerifyOtpPage(), parameters: {
            'verificationId': verificationId,
            'phoneNo': phoneNumber
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
      );
    } catch (e) {
      logs("exception in sendOtp--> $e");
    }
  }

  Future<void> verifyOtp(
      {String? verificationId, String? smsCode, String? phoneNo,String? code}) async {
    logs("verificationId--->$verificationId");
    logs("smsCode--->$smsCode");
    logs("phoneNumber--->$phoneNo");
    logs(("code--> $code"));
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode!,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        // OTP verification is successful, navigate to the profile screen
        Get.offAllNamed(RouteHelper.getProfileScreen(),parameters: {'phoneNo': '$code$phoneNo',});
      } else {
        // Handle the case where user is null
        logs("User is null after OTP verification");
      }
    } catch (e) {
      // Handle the error appropriately
      logs("Exception in verifyOtp --> $e");
      if (e is FirebaseAuthException) {
        // Handle specific Firebase Authentication exceptions
        logs("FirebaseAuthException - Code: ${e.code}, Message: ${e.message}");
      } else {
        // Handle other exceptions that may occur
        logs("An unexpected error occurred during OTP verification");
      }
    }
  }
}
