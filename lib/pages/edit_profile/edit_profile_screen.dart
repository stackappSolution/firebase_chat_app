import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/edit_profile_controller.dart';
import 'package:signal/pages/edit_profile/edit_profile_view_model.dart';

import '../appearance/appearance_screen.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileViewModel? editProfileViewModel;

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    editProfileViewModel ?? (editProfileViewModel = EditProfileViewModel(this));

    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          appBar: getAppBar(),
          body: getBody(context),
        ));
      },
    );
  }

  getBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 40.px),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 40.px,
                ),
                Container(
                  width: 100.px,
                  height: 33.px,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10.px, bottom: 37.px),
                  decoration: BoxDecoration(
                    color: AppColorConstant.appBlack.withOpacity(0.1),borderRadius: BorderRadius.all(Radius.circular(30.px))
                  ),
                  child: AppText(
                    StringConstant.editPhoto,
                    fontSize: 12.px,fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            const Icon(Icons.account_circle),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(StringConstant.profile),
                  AppText(StringConstant.yourProfile,
                      color: AppColorConstant.appBlack.withOpacity(0.5),
                      fontSize: 14.px),
                ],
              ),
            )
          ],
        ),
        Row(
          children: [
            const Icon(Icons.edit),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 27),
              child: Column(
                children: [
                  InkWell(onTap: () {
                    editProfileViewModel!.AboutTap(context);
                  },child: const AppText(StringConstant.about)),
                  AppText(StringConstant.profile,
                      color: AppColorConstant.appBlack.withOpacity(0.5),
                      fontSize: 14.px),
                ],
              ),
            )
          ],
        ),
        Row(
          children: [
            const Icon(Icons.badge_outlined),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: const Column(
                children: [
                  AppText(StringConstant.badges),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 35.px),
          child: AppText(
            StringConstant.yourProfileAndChanges,
            fontSize: 13.px,
            color: AppColorConstant.appBlack.withOpacity(0.5),
          ),
        )
      ]),
    );
  }

  getAppBar() {
    return AppAppBar(
        title: AppText(
      StringConstant.profile,
      fontSize: 20.px,
    ));
  }
}
