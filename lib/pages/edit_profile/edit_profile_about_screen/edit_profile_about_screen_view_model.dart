import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/toast_util.dart';
import 'package:signal/controller/edit_profile_about_controller.dart';
import 'package:signal/pages/edit_profile/edit_profile_about_screen/edit_profile_about_screen.dart';
import 'package:signal/pages/edit_profile/edit_profile_screen.dart';
import 'package:signal/pages/profile/profile_screen.dart';
import 'package:signal/service/auth_service.dart';

class EditProfileAboutScreenViewModel {
  EditProfileAboutScreen? editProfileAboutScreen;
  TextEditingController captionController = TextEditingController();
  EditProfileAboutController? controller;
  bool isLoading = false;
  final users = FirebaseFirestore.instance.collection("users");

  List<String> caption = [
    '👋 Speak freely',
    '🤐 Encrypted',
    '🙏 Be kind',
    '☕ Coffee lover',
    '👍 Free to chat',
    '🔞 Taking a break',
    '🚀 Working on something new',
  ];

  EditProfileAboutScreenViewModel(this.editProfileAboutScreen) {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        controller = Get.find<EditProfileAboutController>();
      },
    );
  }

  Future<void> updateAbout() async {
    isLoading = true;
    controller!.update();
    try {
      await users.doc(AuthService.auth.currentUser!.uid).update({
        'about': captionController.text,
      });
      logs('Successfully updated user profile picture');
      isLoading = false;
      ToastUtil.successToast("Updated");
      Get.back;
      controller!.update();
    } catch (e) {
      logs('Error updating user profile picture: $e');
      isLoading = false;
      controller!.update();
    }
  }
}
