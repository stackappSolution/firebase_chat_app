import 'package:flutter/material.dart';
import 'package:signal/pages/edit_profile/edit_photo_text/edit_profile_text_controller.dart';
import 'package:signal/pages/edit_profile/edit_photo_text/edit_profile_text_text.dart';



class EditProfileTextViewModel {
  EditProfileTextText? editProfileTextText;
  EditProfileTextController? editProfileTextController;

  EditProfileTextViewModel(this.editProfileTextText);
TextEditingController textEditingController = TextEditingController();
}
