import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/validation.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_screen.dart';
import 'package:signal/service/auth_service.dart';

class EditProfileNameScreenViewModel {
  static final users = FirebaseFirestore.instance.collection('users');

  EditProfileNameScreen? editProfileNameScreen;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String errorFirstName = "";

  EditProfileNameScreenViewModel(this.editProfileNameScreen);

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
      await users.doc(AuthService.auth.currentUser!.uid).update({
        'firstName': firstName,
        'lastName': lastName!,
      });
      print('Successfully updated user profile picture');
    } catch (e) {
      print('Error updating user profile picture: $e');
    }
  }
}
