import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:signal/controller/edit_profile_controller.dart';
import 'package:signal/pages/edit_profile/add_photo_screen.dart';
import 'package:signal/pages/edit_profile/edit_profile_about_screen/edit_profile_about_screen.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_screen.dart';

import 'edit_profile_screen.dart';

class EditProfileViewModel {
  EditProfileScreen? editProfileScreen;
  EditProfileController? editProfileController;

  EditProfileViewModel(this.editProfileScreen);

  void editPhotoTap() {
    Get.to(AddPhotoScreen());
  }

  void profileNameTap(BuildContext context) {
    Get.to(EditProfileNameScreen());
  }

  void aboutTap(BuildContext context) {
    Get.to(EditProfileAboutScreen());
  }
}
