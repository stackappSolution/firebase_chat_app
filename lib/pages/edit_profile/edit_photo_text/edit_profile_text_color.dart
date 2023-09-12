import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';

import '../../../app/widget/app_elevated_button.dart';

class EditProfileTextColor extends StatelessWidget {
  const EditProfileTextColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      floatingActionButton: getFloatingActionButton(),
    );
  }

  getFloatingActionButton() {
    return AppElevatedButton(
        buttonHeight: 40.px,
        buttonWidth: 80.px,
        widget: AppText(
          'Save',
          color: AppColorConstant.appWhite,
          fontSize: 20.px,
        ),
        isBorderShape: true,
        buttonColor: AppColorConstant.appYellow);
  }

  getBody() {
    List<Color> chatColors = [
      AppColorConstant.darkBlue,
      AppColorConstant.darkOrange,
      AppColorConstant.yellowGrey,
      AppColorConstant.darkGreen,
      AppColorConstant.teal,
      AppColorConstant.pinkPurple,
      AppColorConstant.greyPink,
      AppColorConstant.darkGrey,
      AppColorConstant.extraLightPurple,
      AppColorConstant.extraDarkOrange,
      AppColorConstant.pink,
      AppColorConstant.lightSky,
    ];
    return Padding(
      padding: EdgeInsets.only(top: 15.px, bottom: 15.px),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70.px,
                backgroundColor: Colors.red,
              ),
            ],
          ),
          SizedBox(
            height: 100.px,
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: chatColors.length,
              padding: EdgeInsets.only(right: 10.px, left: 10.px),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10.px),
                  child: CircleAvatar(
                    backgroundColor: chatColors[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
