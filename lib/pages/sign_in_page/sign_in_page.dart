import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/sign_in_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/sign_in_page/sign_in_view_model.dart';
import 'package:signal/routes/routes_helper.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationID ='';
  CountryCode selectedCountry = CountryCode.fromCountryCode('IN');
  SignInViewModel? signInViewModel;

  @override
  Widget build(BuildContext context) {
    signInViewModel ?? (signInViewModel = SignInViewModel(this));
    return GetBuilder(
        init: SignInController(),
        initState: (state) {},
        builder: (SignInController controller) {
          return  SafeArea(
            child: Scaffold(
                body: buildsignInPage(signInViewModel!.selectedCountry.toString(),
                    signInViewModel!.phoneNumber.text, context, controller)),
          );
        }
    );
  }

  Container buildsignInPage(
      String countryCode,
      String phoneNumber,
      BuildContext context,
      SignInController controller,
      ) =>
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColorConstant.appWhite.withOpacity(0.1),
              AppColorConstant.appYellow.withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80.px,
              ),
              Align(
                alignment: Alignment.center,
                child: AppImageAsset(
                  height: 250.px,
                  image: AppAsset.signIn,
                ),
              ),
              SizedBox(
                height: 20.px,
              ),
              Container(
                  margin: EdgeInsets.only(left: 20.px),
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    S.of(Get.context!).signal,
                    fontSize: 30.px,
                    fontWeight: FontWeight.w600,
                  )),
              Container(
                margin: EdgeInsets.only(left: 20.px),
                child: AppText(
                  S.of(Get.context!).signInDescription,
                  color: AppColorConstant.appLightBlack.withOpacity(0.4),
                  fontWeight: FontWeight.w400,
                  fontSize: 15.px,
                ),
              ),
              SizedBox(
                height: 15.px,
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 20.px),
                    height: 50.px,
                    width: 90.px,
                    decoration: BoxDecoration(
                        color: AppColorConstant.appYellow.withOpacity(0.1),
                        border: Border.all(color: AppColorConstant.appYellow),
                        borderRadius: BorderRadius.circular(13.px)),
                    child: CountryCodePicker(
                      showFlag: false,
                      showFlagDialog: true,
                      onChanged: (country) {
                        signInViewModel!.selectedCountry = country;
                      },
                      initialSelection: 'IN',
                      textStyle: const TextStyle(
                        color: AppColorConstant.appBlack,
                        fontWeight: FontWeight.w600,),
                      // Set initial country code
                      favorite: const ['IN'], // Specify favorite country codes
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.px),
                              color:
                              AppColorConstant.appYellow.withOpacity(0.1)),
                          height: 50.px,
                          margin: EdgeInsets.only(left: 10.px, right: 10.px),
                          child: AppTextFormField(
                            labelText: S.of(context).phoneNumber,
                            labelStyle: TextStyle(
                                color: AppColorConstant.appYellow,
                                fontSize: 20.px),
                            controller: signInViewModel!.phoneNumber,
                            style: TextStyle(
                              fontSize: 22.px,
                              fontWeight: FontWeight.w400,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null && value!.isEmpty) {
                                return 'Mobile number is required';
                              } else if (signInViewModel!
                                  .isValidMobileNumber(value)) {
                                return 'Invalid mobile number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.length == 10) {
                                signInViewModel!.isValidNumber = true;
                                controller.update();
                              } else {
                                signInViewModel!.isValidNumber = false;
                                controller.update();
                              }
                            },
                            keyboardType: TextInputType.number,
                            fontSize: 20.px,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 150.px,
              ),
              if (signInViewModel!.isValidNumber != true)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                        backgroundColor: MaterialStatePropertyAll(
                            AppColorConstant.appYellow.withOpacity(0.5)),
                        fixedSize:
                        MaterialStatePropertyAll(Size(230.px, 50.px))),
                    child: AppText(
                      S.of(context).continues,
                      fontSize: 22.px,
                      color: AppColorConstant.appWhite,
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      logs("entred contact IS------------->   $countryCode$phoneNumber");
                      verified(AuthCredential authResult) async {
                        await auth.signInWithCredential(authResult);
                      }
                      verificationFailed(FirebaseAuthException authException) {
                        logs(authException.message.toString());
                      }
                      smsSent(String verificationId, [int? forceResendingToken]) {
                        verificationID = verificationId;
                        logs("OTP Sent to your phone");
                        logs("verfication id :::::$verificationID");
                      }
                      autoRetrievalTimeout(String verificationId) {
                        controller.update();
                        logs(verificationID);
                      }
                      await auth.verifyPhoneNumber(
                        phoneNumber:"$countryCode$phoneNumber",
                        timeout: const Duration(seconds: 60),
                        verificationCompleted: verified,
                        verificationFailed: verificationFailed,
                        codeSent: smsSent,
                        codeAutoRetrievalTimeout: autoRetrievalTimeout,
                      );
                      Get.toNamed(RouteHelper.getVerifyOtpPage(),
                          parameters: {
                            'selectedCountry': selectedCountry.toString(),
                            'phoneNo': phoneNumber,
                            'verificationid':verificationID,
                          }
                      );
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        backgroundColor: const MaterialStatePropertyAll(
                            AppColorConstant.appYellow),
                        fixedSize:
                        MaterialStatePropertyAll(Size(230.px, 50.px))),
                    child: AppText(
                      S.of(context).continues,
                      fontSize: 22.px,
                      color: AppColorConstant.appWhite,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}