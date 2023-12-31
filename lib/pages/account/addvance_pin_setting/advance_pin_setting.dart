
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/service/network_connectivity.dart';

import '../../../app/app/utills/theme_util.dart';
import '../../../controller/advance_pin_controller.dart';
import 'advance_pin_view_model.dart';

// ignore: must_be_immutable
class AdvancePinSettingScreen extends StatelessWidget {
  AdvancePinViewModel? advancePinViewModel;

  AdvancePinSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    advancePinViewModel ?? (advancePinViewModel = AdvancePinViewModel(this));

    return GetBuilder<AdvancePinController>(
      init: AdvancePinController(),
      initState: (state) {},
      builder: (controller) {
        return  Builder(builder: (context) {
          MediaQueryData mediaQuery = MediaQuery.of(context);
          ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
          return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppAppBar(
              title: AppText(
            S.of(context).advancePinSetting,
            fontSize: 22.px,
            color: Theme.of(context).colorScheme.primary,
          )),
          body: getBody(context),
        );});
      },
    );
  }

  getBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.px, left: 17.px, right: 17.px),
      child: InkWell(
        onTap: () {
          advancePinViewModel!.disablePinTap(context);
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppText(
            S.of(context).disablePIN,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.px,
          ),
          AppText(
            S.of(context).ifYouDisable,
            fontSize: 14.px,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ]),
      ),
    );
  }
}
