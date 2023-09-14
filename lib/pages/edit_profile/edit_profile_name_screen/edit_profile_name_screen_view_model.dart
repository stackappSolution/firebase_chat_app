import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/validation.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_controller.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_screen.dart';
import 'package:signal/service/auth_service.dart';

import '../../settings/settings_screen.dart';

class EditProfileNameScreenViewModel {
  final users = FirebaseFirestore.instance.collection('users');
  bool isLoading = false;
  EditProfileNameScreen? editProfileNameScreen;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String errorFirstName = "";
  EditProfileNameController ?editProfileNameController;
  EditProfileNameScreenViewModel(this.editProfileNameScreen) {
    Future.delayed(
      const Duration(milliseconds: 100),
          () {
            editProfileNameController = Get.find<EditProfileNameController>();
      },
    );
  }
  onChangedValue(value, GetxController controller, BuildContext context) {
    if (ValidationUtil.validateName(value)) {
      errorFirstName = "";

      controller.update();
      logs("on change  ${ValidationUtil.validateName(value)}");
    } else {
      errorFirstName = S.of(context).enterValidName;
      controller.update();
    }
  }

  Future<void> updateUserName(
    String firstName,
    String? lastName,
  ) async {
    try {
      isLoading = true;
      editProfileNameController!.update();
      await users.doc(AuthService.auth.currentUser!.uid).update({
        'firstName': firstName,
        'lastName': lastName!,
      });
      logs('Successfully updated user profile picture');
      Get.to(SettingScreen());
      isLoading = false;
      editProfileNameController!.update();
    } catch (e) {
      logs('Error updating user profile picture: $e');
      isLoading = false;
      editProfileNameController!.update();

    }


  }
}
