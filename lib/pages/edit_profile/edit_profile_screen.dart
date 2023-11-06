import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/edit_profile_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/edit_profile/add_photo_screen.dart';
import 'package:signal/pages/edit_profile/edit_profile_about_screen/edit_profile_about_screen.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_screen.dart';
import 'package:signal/pages/edit_profile/edit_profile_view_model.dart';
import 'package:signal/service/users_service.dart';

import '../../service/network_connectivity.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  EditProfileViewModel? editProfileViewModel;

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    editProfileViewModel ?? (editProfileViewModel = EditProfileViewModel(this));

    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      initState: (state) {},
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

  Padding getBody(BuildContext context) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 40.px),
      child: StreamBuilder(
        stream: UsersService.getUserStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const AppText('');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppText('');
          }
          final data = snapshot.data!.docs;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.px),
                        child: data[0]['photoUrl'].isEmpty
                            ? CircleAvatar(
                                maxRadius: 40.px,
                                backgroundColor:
                                    AppColorConstant.appYellow.withOpacity(0.8),
                                child: AppText(
                                    data[0]['firstName']
                                        .substring(0, 1)
                                        .toString()
                                        .toUpperCase(),
                                    fontSize: 35.px,
                                    color: AppColorConstant.appWhite),
                              )
                            : CircleAvatar(
                                maxRadius: 40.px,
                                backgroundImage:
                                    NetworkImage(data[0]['photoUrl']),
                              ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(AddPhotoScreen());
                        },
                        child: Container(
                          width: 97.px,
                          height: 29.px,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColorConstant.appYellow.withOpacity(0.8),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.px)),
                          ),
                          child: AppText(
                            S.of(context).editPhoto,
                            fontSize: 12.px,
                            fontWeight: FontWeight.bold,
                            color: AppColorConstant.appWhite,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 33.px),
                child: InkWell(
                  onTap: () {
                    Get.to(EditProfileNameScreen(data[0]));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.account_circle),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.px),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(S.of(context).profile, color: primaryTheme),
                            AppText(
                                '${data[0]['firstName']} ${data[0]['lastName']}',
                                color: secondaryTheme,
                                fontSize: 14.px),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(EditProfileAboutScreen(data[0]['about']));
                },
                child: Row(
                  children: [
                    const Icon(Icons.edit),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.px, vertical: 27),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(S.of(context).about, color: primaryTheme),
                          data[0]['about'] != ''
                              ? AppText(data[0]['about'],
                                  color: secondaryTheme, fontSize: 14.px)
                              : AppText('I am using ChatApp..!!!',
                                  color: secondaryTheme, fontSize: 14.px),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.badge_outlined),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.px),
                    child: Column(
                      children: [
                        AppText(S.of(context).badges, color: primaryTheme),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 35.px),
                child: AppText(
                  S.of(context).yourProfileAndChanges,
                  fontSize: 13.px,
                  color: secondaryTheme,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  getAppBar(context) {
    return AppAppBar(
      title: AppText(
        S.of(context).profile,
        fontSize: 20.px,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
