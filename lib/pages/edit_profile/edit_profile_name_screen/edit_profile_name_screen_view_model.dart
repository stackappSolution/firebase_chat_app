import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/validation.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_screen.dart';

class EditProfileNameScreenViewModel {
  EditProfileNameScreen ? editProfileNameScreen;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String errorFirstName = "";
  bool isButtonActive = false;
  bool isLoading = false;

  EditProfileNameScreenViewModel(this.editProfileNameScreen) ;
  onChangedValue(value, GetxController controller, BuildContext context) {
    if (ValidationUtil.validateName(value)) {
      isButtonActive = true;
      errorFirstName = "";

      controller.update();
      logs("on change  ${ValidationUtil.validateName(value)}");
    } else {
      isButtonActive = false;
      errorFirstName = S.of(context).enterValidName;

      controller.update();
    }
  }
}
