import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/donate_to_chat_controller.dart';
import 'package:signal/routes/app_navigation.dart';

class DonateToChatPage extends StatelessWidget {
  const DonateToChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DonateToChatController(),
      initState: (state) {},
      builder: (DonateToChatController controller) {
        return Scaffold(
          appBar: const AppAppBar(),
          body: buildBody(),
        );
      },
    );
  }

  buildBody() {
    return Column(
      children: [
        SizedBox(
          height: 50.px,
        ),
        Center(
          child: Container(
            height: 130.px,
            width: 130.px,
            child: const Center(
                child: AppText(
              'N',
              fontSize: 60,
            )),
            decoration: BoxDecoration(
                color: AppColorConstant.grey,
                borderRadius: BorderRadius.circular(70)),
          ),
        ),
        SizedBox(
          height: 15.px,
        ),
        AppText(
          StringConstant.privacyOverprofit,
          color: Colors.black,
          fontSize: 20.px,
        ),
        SizedBox(
          height: 15.px,
        ),
        const AppText(
          textAlign: TextAlign.center,
          StringConstant.privacyOverprofitdis,
          color: AppColorConstant.appGrey,
        ),
        SizedBox(
          height: 15.px,
        ),
        AppElevatedButton(
          buttonWidth: 50,
          buttonColor: AppColorConstant.appYellow,
          buttonHeight: 40,
          widget: AppText(StringConstant.donatetochatapp,color: AppColorConstant.appWhite),
          onPressed: () {
            goToDonateScreen();
          },
        ),
        SizedBox(height: 10.px,),
        Divider(thickness: 1,),
        SizedBox(height: 15.px,),
        Row(
          children: [
            SizedBox(width: 20.px,),
            AppText(StringConstant.otherwayto),
          ],
        ),
        SizedBox(height: 18.px,),
        Row(
          children: [
            SizedBox(width: 22.px),
            Icon(Icons.card_giftcard),
            SizedBox(width: 22.px),
            AppText(StringConstant.donatefriend),
          ],
        )
      ],
    );
  }
}
