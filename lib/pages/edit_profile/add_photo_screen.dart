import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/edit_profile/add_photo_controller.dart';

import 'package:signal/pages/edit_profile/add_photo_view_model.dart';
import 'package:signal/pages/edit_profile/edit_photo_text/edit_profile_text.dart';
import 'package:signal/pages/settings/settings_screen.dart';
import 'package:signal/service/users_service.dart';

// ignore: must_be_immutable
class AddPhotoScreen extends StatelessWidget {
  AddPhotoViewModel? addPhotoViewModel;

  AddPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    addPhotoViewModel ?? (addPhotoViewModel = AddPhotoViewModel(this));

    return GetBuilder<AddPhotoController>(
      init: AddPhotoController(),
      builder: (AddPhotoController controller) {
        return SafeArea(
          child: Scaffold(
            appBar: getAppBar(),
            body: Padding(
              padding: EdgeInsets.all(15.px),
              child: getBody(controller),
            ),
          ),
        );
      },
    );
  }

  getBody(AddPhotoController controller) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.px, bottom: 15.px),
              child: StreamBuilder(
                stream: UsersService.getUserStream(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const AppText('');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const AppLoader();
                  }
                  final data = snapshot.data!.docs;
                  return data[0]['photoUrl'].isEmpty
                      ? CircleAvatar(
                          maxRadius: 70.px,
                          backgroundColor:
                              AppColorConstant.appYellow.withOpacity(0.2),
                          child: AppText(
                              data[0]['firstName']
                                  .substring(0, 1)
                                  .toString()
                                  .toUpperCase(),
                              fontSize: 60.px,
                              color: AppColorConstant.appBlack),
                        )
                      : Stack(
                          children: [
                            addPhotoViewModel?.selectedImage == null
                                ? CircleAvatar(
                                    maxRadius: 70,
                                    backgroundImage: NetworkImage(
                                      data[0]['photoUrl'],
                                    ),
                                  )
                                : CircleAvatar(
                                    maxRadius: 70,
                                    backgroundImage: FileImage(File(
                                      addPhotoViewModel!.selectedImage!.path,
                                    )),
                                  ),
                            data[0]['photoUrl'].isNotEmpty
                                ? Positioned(
                                    right: 5.px,
                                    top: 10.px,
                                    child: InkWell(
                                      onTap: () {
                                        addPhotoViewModel!.deleteUserPhoto();
                                        Get.to(SettingScreen());
                                      },
                                      child: Container(
                                        width: 25.px,
                                        height: 25.px,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.px),
                                            color: AppColorConstant.appGrey),
                                        child: const Icon(
                                          Icons.close,
                                          color: AppColorConstant.appWhite,
                                        ),
                                      ),
                                    ),
                                  )
                                : const Text(''),
                          ],
                        );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 10.px,
                ),
                InkWell(
                  onTap: () {
                    addPhotoViewModel!.pickImage(controller,ImageSource.camera);

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
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 28.px,
                          color: AppColorConstant.appWhite,
                        ),
                      ),
                      const AppText('Camera')
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    addPhotoViewModel!.pickImage(controller,ImageSource.gallery);
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
                        child: Icon(
                          Icons.photo_camera_back_outlined,
                          size: 28.px,
                          color: AppColorConstant.appWhite,
                        ),
                      ),
                      const AppText('Photo')
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
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
                      const AppText('Text')
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.px,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.px, right: 10.px),
              child: const Divider(
                color: AppColorConstant.offBlack,
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: 12,
                padding: EdgeInsets.only(right: 10.px, left: 10.px),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10.px),
                    child: const CircleAvatar(
                      backgroundColor: Colors.black38,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: 20.px, bottom: 15.px, left: 20.px),
              child: AppElevatedButton(
                  onPressed: () {
                    addPhotoViewModel!.updateProfilePicture(
                        addPhotoViewModel!.selectedImage!.path);
                  },
                  buttonHeight: 45.px,
                  widget: AppText(
                    'Save',
                    color: AppColorConstant.appWhite,
                    fontSize: 22.px,
                  ),
                  isBorderShape: true,
                  buttonColor: AppColorConstant.appYellow),
            ),
          ],
        ),
        if (addPhotoViewModel!.isLoading) const AppLoader(),
      ],
    );
  }

  getAppBar() {
    return const AppAppBar();
  }
}
