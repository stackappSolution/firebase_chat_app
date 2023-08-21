
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';



import 'package:signal/routes/routes_helper.dart';
import '../../app/widget/app_alert_dialog.dart';
import '../../app/widget/app_button.dart';
import '../../app/widget/app_image_assets.dart';
import '../../app/widget/app_text.dart';
import '../../constant/color_constant.dart';
import '../../constant/string_constant.dart';
import '../../controller/intro_page_controller.dart';
import '../../service/network_connectivity.dart';
import 'package:connectivity/connectivity.dart';

class IntroPage extends StatelessWidget {
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  IntroPageController controller = IntroPageController();

  IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: IntroPageController(),
        initState: (introPage) {
          introPageInitState(context);
        },
        builder: (IntroPageController controller) {
          return Scaffold(
              body: Container(
                  //padding: EdgeInsets.all(10.px),
                height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [AppColorConstant.appWhite, AppColorConstant.lightOrange],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      SizedBox(height: 80.px),
                      Padding(padding: EdgeInsets.only(left: 8.px), child: image()),
                      textWelcome(),
                      termsPrivacyPolicy(),
                      getStartedButton(
                          controller.introPageViewModal.isConnected, context, controller),
                      transferOrRestoreAccount()
                    ]),
                  )));
        });
  }

  AppText transferOrRestoreAccount() {
    return AppText(StringConstant.transferOrRestoreAccount,
        fontWeight: FontWeight.w500, color: AppColorConstant.orange, fontSize: 12.px);
  }

  AppButton getStartedButton(bool isConnected, context, IntroPageController controller) {
    return AppButton(
        onTap: () {

          Get.toNamed(RouteHelper.getHomeScreen());

          Get.toNamed(RouteHelper.getSignInPage());

        },
        fontWeight: FontWeight.w500,
        margin: EdgeInsets.all(10.px),
        borderRadius: BorderRadius.circular(10.px),
        string: StringConstant.getStarted,
        fontColor: AppColorConstant.appWhite,
        fontSize: 20.px,
        width: 230.px,
        height: 50.px,
        color: AppColorConstant.orange,
        stringChild: false);
  }

  AppText termsPrivacyPolicy() {
    return AppText(StringConstant.termsPrivacyPolicy,
        color: AppColorConstant.appLightBlack, fontWeight: FontWeight.w500, fontSize: 12.px);
  }

  Column textWelcome() {
    return Column(children: [
      AppText(StringConstant.welcomeToChat, fontSize: 30.px, fontWeight: FontWeight.w600),
      Padding(
          padding: EdgeInsets.only(
            top: 10.px,
          ),
          child: AppText(StringConstant.theBestMessengerAndChat,
              fontWeight: FontWeight.w400, color: AppColorConstant.appLightBlack, fontSize: 20.px)),
      AppText(StringConstant.toMakeYourDayGreat,
          fontWeight: FontWeight.w400, color: AppColorConstant.appLightBlack, fontSize: 18.px),
      SizedBox(height: 200.px)
    ]);
  }

  AppImageAsset image() => AppImageAsset(height: 200.px, width: 200.px, image: 'assets/images/intro_page.png');
  void introPageInitState(context){ _networkConnectivity.initialise();
  _networkConnectivity.myStream.listen((source) {
    _source = source;
    print('source $_source');
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        controller.introPageViewModal.string =
        _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
        controller.introPageViewModal.isConnected = true;
        break;
      case ConnectivityResult.wifi:
        controller.introPageViewModal.string =
        _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
        controller.introPageViewModal.isConnected = true;
        break;
      case ConnectivityResult.none:
      default:
        controller.introPageViewModal.isConnected = false;
        controller.introPageViewModal.string = 'Offline';
    }
    (controller.introPageViewModal.isConnected == false)
        ? showDialog(
      context: context,
      builder: (context) {return
        AppAlertDialog(
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const AppText(
              'Network error : \n',
              fontWeight: FontWeight.bold,
            ),
            AppText(
              'Please check your internet connection or try again later.',
              fontSize: 15.px,
            )
          ]),
          actions: [
            AppButton(
              onTap: () {
                Get.back();
              },
              fontColor: AppColorConstant.appScaffold,
              string: 'Back',
              fontSize: 20,
              borderRadius: BorderRadius.circular(15),
              height: 40,
              color: AppColorConstant.orange,
              stringChild: false,
              width: 100,
            )
          ],
        );
      },
    ) : null;
  });}
}

