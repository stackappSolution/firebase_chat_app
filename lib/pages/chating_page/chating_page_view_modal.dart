import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:get/get.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/routes/app_navigation.dart';
import '../../app/app/utills/app_utills.dart';
import '../../app/widget/app_image_assets.dart';
import '../../constant/app_asset.dart';
import '../../constant/string_constant.dart';
import '../../generated/l10n.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';

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
  File? selectedAudio;
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

  Future<void> pickImageGallery(GetxController controller, members) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      goToAttachmentScreen(selectedImage!.path,members);
      // uploadImage(selectedImage!);
      logs(selectedImage.toString());
      controller.update();
    }
  }

  Future<void> pickImageCamera(GetxController controller, members) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      goToAttachmentScreen(selectedImage!.path,members);
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

  buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(-10, kToolbarHeight),
      onSelected: (value) {
        if (value == 0) {
          buildImagePickerMenu(context);
        }
      },
      elevation: 0.5,
      position: PopupMenuPosition.over,
      color: AppColorConstant.appLightGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.px)),
      icon: AppButton(
          width: 27.px,
          height: 27.px,
          color: Colors.transparent,
          stringChild: true,
          borderRadius: BorderRadius.circular(27.px),
          child: Icon(Icons.attach_file,
              size: 27.px, color: AppColorConstant.offBlack)),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              value: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.px,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.px),
                    child: AppText(S.of(Get.context!).photo),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.px),
                    child: Divider(
                      height: 1.px,
                      color: AppColorConstant.appGrey.withOpacity(0.3),
                    ),
                  )
                ],
              )),
          PopupMenuItem(
              value: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(onTap: () {
                    getPermission(context,controller!);
                    Get.back();
                  },child: AppText(S.of(Get.context!).audio)),
                  Padding(
                    padding: EdgeInsets.only(top: 5.px),
                    child: Divider(
                      height: 1.px,
                      color: AppColorConstant.appGrey.withOpacity(0.3),
                    ),
                  )
                ],
              )),
          PopupMenuItem(
              value: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(S.of(Get.context!).video),
                  Padding(
                    padding: EdgeInsets.only(top: 10.px),
                    child: Divider(
                      height: 1.px,
                      color: AppColorConstant.appGrey.withOpacity(0.3),
                    ),
                  )
                ],
              )),
          PopupMenuItem(
              value: 3,
              child: Column(
                children: [
                  AppText(S.of(Get.context!).documents),
                  SizedBox(
                    height: 20.px,
                  )
                ],
              )),
        ];
      },
    );
  }

  Future<void> getPermission(
      BuildContext context, GetxController controller) async {
    await Permission.audio.request();
    await Permission.storage.request();
    logs(
        "permissionStorage ---- >${await Permission.audio.status.isGranted}");
    logs("permissionCamera ---- >${await Permission.camera.status.isGranted}");
    if (await Permission.audio.status.isGranted ||
        await Permission.storage.status.isGranted) {
      pickMp3File(controller);
    } else {
      await Permission.storage.request();
      await Permission.audio.request();
    }
  }


  buildImagePickerMenu(BuildContext context) {
    showMenu(
      color: AppColorConstant.appLightGrey,
      elevation: 0.3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.px)),
      context: context,
      position: RelativeRect.fromLTRB(
          20, Device.height * 0.7, Device.height * 0.7, 20),
      items: <PopupMenuEntry>[
        PopupMenuItem(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.px,
            ),
            Padding(
              padding: EdgeInsets.only(right: 20, top: 5.px),
              child: AppText(
                S.of(Get.context!).select,
                fontWeight: FontWeight.w800,
                fontSize: 18.px,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.px),
              child: Divider(
                height: 1.px,
                color: AppColorConstant.appGrey.withOpacity(0.3),
              ),
            )
          ],
        )),
        PopupMenuItem(
            onTap: () {
              pickImageGallery(controller!,arguments['members']);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20.px),
                  child: AppText(S.of(Get.context!).gallery),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.px),
                  child: Divider(
                    height: 1.px,
                    color: AppColorConstant.appGrey.withOpacity(0.3),
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              pickImageCamera(controller!,arguments['members']);
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20.px),
                  child: AppText(S.of(Get.context!).camera),
                ),
                SizedBox(
                  height: 20.px,
                )
              ],
            )),
      ],
    );
  }

  buildNavigationMenu(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 2) {
        }
      },
      elevation: 0.5,
      position: PopupMenuPosition.under,
      color: AppColorConstant.appLightGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.px)),
      icon: Padding(
        padding: EdgeInsets.all(10.px),
        child: AppImageAsset(
          image: AppAsset.popup,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              value: 0,
              child: Row(children: [ AppText("S.of(Get.context!).addContact"),Icon(Icons.add)],)
          ),
          PopupMenuItem(
              value: 1, child: Row(
            children: [
              AppText("S.of(Get.context!).viewContact"),
              const Icon(Icons.remove_red_eye),
            ],
          )),
          PopupMenuItem(value: 2, child: Row(
            children: [
              AppText("S.of(Get.context!).files"),
              const Icon(Icons.file_copy_sharp),
            ],
          )),
          PopupMenuItem(
              value: 3, child: Row(
            children: [
              AppText(S.of(Get.context!).block),
              const Icon(Icons.block),
            ],
          )),
        ];
      },
    );
  }

  Future<void> pickMp3File(GetxController controller) async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.path != null) {
        selectedAudio = File(file.path!);
      } else {
        logs("Audio Selection Empty");
      }
      onSendAudio(DatabaseService.audioURL,"audio",controller);
      controller.update();
      logs('Selected MP3 file: ${file.name}');
    } else {
      logs('User canceled file picking');
    }
  }

  onSendAudio(message, msgType,  controller) async {
      await DatabaseService.uploadAudio(selectedAudio!,controller);
      logs("message-----$message");
      DatabaseService().addNewMessage(
          type: msgType,
          members: arguments['members'],
          massage: message,
          sender: AuthService.auth.currentUser!.phoneNumber!,
          isGroup: false);

      controller!.update();

  }
}
