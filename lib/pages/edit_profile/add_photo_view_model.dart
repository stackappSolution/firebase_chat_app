import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/pages/edit_profile/add_photo_controller.dart';
import 'package:signal/pages/edit_profile/add_photo_screen.dart';
import 'package:signal/service/auth_service.dart';

class AddPhotoViewModel {
  final users = FirebaseFirestore.instance.collection("users");

  AddPhotoScreen? addPhotoScreen;

  AddPhotoController? controller;
  bool isLoading = false;
  File? selectedImage;
  String? userProfile;

  AddPhotoViewModel(this.addPhotoScreen) {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        controller = Get.find<AddPhotoController>();
      },
    );
  }

  updateProfilePicture(String imagePath) {
    isLoading = true;
    controller!.update();
    uploadImagesStorage(File(imagePath)).then((value) {
      if (value != null) {
        updateUserPhotoUrl(value);
        isLoading = false;
        controller!.update();
      } else {
        logs('Error uploading image');
        isLoading = false;
        controller!.update();
      }
    });
  }

  Future<void> updateUserPhotoUrl(String photoUrl) async {
    logs("updateUserPhotoUrl Entred");
    isLoading = true;
    controller!.update();
    try {
      await users.doc(AuthService.auth.currentUser!.uid).update({
        'photoUrl': photoUrl,
      });
      logs('Successfully updated user profile picture');
      isLoading = false;
      controller!.update();
    } catch (e) {
      logs('Error updating user profile picture: $e');
      isLoading = false;
      controller!.update();
    }
  }

  Future<void> pickImage(GetxController controller, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
     // uploadImageStorage(File(selectedImage!.path));
      logs('selectedImage ${selectedImage.toString()}');
    }
  }

  Future<void> deleteUserPhoto() async {
    isLoading = true;
    controller!.update();
    try {
      await users.doc(AuthService.auth.currentUser!.uid).update({
        'photoUrl': "",
      });
      logs('Successfully deleted user profile picture');
      isLoading = false;
      controller!.update();
    } catch (e) {
      logs('Error deleting user profile picture: $e');
      isLoading = false;
      controller!.update();
    }
  }

  Future<String?> uploadImagesStorage(File imageUrl) async {
    isLoading = true;
    controller!.update();
    logs("isLoading-----$isLoading");
    final storage = FirebaseStorage.instance
        .ref('NewProfile')
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('sentImage.jpg');
    try {
      await storage.putFile(imageUrl);
      isLoading = false;
      controller!.update();
      logs("isLoading-----$isLoading");
      Get.back();
      return await storage.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      isLoading = false;
      controller!.update();
      return null;
    }
  }

  Future<String> uploadImageStorage(File imageUrl) async {
    isLoading = true;
    controller!.update();
    logs("load--> $isLoading");
    final storage = FirebaseStorage.instance
        .ref('profile')
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('profile.jpg');
    await storage.putFile(imageUrl);
    userProfile = await storage.getDownloadURL();
    logs("profile====> $userProfile");
    isLoading = false;
    updateUserPhotoUrl(await storage.getDownloadURL());
    controller!.update();
    logs("load--> $isLoading");
    return await storage.getDownloadURL();
  }
}
