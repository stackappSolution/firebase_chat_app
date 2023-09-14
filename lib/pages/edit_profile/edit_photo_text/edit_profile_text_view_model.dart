import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:signal/service/auth_service.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import '../../../app/app/utills/app_utills.dart';
import 'edit_profile_text.dart';

class EditProfileTextViewModel {
  static final users = FirebaseFirestore.instance.collection('users');
  EditProfileText? editProfileText;
  WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;
  EditProfileTextViewModel(this.editProfileText);

  TextEditingController textEditingController = TextEditingController();

// Update the user's profile picture
  updateProfilePicture(String imagePath) {
    uploadImages(File(imagePath)).then((value) {
      if (value != null) {
        updateUserPhotoUrl(value);
      } else {
        print('Error uploading image');
      }
    });
  }

  Future<void> updateUserPhotoUrl(String photoUrl) async {
    try {
      await users.doc(AuthService.auth.currentUser!.uid).update({
        'photoUrl': photoUrl,
      });
      print('Successfully updated user profile picture');
    } catch (e) {
      print('Error updating user profile picture: $e');
    }
  }

  static bool isLoading = true;
  static String imageURL = "";

  static Future<String?> uploadImages(File imageUrl) async {
    isLoading = true;

    logs("isLoading-----$isLoading");
    final storage = FirebaseStorage.instance
        .ref('NewProfile')
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('sentImage.jpg');
    try {
      await storage.putFile(imageUrl);
      isLoading = false;

      logs("isLoading-----$isLoading");
      Get.back();
      return await storage.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      isLoading = false;

      return null;
    }
  }
  Color? backGroud = const Color(0xFFFFD1AB);
  List<Color> chatColors = [
    const Color(0xFFFFD1AB),
    const Color(0xFFFFB0B0),
    const Color(0xFFAFD0FF),
    const Color(0xFFF3B3FF),
    const Color(0xFF97C1FF),
    const Color(0xFFFFE1AA),
    const Color(0xFFAAFFF5),
    const Color(0xFFFFC0CB),
    const Color(0xFFB4EDFF),
    const Color(0xFFE6E6FA),
    const Color(0xFFFFDAB9),
    const Color(0xFFFFBBBB),
    const Color(0xFFFFF0F5),
    const Color(0xFFA7FFDE),
  ];
}

