import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/generated/l10n.dart';
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

  IntroPageController controller = IntroPageController();

  IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: IntroPageController(),
        initState: (introPage) {
          NetworkConnectivity.checkConnectivity(context);
        },
        builder: (IntroPageController controller) {
          return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(children: [
                    SizedBox(height: 80.px),
                    Padding(
                        padding: EdgeInsets.only(left: 8.px), child: image()),
                    textWelcome(context),
                    const Spacer(),
                    termsPrivacyPolicy(context),
                    getStartedButton(controller.introPageViewModal.isConnected,
                        context, controller),
                    transferOrRestoreAccount(),
                    SizedBox(height: 15.px)
                    termsPrivacyPolicy(),
                    getStartedButton(
                        controller.introPageViewModal.isConnected,
                        context,
                        controller),
                    transferOrRestoreAccount(context),
                    SizedBox(height:15.px)
                  ])));
        });
  }

  AppText transferOrRestoreAccount(BuildContext context) {
    return AppText(S.of(context).transferOrRestoreAccount,
        fontWeight: FontWeight.w500,
        color: AppColorConstant.appYellow,
        fontSize: 12.px);
  }

  AppButton getStartedButton(
      bool isConnected, context, IntroPageController controller) {
    return AppButton(
        onTap: () {
          goToSignInPage();
        },
        fontWeight: FontWeight.w500,
        margin: EdgeInsets.all(10.px),
        borderRadius: BorderRadius.circular(10.px),
        string: S.of(context).getStarted,
        fontColor: AppColorConstant.appWhite,
        fontSize: 20.px,
        width: 230.px,
        height: 50.px,
        color: AppColorConstant.appYellow,
        stringChild: false);
  }

  AppText termsPrivacyPolicy(context) {
    return AppText(S.of(Get.context!).termsPrivacyPolicy,
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.w500,
        fontSize: 12.px);
  }

  Column textWelcome(context) {
    return Column(children: [
      AppText(
        S.of(Get.context!).welcomeToChat,
        fontSize: 30.px,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
      Padding(
          padding: EdgeInsets.only(
            top: 10.px,
          ),
          child: AppText(S.of(Get.context!).theBestMessengerAndChat,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20.px)),
      AppText(S.of(Get.context!).toMakeYourDayGreat,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 18.px),
    ]);
  }

  AppImageAsset image() => AppImageAsset(
      height: 200.px, width: 200.px, image: 'assets/images/intro_page.png');

  void introPageInitState(context) {
    Map source = {ConnectivityResult.none: false};
    NetworkConnectivity.initialise();
    NetworkConnectivity.instance.myStream.listen((source) {
      source = source;
      logs('source $source');
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          controller.introPageViewModal.string =
              source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          controller.introPageViewModal.isConnected = true;
          break;
        case ConnectivityResult.wifi:
          controller.introPageViewModal.string =
              source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
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
        builder: (context) {
          return AppAlertDialog(
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    StringConstant.networkError,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText(
                    StringConstant.pleaseCheckYourInternet,
                    fontSize: 15.px,
                  )
                ]),
            actions: [
              AppButton(
                onTap: () {
                  Get.back();
                },
                fontColor: AppColorConstant.appWhite,
                string: StringConstant.back,
                fontSize: 20,
                borderRadius: BorderRadius.circular(15),
                height: 40,
                color: AppColorConstant.appYellow,
                stringChild: false,
                width: 100,
              )
            ],
            insetPadding: EdgeInsets.zero,
          );
        },
      )
          : null;
    });
  }
}
