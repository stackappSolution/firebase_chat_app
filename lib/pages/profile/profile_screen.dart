import 'dart:io';

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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 17.px, right: 17.px),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(top: 50.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(StringConstant.yourProfile,
                    fontSize: 40.px, fontWeight: FontWeight.bold),
                Padding(
                  padding: EdgeInsets.only(top: 20.px),
                  child: AppText(StringConstant.profileAreVisible,
                      fontSize: 15.px,
                      color: AppColorConstant.appBlack.withOpacity(0.5)),
                ),
              ],
            ),
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
                  Container(
                    alignment: Alignment.center,
                    width: 150.px,
                    height: 180.px,
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 110.px,
                          decoration: BoxDecoration(
                              color: AppColorConstant.appBlack.withOpacity(0.2),
                              shape: BoxShape.circle),
                          child: InkWell(
                              onTap: () {
                                profileViewModel!
                                    .profilePicTap(context, controller);
                              },
                              child: (profileViewModel!.selectedImage != null)
                                  ? CircleAvatar(
                                      radius: 55,
                                      backgroundImage: FileImage(File(
                                          profileViewModel!
                                              .selectedImage!.path)),
                                    )
                                  : AppImageAsset(
                                      height: 50.px, image: AppAsset.profile)),
                        ),
                        Positioned(
                            top: 80.px,
                            left: 95.px,
                            child: Container(
                                alignment: Alignment.center,
                                height: 27.px,
                                padding: EdgeInsets.all(5.px),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColorConstant.appBlack,
                                    border: Border.all(color:AppColorConstant.appWhite)),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColorConstant.appWhite,
                                  size: 13,
                                )))
                      ],
                    ),
                  ),
                  AppTextFormField(
                    controller: profileViewModel!.firstNameController,
                    labelText: StringConstant.firstName,
                    onChanged: (value) {
                      profileViewModel!.onChangedValue(value, controller);
                    },
 
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
                    padding: EdgeInsets.only(top: 5.px),
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
                              profileViewModel!.onTapNext(context);
                            }
                          : null,
                    ),
                  )
                ]),
          ),
          Container(
            alignment: Alignment.center,
            width: 150.px,
            height: 180.px,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 110.px,
                  decoration: BoxDecoration(
                      color: AppColorConstant.appBlack.withOpacity(0.2),
                      border: Border.all(
                          color: AppColorConstant.appWhite, width: 4.px),
                      shape: BoxShape.circle),
                  child: InkWell(
                      onTap: () {
                        profileViewModel!.profilePicTap(context, controller);
                      },
                      child: (profileViewModel!.selectedImage != null)
                          ? CircleAvatar(
                              radius: 55,
                              backgroundImage: FileImage(
                                  File(profileViewModel!.selectedImage!.path)),
                            )
                          : AppImageAsset(
                              height: 50.px, image: AppAsset.profile)),
                ),
                Positioned(
                    top: 80.px,
                    left: 95.px,
                    child: Container(
                        alignment: Alignment.center,
                        height: 27.px,
                        padding: EdgeInsets.all(5.px),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorConstant.appBlack,
                            border: Border.all(
                                color: AppColorConstant.appWhite, width: 2.px)),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColorConstant.appWhite,
                          size: 13,
                        )))
              ],
            ),
          ),
          AppTextFormField(
            controller: profileViewModel!.firstNameController,
            labelText: StringConstant.firstName,
            onChanged: (value) {
              profileViewModel!.onChangedValue(value, controller);
            },
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 5.px,top: 5.px),
                child: AppText(
                  profileViewModel!.errorFirstName,
                  color: AppColorConstant.red,
                  fontSize: 10.px,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 5.px),
            child: AppTextFormField(
              controller: profileViewModel!.lastNameController,
              labelText: StringConstant.lastName,
              fontSize: null,
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
                      profileViewModel!.onTapNext(context);
                    }
                  : null,
            ),
          )
        ]),
      ),
    );
  }
}
