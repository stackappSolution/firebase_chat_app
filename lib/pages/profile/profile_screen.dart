import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/profile_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/profile/profile_view_model.dart';
import 'package:signal/service/auth_service.dart';
import '../../constant/app_asset.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileViewModel? profileViewModel;
  ProfileController? profileController;

  String pin;

  ProfileScreen(this.pin, {super.key});

  @override
  Widget build(BuildContext context) {
    profileViewModel ?? (profileViewModel = ProfileViewModel(this));
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      initState: (state) {
        profileViewModel!.parameter = Get.parameters;
        logs('profileStatus---> ${AuthService.auth.currentUser!.photoURL}');
      },
      builder: (GetxController controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: getBody(controller, context),
          ),
        );
      },
    );
  }

  getBody(GetxController controller, BuildContext context) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return Stack(
      children: [
        SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(left: 22.px, right: 22.px),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30.px),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(S.of(context).yourProfile,
                              color: primaryTheme,
                              fontSize: 35.px,
                              fontWeight: FontWeight.bold),
                          Padding(
                            padding: EdgeInsets.only(top: 20.px),
                            child: AppText(S.of(context).profileAreVisible,
                                color: secondaryTheme),
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
                                color:
                                    AppColorConstant.appBlack.withOpacity(0.2),
                                border: Border.all(
                                    width: 4.px,
                                    color: AppColorConstant.appWhite),
                                shape: BoxShape.circle),
                            child: (!profileViewModel!.isLoading)
                                ? (profileViewModel!.selectedImage != null)
                                    ? CircleAvatar(
                                        radius: 55,
                                        backgroundImage: FileImage(File(
                                            profileViewModel!
                                                .selectedImage!.path)),
                                      )
                                    : AppImageAsset(
                                        height: 50.px,
                                        image: AppAsset.profile,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                : const CircularProgressIndicator(
                                    color: AppColorConstant.appYellow,
                                  ),
                          ),
                          Positioned(
                              top: 78.px,
                              left: 93.px,
                              child: InkWell(
                                onTap: () {
                                  profileViewModel!
                                      .addProfileTap(context, controller);
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 27.px,
                                    padding: EdgeInsets.all(5.px),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColorConstant.appBlack,
                                        border: Border.all(
                                            color: AppColorConstant.appWhite,
                                            width: 2.px)),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColorConstant.appWhite,
                                      size: 13,
                                    )),
                              ))
                        ],
                      ),
                    ),
                    AppTextFormField(
                      controller: profileViewModel!.firstNameController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                      ],
                      labelText: S.of(context).firstName,
                      onChanged: (value) {
                        profileViewModel!
                            .onChangedValue(value, controller, context);
                      },
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 5.px,
                          ),
                          child: AppText(
                            profileViewModel!.errorFirstName,
                            color: AppColorConstant.red,
                            fontSize: 10.px,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.px,
                      ),
                      child: AppTextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),
                        ],
                        controller: profileViewModel!.lastNameController,
                        labelText: S.of(context).lastName,
                        fontSize: null,
                      ),
                    ),
                    SizedBox(
                      height: 160.px,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.px),
                      child: AppElevatedButton(
                        buttonHeight: 50.px,
                        widget: AppText(
                          S.of(context).next,
                          color: AppColorConstant.appWhite,
                          fontSize: 18.px,
                        ),
                        isBorderShape: true,
                        buttonColor: (profileViewModel!.isButtonActive &&
                                profileViewModel!.isLoading == false)
                            ? AppColorConstant.appYellow
                            : AppColorConstant.appYellow.withOpacity(0.5),
                        onPressed: (profileViewModel!.isButtonActive &&
                                profileViewModel!.isLoading == false)
                            ? () {
                                profileViewModel!.isLoadingOnSave = true;
                                controller.update();
                                profileViewModel!
                                    .onTapNext(context, controller,pin);
                              }
                            : null,
                      ),
                    )
                  ],
                ))),
        if (profileViewModel!.isLoadingOnSave)  AppLoader(),
      ],
    );
  }
}
