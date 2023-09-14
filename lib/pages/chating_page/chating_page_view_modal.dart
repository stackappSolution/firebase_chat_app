import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:get/get.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/users_service.dart';

import '../../app/widget/app_image_assets.dart';
import '../../constant/app_asset.dart';
import '../../constant/string_constant.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';

class ChatingPageViewModal {
  ChatingPage? chatingPage;

  Color? chatBubbleColor;
  Color? wallpaperColor;
  int? formattedDate;
  List<String> blockedNumbers = [];
  Map<String, dynamic> parameter = {};
  Map<String, dynamic> arguments = {};
  String? wallpaperPath;
  String? blockedBy;
  bool isGroup = false;
  dynamic snapshots;


  String? formatedTime;
  bool isBlocked = false;
  File? selectedImage;
  File? selectedVideo;
  File? audioFile;
  String? userProfile;
  bool isLoading = false;
  List<DateTime> messageTimeStamp = [];
  ScrollController scrollController = ScrollController();
  String? fontSize;
  List<String> chats = [];
  TextEditingController chatController = TextEditingController();

  ChatingPageController? controller;

  ChatingPageViewModal([this.chatingPage]) {
    Future.delayed(const Duration(milliseconds: 0), () async {
      controller = Get.find<ChatingPageController>();
      fontSize = await getStringValue(StringConstant.setFontSize);
      controller!.update();
    });
  }

  Future<String?> fontSizeInitState() async {
    fontSize = await getStringValue(StringConstant.setFontSize);
    logs('getStringValue(StringConstant.selectedFontSize) : $fontSize');
    return fontSize;
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

  audioSendTap() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.path != null) {
        audioFile = File(file.path!);
        onSendAudio("audio", controller);
      } else {}

      logs('Selected MP3 file: ${file.name}');
    } else {
      logs('User canceled file picking');
    }
  }

  videoSendTap() {
    pickVideoGallery(controller!, arguments['members']);
  }

  onSendAudio(String msgType, controller) async {
    DatabaseService.uploadAudio(File(audioFile!.path), controller)
        .then((value) {
      logs('message---> $value');
      DatabaseService().addNewMessage(
          type: msgType,
          members: arguments['members'],
          massage: value,
          sender: AuthService.auth.currentUser!.phoneNumber!,
          isGroup: false);
    });

    controller.update();
  }

  onSendVideo(String msgType, controller) async {
    DatabaseService.uploadAudio(File(audioFile!.path), controller)
        .then((value) {
      logs('message---> $value');
      DatabaseService().addNewMessage(
          type: msgType,
          members: arguments['members'],
          massage: value,
          sender: AuthService.auth.currentUser!.phoneNumber!,
          isGroup: false);
    });
    controller.update();
  }

  Future<void> pickImageGallery(GetxController controller, members) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      goToAttachmentScreen(selectedImage!.path, members);
      // uploadImage(selectedImage!);
      logs(selectedImage.toString());
      controller.update();
    }
  }

  Future<void> pickVideoGallery(GetxController controller, members) async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedVideo = (File(pickedFile.path));
      goToAttachmentScreen(selectedVideo, members);
      logs(selectedVideo.toString());
      controller.update();
    }
  }

  Future<void> pickImageCamera(GetxController controller, members) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      goToAttachmentScreen(selectedImage!.path, members);
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
                  InkWell(
                      onTap: () {
                        audioSendTap();
                        Get.back();
                      },
                      child: AppText(S.of(Get.context!).audio)),
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
                  InkWell(
                      onTap: () {
                        videoSendTap();
                        Get.back();
                      },
                      child: AppText(S.of(Get.context!).video)),
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
              pickImageGallery(controller!, arguments['members']);
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
              pickImageCamera(controller!, arguments['members']);
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
        onSelectItem(value);
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(S.of(Get.context!).addContact),
                  const Icon(Icons.add)
                ],
              )),
          PopupMenuItem(
              value: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(S.of(Get.context!).viewContact),
                  const Icon(Icons.remove_red_eye_outlined),
                ],
              )),
          PopupMenuItem(
              value: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(S.of(Get.context!).files),
                  const Icon(Icons.file_copy_outlined),
                ],
              )),
          PopupMenuItem(
              value: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(S.of(Get.context!).block),
                  const Icon(Icons.block),
                ],
              )),
        ];
      },
    );
  }

  onSelectItem(value) {
    if (value == 1) {
      Get.toNamed(RouteHelper.getChatProfileScreen(), arguments: {
        'name': arguments['name'],
        'number': arguments['number'],
        'id': arguments['id'],
        'isGroup': arguments['isGroup'],
        'members': arguments['members'],
      });
    }
    if (value == 3) {
      blockedNumbers.add(arguments['number']);
      UsersService().blockUser(blockedNumbers, arguments['number']);

      controller!.update();
    }
  }

  buildDoubleClickView() {
    return Container(alignment: Alignment.center,height: 15.px,width: 15.px,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(Get.context!).colorScheme.primary,
          )),
      child: Icon(Icons.done_all,color: Theme.of(Get.context!).colorScheme.primary,size: 12.px,),
    );
  }

  buildSingleClickView() {
    return Container(alignment: Alignment.center,height: 15.px,width: 15.px,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(Get.context!).colorScheme.primary
          )),
      child: Icon(Icons.done,color: Theme.of(Get.context!).colorScheme.primary,size: 12.px,),
    );
  }
}
