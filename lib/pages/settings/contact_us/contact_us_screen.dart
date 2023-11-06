import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/settings/contact_us/contact_us_view_model.dart';

import '../../../service/network_connectivity.dart';

// ignore: must_be_immutable
class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({Key? key}) : super(key: key);

  ContactUsViewModel? contactUsViewModel;

  SettingsController? controller;

  @override
  Widget build(BuildContext context) {
    contactUsViewModel ?? (contactUsViewModel = ContactUsViewModel(this));
    return GetBuilder<SettingsController>(
      initState: (state) {
        Future.delayed(
          const Duration(milliseconds: 0),
          () async {
            controller = Get.find<SettingsController>();

            Future<String?> key = getStringValue(emoji);
            String? result = await key;
            logs("emoji--> $result");
            controller!.update();
          },
        );
      },
      init: SettingsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppBar(context),
          body: getBody(context),
          bottomNavigationBar: buildNextButton(),
        );
      },
    );
  }

  SingleChildScrollView getBody(BuildContext context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(S.of(Get.context!).contactUs,color:  Theme.of(context).colorScheme.primary,),
            SizedBox(
              height: 10.px,
            ),
            descriptionField(),
            SizedBox(
              height: 10.px,
            ),
            AppText(S.of(Get.context!).tellUs,
                color: Theme.of(context).colorScheme.primary, fontSize: 15.px),
            selectReasonView(),
            AppText(
              'How Do you Feel? (Optional)',
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12.px,
            ),
            buildEmojiView(),
            includeDebugLogView(),
          ],
        ),
      ),
    );

  TextFormField descriptionField() => TextFormField(
      cursorColor: AppColorConstant.appBlack,
      style: const TextStyle(color: AppColorConstant.appBlack),
      maxLines: 6,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
          hintText: S.of(Get.context!).tellUs,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: AppColorConstant.grey.withOpacity(0.3)),
    );

  getAppBar(BuildContext context) => AppAppBar(
      title: AppText(S.of(Get.context!).help, fontSize: 20.px,
        color: Theme.of(context).colorScheme.primary,),
    );

  StatefulBuilder selectReasonView() {
    String dropdownValue = S.of(Get.context!).other;
    List<String> list = [
      S.of(Get.context!).somethingNotWorking,
      S.of(Get.context!).featureRequest,
      S.of(Get.context!).question,
      S.of(Get.context!).feedback,
      S.of(Get.context!).other,
    ];
    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButton<String>(
          value: dropdownValue,
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: AppText(value,
                  fontSize: 15, color: Theme.of(context).colorScheme.primary,),
            );
          }).toList(),
          onChanged: (String? newValue) => setState(() {
              dropdownValue = newValue!;
            }),
        );
      },
    );
  }

  Row buildEmojiView() {
    List<String> emojis = ['😃', '😋', '🤩', '😌'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: emojis.map((emoji) {
        return GestureDetector(
          onTap: () {
            controller!.selectedEmoji = emoji;
            controller!.selectEmoji(emoji);
            setStringValue(emoji, emoji);
            controller!.update();
            logs('selected--> ${controller!.selectedEmoji}');
          },
          child: Container(
              padding: const EdgeInsets.all(5),
              child: (controller!.selectedEmoji == emoji)
                  ? Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColorConstant.blue, width: 5.px)),
                      child: AppText(emoji, fontSize: 40))
                  : AppText(emoji, fontSize: 40)),
        );
      }).toList(),
    );
  }

  Row buildNextButton() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
            onTap: () => contactUsViewModel!.faqUrl(),
            child: AppText(S.of(Get.context!).readFaq,
                color: AppColorConstant.blue, fontSize: 15.px)),
        AppButton(
          margin: EdgeInsets.all(12.px),
          borderRadius: BorderRadius.circular(20.px),
          height: 45.px,
          color: AppColorConstant.appYellow.withOpacity(0.8),
          stringChild: true,
          width: 80.px,
          child: AppText(S.of(Get.context!).next,
              color: AppColorConstant.appWhite),
        )
      ],
    );

  StatefulBuilder includeDebugLogView() {
    bool isSelected = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) => setState(() {
                  isSelected = value!;
                }),
            ),
            AppText(
              S.of(Get.context!).includeDebug,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12.px,
            ),
            SizedBox(
              width: 20.px,
            ),
            InkWell(
              onTap: () => contactUsViewModel!.includeDebugUrl(),
              child: AppText(
                S.of(Get.context!).whatsThis,
                color: Colors.blue,
                fontSize: 12.px,
              ),
            )
          ],
        );
      },
    );
  }
}
