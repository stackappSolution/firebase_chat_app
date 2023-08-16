import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/profile_controller.dart';
import 'package:signal/pages/profile/profile_view_model.dart';

import '../../constant/app_asset.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileViewModel? profileViewModel;
  ProfileController? profileController;

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    profileViewModel ?? (profileViewModel = ProfileViewModel(this));

    return GetBuilder<ProfileController>(
      init: ProfileController(),
      initState: (state) {},
      builder: (GetxController controller) {
        return SafeArea(
          child: Scaffold(
            body: getBody(controller, context),
          ),
        );
      },
    );
  }

  getBody(GetxController controller, BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
            height: double.infinity,
            width: double.infinity,
            child:
                AppImageAsset(image: AppAsset.background, fit: BoxFit.cover)),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 12.px, right: 12.px),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(StringConstant.yourProfile,
                            fontSize: 40.px, fontWeight: FontWeight.bold),
                        Padding(
                          padding: EdgeInsets.only(top: 5.px),
                          child: AppText(StringConstant.profileAreVisible,
                              fontSize: 15.px,
                              color:
                                  AppColorConstant.appBlack.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      profileViewModel!.profilePicTap(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 30.px, bottom: 30.px),
                      alignment: Alignment.center,
                      height: 120.px,
                      decoration: BoxDecoration(
                          color: AppColorConstant.appBlack.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child:
                          AppImageAsset(height: 60.px, image: AppAsset.profile),
                    ),
                  ),
                  AppTextFormField(
                    controller:
                        profileViewModel!.firstNameController,
                    labelText: StringConstant.firstName,
                    onChanged: (value) {
                      profileViewModel!.onChangedValue(value, controller);
                    }, fontSize: null,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.px),
                        child: AppText(
                          profileViewModel!.errorFirstName,
                          color: AppColorConstant.red,
                          fontSize: 10.px,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 10.px),
                    child: AppTextFormField(
                      controller:
                          profileViewModel!.lastNameController,
                      labelText: StringConstant.lastName, fontSize: null,
                    ),
                  ),
                  SizedBox(
                    height: 120.px,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.px),
                    child: AppElevatedButton(
                      buttonHeight: 50.px,
                      widget: AppText(
                        StringConstant.next,
                        color: AppColorConstant.appWhite,
                        fontSize: 20.px,
                      ),
                      isBorderShape: true,
                      buttonColor: (profileViewModel!.isButtonActive)
                          ? AppColorConstant.appTheme
                          : AppColorConstant.appTheme.withOpacity(0.5),
                      onPressed: (profileViewModel!.isButtonActive)
                          ? () {
                              profileViewModel!.onChangedValue(
                                  profileViewModel!.firstNameController,
                                  controller);
                            }
                          : null,
                    ),
                  )
                ]),
          ),
        ),
      ],
    );
  }
}
