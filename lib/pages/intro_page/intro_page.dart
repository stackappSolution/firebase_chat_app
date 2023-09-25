import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/generated/l10n.dart';
import '../../app/widget/app_alert_dialog.dart';
import '../../app/widget/app_button.dart';
import '../../app/widget/app_image_assets.dart';
import '../../app/widget/app_text.dart';
import '../../constant/color_constant.dart';
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
          body: Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 80.px),
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.px,
                    bottom: 10.px,
                    right: 25.px,
                  ),
                  child: image(),
                ),
                textWelcome(context),
                const Spacer(),
                termsPrivacyPolicy(context),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppElevatedButton(
                    buttonRadius: 10.px,
                    onPressed: () {
                      goToSignInPage();
                    },
                    buttonColor: AppColorConstant.appYellow,
                    buttonHeight: 50.px,
                    buttonWidth: 200.px,
                    widget: AppText(
                      S.of(context).getStarted,
                      color: AppColorConstant.appWhite,
                      fontSize: 18.px,
                    ),
                  ),
                ),
                transferOrRestoreAccount(context),
                SizedBox(height: 50.px),
              ],
            ),
          ),
        );
      },
    );
  }

  AppText transferOrRestoreAccount(BuildContext context) {
    return AppText(
      S.of(context).transferOrRestoreAccount,
      fontWeight: FontWeight.w500,
      color: AppColorConstant.appYellow,
      fontSize: 12.px,
    );
  }

  AppText termsPrivacyPolicy(context) {
    return AppText(
      S.of(Get.context!).termsPrivacyPolicy,
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.w500,
      fontSize: 12.px,
    );
  }

  Column textWelcome(context) {
    return Column(
      children: [
        AppText(
          S.of(Get.context!).welcomeToChat,
          fontSize: 25.px,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 8.px,
          ),
          child: AppText(
            S.of(Get.context!).theBestMessengerAndChat,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        AppText(
          S.of(Get.context!).toMakeYourDayGreat,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 14.px,
        ),
      ],
    );
  }

  AppImageAsset image() => AppImageAsset(
      height: 250.px, width: 250.px, image: 'assets/images/intro_page.png');

  void introPageInitState(context) {
    NetworkConnectivity.initialise();
    NetworkConnectivity.instance.myStream.listen(
      (source) {
        source = source;
        logs('source $source');
        switch (source.keys.toList()[0]) {
          case ConnectivityResult.mobile:
            controller.introPageViewModal.string = source.values.toList()[0]
                ? 'Mobile: Online'
                : 'Mobile: Offline';
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
                          "networkError",
                          fontWeight: FontWeight.bold,
                        ),
                        AppText(
                          "pleaseCheckYourInternet",
                          fontSize: 15.px,
                        )
                      ],
                    ),
                    actions: [
                      AppButton(
                        onTap: () {
                          Get.back();
                        },
                        fontColor: AppColorConstant.appWhite,
                        string: "back",
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
      },
    );
  }
}
