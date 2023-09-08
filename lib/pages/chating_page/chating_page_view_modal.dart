import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:get/get.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/routes/app_navigation.dart';
import '../../app/app/utills/app_utills.dart';
import '../../app/widget/app_alert_dialog.dart';
import '../../app/widget/app_image_assets.dart';
import '../../app/widget/app_text.dart';
import '../../constant/app_asset.dart';
import '../../constant/string_constant.dart';
import '../../generated/l10n.dart';
import '../../service/auth_service.dart';

class ChatingPageViewModal {
  ChatingPage? chatingPage;

  Color? chatBubbleColor;
  Color? wallpaperColor;
  List<dynamic> blockedNumbers = [];
  Map<String, dynamic> parameter = {};
  Map<String, dynamic> arguments = {};
  String? wallpaperPath;
  String? blockedBy;
  bool isGroup = false;
  String? formatedTime;
  bool isBlocked = false;
  File? selectedImage;
  String? userProfile;
  bool isLoading = false;

  List<String> chats = [];
  TextEditingController chatController = TextEditingController();

  ChatingPageController? controller;

  ChatingPageViewModal([this.chatingPage]) {
    Future.delayed(const Duration(milliseconds: 0), () async {
      controller = Get.find<ChatingPageController>();
      ChatingPage.fontSize = await getStringValue(StringConstant.setFontSize);
      controller!.update();
    });
  }

  Future<String?> fontSizeInitState() async {
    ChatingPage.fontSize = await getStringValue(StringConstant.setFontSize);
    logs(
        'getStringValue(StringConstant.selectedFontSize) : ${ChatingPage.fontSize}');
    return ChatingPage.fontSize;
  }

  List<PopupMenuEntry<String>> popupMenu = [
    const PopupMenuItem<String>(value: '/appearance', child: Text('Option 1')),
    const PopupMenuItem<String>(value: '/intro', child: Text('Option 2')),
    const PopupMenuItem<String>(value: '/SignInPage', child: Text('Option 3'))
  ];

  bool iconChange = false;

  Future<Color> getWallpaperColor() async {
    final colorCode = await getStringValue(wallPaperColor);
    if (colorCode != null) {
      return Color(int.parse(colorCode, radix: 16));
    } else {
      return Colors.white;
    }
  }

  Future<Color> getChatBubbleColor() async {
    final colorCode = await getStringValue(chatColor);
    if (colorCode != null) {
      return Color(int.parse(colorCode, radix: 16));
    } else {
      return AppColorConstant.appYellow;
    }
  }

  attachment(controller, context) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AppAlertDialog(
                  backgroundColor: AppColorConstant.blackOff,
                  title: AppText(S.of(context).choose,
                      color: AppColorConstant.appWhite,
                      fontWeight: FontWeight.bold),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 80.px, top: 20.px, bottom: 10.px, right: 10.px),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: AppText(
                          S.of(context).cancel,
                          color: AppColorConstant.appYellow,
                          fontSize: 15.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                  insetPadding: EdgeInsets.zero,
                  widget: SizedBox(
                    height: 100.px,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  pickImageCamera(controller);
                                  Navigator.pop(context);
                                },
                                child: AppImageAsset(
                                    height: 60.px,
                                    color: AppColorConstant.appWhite,
                                    image: AppAsset.newCamera)),
                            Padding(
                              padding: EdgeInsets.only(top: 9.px),
                              child: AppText(
                                S.of(context).camera,
                                fontSize: 15.px,
                                color: AppColorConstant.appWhite,
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  pickImageGallery(controller);
                                  Get.back();
                                },
                                child: AppImageAsset(
                                    height: 60.px,
                                    color: AppColorConstant.appWhite,
                                    image: AppAsset.gallery)),
                            Padding(
                              padding: EdgeInsets.only(top: 9.px),
                              child: AppText(
                                S.of(context).gallery,
                                fontSize: 15,
                                color: AppColorConstant.appWhite,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
        icon: const Icon(Icons.attach_file, color: Colors.black));
  }

  Future<void> pickImageGallery(GetxController controller) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      goToAttachmentScreen(selectedImage!.path);
     // uploadImage(selectedImage!);
      logs(selectedImage.toString());
      controller.update();
    }
  }

  Future<void> pickImageCamera(GetxController controller) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      goToAttachmentScreen(selectedImage!.path);
      // uploadImage(selectedImage!);
      logs(selectedImage.toString());
      controller.update();
    }
  }

  uploadImage(File imageUrl) async {
    isLoading = true;
    logs("load--> $isLoading");
    controller!.update();
    final storage = FirebaseStorage.instance
        .ref('profile')
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('profile.jpg');
    await storage.putFile(imageUrl);
    userProfile = await storage.getDownloadURL();
    logs("profile........ $userProfile");
    isLoading = false;
    logs("load--> $isLoading");
    controller!.update();
  }
}
