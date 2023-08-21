import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorem_gen/lorem_gen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/generated/l10n.dart';

class LicensesScreen extends StatelessWidget {
  const LicensesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstant.appWhite,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  getAppBar() {
    return AppAppBar(
      title: AppText(S.of(Get.context!).licenses, fontSize: 20.px),
    );
  }

  getBody() {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(height: 20.px,),
         AppText('https://support.signal.org/hc/en-us',fontSize: 12.px),
         AppText('https://signal.org/legal/',fontSize: 12.px),
         AppText('https://support.signal.org/hc/en-us/articles/360007318591',fontSize: 12.px),
         AppText('https://support.signal.org/hc/en-us',fontSize: 12.px),
        Padding(
            padding: EdgeInsets.all(20.px),
            child: AppText(
              Lorem.paragraph(numParagraphs: 12),
              fontSize: 12.px,
              color: AppColorConstant.grey,
            )),
        Padding(
            padding: EdgeInsets.all(20.px),
            child: AppText(
              Lorem.paragraph(numSentences: 12),
              fontSize: 12.px,
              color: AppColorConstant.grey,
            )),
        Padding(
            padding: EdgeInsets.all(20.px),
            child: AppText(
              Lorem.sentence(
                numSentences: 30,
              ),
              fontSize: 12.px,
              color: AppColorConstant.grey,
            )),
      ],
    );
  }
}
