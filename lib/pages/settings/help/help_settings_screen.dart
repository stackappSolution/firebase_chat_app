import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/help_setting_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/settings/help/help_setting_view_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSettingsScreen extends StatelessWidget {
  HelpSettingsScreen({Key? key}) : super(key: key);

  HelpSettingViewModel? helpSettingViewModel;
  HelpSettingController? controller;

  @override
  Widget build(BuildContext context) {
    helpSettingViewModel ?? (helpSettingViewModel = HelpSettingViewModel(this));

    return GetBuilder<HelpSettingController>(
      init: HelpSettingController(),
      initState: (state) {
        Future.delayed(
          const Duration(milliseconds: 0),
          () {
            controller = Get.find<HelpSettingController>();
            helpSettingViewModel!.getVersionStatus();
            controller!.update();
          },
        );
      },
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: AppColorConstant.appWhite,
          appBar: getAppBar(),
          body: getBody(),
        ));
      },
    );
  }

  getAppBar() {
    return AppAppBar(
      title: AppText(S.of(Get.context!).help, fontSize: 20.px),
    );
  }

  getBody() {
    return ListView(
      children: [
        ListTile(
          onTap: () {
            supportUrlLaunch();
          },
          trailing: AppImageAsset(
              image: AppAsset.arrowSend, height: 20.px, width: 20.px),
          title: AppText(S.of(Get.context!).supportCenter),
        ),
        ListTile(
          onTap: () {
            Get.toNamed(RouteHelper.getContactUsScreen());
          },
          title: AppText(S.of(Get.context!).contactUs),
        ),
        Divider(
          height: 2.px,
          color: AppColorConstant.grey,
        ),
        ListTile(
          onTap: () {},
          title: AppText(S.of(Get.context!).version),
          subtitle: AppText(helpSettingViewModel!.localVersion!,
              fontSize: 12.px, color: AppColorConstant.grey),
        ),
        ListTile(
          onTap: () {
            Get.toNamed(RouteHelper.getLicensesScreen());
          },
          title: AppText(S.of(Get.context!).licenses),
        ),
        ListTile(
          title: AppText(S.of(Get.context!).debugLog),
        ),
        ListTile(
          onTap: () {
            termsUrl();
          },
          trailing: AppImageAsset(
              image: AppAsset.arrowSend, height: 20.px, width: 20.px),
          title: AppText(S.of(Get.context!).terms),
        ),
        ListTile(
          title: AppText(
            S.of(Get.context!).helpDescription,
            color: AppColorConstant.grey,
            fontSize: 12.px,
          ),
        )
      ],
    );
  }

  supportUrlLaunch() async {
    final Uri url = Uri.parse('https://support.signal.org/hc/en-us');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    } else {
      logs('Unable to open URL $url');
    }
  }

  termsUrl() async {
    final Uri url = Uri.parse('https://signal.org/legal/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    } else {
      logs('Unable to open URL $url');
    }
  }
}
