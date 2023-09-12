import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/add_photo_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/edit_profile/add_photo_view_model.dart';
import 'package:signal/pages/edit_profile/edit_photo_text/edit_profile_text.dart';
import 'package:signal/pages/edit_profile/edit_profile_screen.dart';

// ignore: must_be_immutable
class AddPhotoScreen extends StatelessWidget {
  AddPhotoViewModel? addPhotoViewModel;

  AddPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    addPhotoViewModel ?? (addPhotoViewModel = AddPhotoViewModel(this));

    return GetBuilder<AddPhotoController>(
      init: AddPhotoController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            appBar: getAppBar(),
            body: getBody(),
            floatingActionButton: getFloatingActionButton(),
          ),
        );
      },
    );
  }

  Column getBody() {
    return Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 15.px, bottom: 15.px),
              child: const CircleAvatar(
                radius: 70,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 10.px,
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.px),
                        color: AppColorConstant.iconOrange,
                      ),
                      alignment: Alignment.center,
                      height: 50.px,
                      width: 50.px,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 28,
                        color: AppColorConstant.appWhite,
                      ),
                    ),
                    AppText('Camera')
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.px),
                        color: AppColorConstant.iconOrange,
                      ),
                      alignment: Alignment.center,
                      height: 50.px,
                      width: 50.px,
                      child: Icon(
                        Icons.photo_camera_back_outlined,
                        size: 28,
                        color: AppColorConstant.appWhite,
                      ),
                    ),
                    AppText('Photo')
                  ],
                ),
                InkWell(onTap: () {
                  Get.to(EditProfileText());
                },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.px),
                          color: AppColorConstant.iconOrange,
                        ),
                        alignment: Alignment.center,
                        height: 50.px,
                        width: 50.px,
                        child: AppText(
                          'Aa',
                          fontSize: 20.px,
                          color: AppColorConstant.appWhite,
                        ),
                      ),
                      AppText('Text')
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.px,
                ),
              ],
            ),
            Divider(
              color: AppColorConstant.offBlack,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: 12,
                padding: EdgeInsets.only(right: 10.px, left: 10.px),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10.px),
                    child: CircleAvatar(
                      backgroundColor: Colors.black38,
                    ),
                  );
                },
              ),
            )
          ]);
  }

  AppAppBar getAppBar() {
    return AppAppBar(
            leading:
                IconButton(onPressed: () {
                  Get.to(EditProfileScreen());
                }, icon: const Icon(Icons.close)),
          );
  }

  AppElevatedButton getFloatingActionButton() {
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
}
