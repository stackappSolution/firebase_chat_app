import 'package:flutter/material.dart';
import 'package:signal/pages/edit_profile/edit_profile_about_screen/edit_profile_about_screen.dart';

class EditProfileAboutScreenViewModel
{
  EditProfileAboutScreen ?editProfileAboutScreen;
  TextEditingController captionController = TextEditingController();
List<String> icon = ['👋','🤐','🙏','☕','👍','🔞','🚀'];
List<String> caption = [
  'Speak freely',
  'Encrypted',
  'Be kind',
  'Coffee lover',
  'Free to chat',
  'Taking a break',
  'Working on something new',
  ];
  EditProfileAboutScreenViewModel(this.editProfileAboutScreen) ;

}