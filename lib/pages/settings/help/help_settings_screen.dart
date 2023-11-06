import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/controller/help_setting_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/settings/help/help_setting_view_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../service/network_connectivity.dart';

// ignore: must_be_immutable
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
          () async {
            controller = Get.find<HelpSettingController>();
            await helpSettingViewModel!.getVersionStatus();
            controller!.update();
          },
        );
      },
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor:Theme.of(context).colorScheme.background,
          appBar: getAppBar(context),
          body: getBody(context),
        ));
      },
    );
  }

  getAppBar(BuildContext context) {
    return AppAppBar(backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText(S.of(Get.context!).help, fontSize: 20.px,color: Theme.of(context).colorScheme.primary,),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () => supportUrlLaunch(),
          trailing: AppImageAsset(
              image: AppAsset.arrowSend, height: 20.px, width: 20.px),
          title: AppText(S.of(Get.context!).supportCenter,color: Theme.of(context).colorScheme.primary,),
        ),
        ListTile(
          onTap: () => Get.toNamed(RouteHelper.getContactUsScreen()),
          title: AppText(S.of(Get.context!).contactUs,color: Theme.of(context).colorScheme.primary,),
        ),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
        ListTile(
          onTap: () {},
          title: AppText(S.of(Get.context!).version,color: Theme.of(context).colorScheme.primary,),
          subtitle: AppText(helpSettingViewModel!.localVersion!,
              fontSize: 12.px, color:Theme.of(context).colorScheme.secondary,),
        ),
        ListTile(
          onTap: () => Get.toNamed(RouteHelper.getLicensesScreen()),
          title: AppText(S.of(Get.context!).licenses,color: Theme.of(context).colorScheme.primary,),
        ),
        ListTile(
          title: AppText(S.of(Get.context!).debugLog,color: Theme.of(context).colorScheme.primary,),
        ),
        ListTile(
          onTap: () => termsUrl(),
          trailing: AppImageAsset(
              image: AppAsset.arrowSend, height: 20.px, width: 20.px),
          title: AppText(S.of(Get.context!).terms,color: Theme.of(context).colorScheme.primary,),
        ),
        ListTile(
          title: AppText(
            S.of(Get.context!).helpDescription,
            color: Theme.of(context).colorScheme.secondary,
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
