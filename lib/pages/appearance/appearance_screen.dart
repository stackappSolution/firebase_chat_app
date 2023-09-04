import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/appearance_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/appearance/appearance_view_model.dart';
import 'package:signal/pages/chating_page/chating_page.dart';

// ignore: must_be_immutable
class AppearanceScreen extends StatelessWidget {
  AppearanceViewModel? appearanceViewModel;
  AppearanceController? controller;

  AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    appearanceViewModel ?? (appearanceViewModel = AppearanceViewModel(this));

    return GetBuilder<AppearanceController>(
      init: AppearanceController(),
      initState: (state) async {
        Future.delayed(
          const Duration(milliseconds: 100),
          () async {
            controller = Get.find<AppearanceController>();
            Future<String?> key = getStringValue(getLanguage);
            String? result = await key;
            appearanceViewModel!.locale = Locale(result!);

            Future<String?> currentLanguage = getStringValue(language);
            String? selectedLanguage = await currentLanguage;
            logs("default Language--> $selectedLanguage");
            appearanceViewModel!.selectedLanguage = selectedLanguage;

            String? currentFontSize =await getStringValue(fontSizes);
            String? selectedFontSize = currentFontSize;
            logs("default FontSize--> $selectedFontSize");
            appearanceViewModel!.saveFontSize = selectedFontSize;
            controller!.update();
          },
        );
      },
      builder: (AppearanceController controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppBar(context),
          body: getBody(context, controller, appearanceViewModel!),
        ));
      },
    );
  }

  getAppBar(context) {
    return AppAppBar(
        title: AppText(
      S.of(Get.context!).appearance,
      fontSize: 22.px,
      color: Theme.of(context).colorScheme.primary,
    ));
  }

  getBody(BuildContext context, AppearanceController controller,
      AppearanceViewModel appearanceViewModel) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 30.px),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        appearanceViewTile(
            1,
            context,
            S.of(Get.context!).language,
            (appearanceViewModel.selectedLanguage != null)
                ? appearanceViewModel.selectedLanguage
                : "default",
            controller),
        appearanceViewTile(
            2,
            context,
            S.of(Get.context!).theme,
            appearanceViewModel.selectedTheme
                .toString()
                .substring(10)
                .capitalizeFirst,
            controller),
       appearanceViewTile(
           3, context, S.of(Get.context!).chatColor, "", controller),
        appearanceViewTile(
            4, context, S.of(Get.context!).appIcon, "", controller),
        appearanceViewTile(5, context, S.of(Get.context!).messageFontSize,
            (appearanceViewModel.saveFontSize != null)
                ? appearanceViewModel.saveFontSize
                : "default", controller),
        appearanceViewTile(6, context, S.of(Get.context!).navigationBarSize,
            StringConstant.normal, controller),
      ]),);}


  appearanceViewTile(
    index,
    context,
    title,
    subtitle,
    AppearanceController controller,
  ) {
    return InkWell(
      onTap: () {
       appearanceViewModel!.mainTap(index, context, controller);
      },
      child: Container(width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 25.px, vertical: 13.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              color: Theme.of(context).colorScheme.primary,
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.px),
              child: AppText(
                subtitle,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }
}
