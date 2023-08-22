import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/edit_profile_controller.dart';
import 'package:signal/pages/edit_profile/edit_profile_view_model.dart';

// ignore: must_be_immutable
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
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppBar(context),
          body: getBody(context),
        ));
      },
    );
  }

  getBody(BuildContext context) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 40.px),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding:  EdgeInsets.only(bottom: 10.px),
                  child: CircleAvatar(
                    radius: 40.px,backgroundColor: AppColorConstant.yellowLight,
                  ),
                ),
                InkWell(onTap: () {
                  editProfileViewModel!.editPhotoTap();
                },
                  child: Container(
                    width: 100.px,
                    height: 33.px,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColorConstant.yellowLight,
                        borderRadius: BorderRadius.all(Radius.circular(30.px)),
                        ),
                    child: AppText(
                      StringConstant.editPhoto,
                      fontSize: 12.px,
                      fontWeight: FontWeight.bold,
                      color: primaryTheme,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Padding(
          padding:  EdgeInsets.only(top: 33.px),
          child: Row(
            children: [
              const Icon(Icons.account_circle),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.px),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(StringConstant.profile, color: primaryTheme),
                    AppText(StringConstant.yourProfile,
                        color: secondaryTheme, fontSize: 14.px),
                  ],
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.edit),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 27),
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        editProfileViewModel!.AboutTap(context);
                      },
                      child:
                          AppText(StringConstant.about, color: primaryTheme)),
                  AppText(StringConstant.profile,
                      color: secondaryTheme, fontSize: 14.px),
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
              child: Column(
                children: [
                  AppText(StringConstant.badges, color: primaryTheme),
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
            color: secondaryTheme,
          ),
        )
      ]),
    );
  }

  getAppBar(context) {
    return AppAppBar(
        title: AppText(
      StringConstant.profile,
      fontSize: 20.px,
      color: Theme.of(context).colorScheme.primary,
    ));
  }
}
