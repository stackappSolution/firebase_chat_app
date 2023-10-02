import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:http/http.dart' as http;
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../app/app/utills/toast_util.dart';
import '../../app/widget/app_image_assets.dart';
import '../../constant/app_asset.dart';
import '../../constant/string_constant.dart';
import '../../modal/send_message_model.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';

class ChatingPageViewModal {
  ChatingPage? chatingPage;
  Stream<QuerySnapshot>? getChatsStream;

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
  String? fileSizes;
  List<String> chats = [];
  File? selectedFile;

  List<bool> isFileDownLoadingList = <bool>[];
  List isFileDownLoadedList = [];
  List downloadedVideoList = [];

  TextEditingController chatController = TextEditingController();
  ChatingPageController? controller;

  ChatingPageViewModal([this.chatingPage]) {
    Future.delayed(const Duration(milliseconds: 0), () async {
      controller = Get.find<ChatingPageController>();
      fontSize = await getStringValue(StringConstant.setFontSize);
      controller!.update();
    });
  }

  Future fileSize(controller, path) async {
    int fileSizeInBytes = await File(path).length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    double fileSizeInKB = fileSizeInBytes / 1024;

    if (fileSizeInMB >= 1.0) {
      fileSizes = '${fileSizeInMB.toStringAsFixed(2)} MB';
    } else {
      fileSizes = '${fileSizeInKB.toStringAsFixed(2)} KB';
    }

    logs(fileSizes!);
    controller.update();
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

  //========================= docs =============================//

  Future<void> pickDocument(ChatingPageController controller) async {
    logs("on Doc Pic");
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    logs("file ---->  ${result.toString()}");

    if (result != null) {
      logs("selected files ---- > ${selectedFile.toString()}");
      selectedFile = File(result.files.single.path!);
      if (result.files.single.path!.contains(".mp3") ||
          result.files.single.path!.contains(".mp4") ||
          result.files.single.path!.contains(".jpg") ||
          result.files.single.path!.contains(".png")) {
        ToastUtil.successToast("Select valid file:  'Pdf','doc','docx'");
      } else {
        String extension = "";
        if (result.files.single.name.contains(".pdf")) {
          extension = "pdf";
          controller.update();
        }

        if (result.files.single.name.contains(".doc")) {
          extension = "doc";
          controller.update();
        }

        if (result.files.single.name.contains(".dotx")) {
          extension = "dotx";
          controller.update();
        }
        logs("file Extension ---  > $extension");
        goToAttachmentScreen(
            selectedImage: selectedFile!.path,
            members: arguments['members'],
            extension: extension);
      }
    } else {
      ToastUtil.messageToast("File not Selected");
    }
  }

  Future<String> downloadAndSavePDF(String pdfURL, folderName,
      ChatingPageController controller, int index) async {
    isFileDownLoadingList[index] = true;
    controller.update();
    logs("isFileDownLoadingList[index]---> ${isFileDownLoadingList[index]}");

    List splitUrl = pdfURL.split("/");
    final response = await http.get(Uri.parse(pdfURL));
    String? fileName;
    var dirPath =
        "${await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)}/CHATAPP/$folderName";

    Directory dir = Directory(dirPath);
    if (!await dir.exists()) {
      dir.create();
    }
    fileName =
        "myFile${splitUrl.last.toString().substring(splitUrl.last.toString().length - 10, splitUrl.last.toString().length)}.${extensionCheck(pdfURL)}";
    File file = File("${dir.path}/$fileName");

    await file.writeAsBytes(response.bodyBytes);
    logs("saved file path --->  ${file.path}");

    isFileDownLoadingList[index] = false;
    isFileDownLoadedList[index] = true;
    controller.update();
    logs("isFileDownLoadingList[index]---> ${isFileDownLoadingList[index]}");
    logs("downloaded path --- > $fileName");

    return file.path;
  }

  Future<void> viewFile(
      mainURL, folderName, ChatingPageController controller, int index) async {
    logs(" View FIle Entred");
    final PermissionStatus permissionStatus =
        await Permission.manageExternalStorage.status;
    if (!permissionStatus.isGranted) {
      getPermission();
    } else {
      logs("downloadAndOpenPDF Entered");
      downloadAndSavePDF(mainURL, folderName, controller, index);

      var dirPath =
          "${await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)}/CHATAPP/$folderName";
      Directory dir = Directory(dirPath);
      List splitUrl = mainURL.split("/");

      final filePath =
          '${dir.path}/myFile${splitUrl.last.toString().substring(splitUrl.last.toString().length - 10, splitUrl.last.toString().length)}.${extensionCheck(mainURL)}';

      logs("ckeck file  --- > ${filePath}");

      if (await File(filePath).exists()) {
        isFileDownLoadedList[index] = true;
        controller.update();
        logs(" The file has already been downloaded, open it.");
        logs("saved file path  ---- > $filePath");

        if (extensionCheck(mainURL) == "mp4") {
          logs("Its video");

          Get.toNamed(RouteHelper.getVideoPlayerScreen(),
              arguments: {'video': filePath});
        }
        if (extensionCheck(mainURL) == "jpg" ||
            extensionCheck(mainURL) == "png") {
          logs("Its Image");
          Get.toNamed(RouteHelper.getImageViewScreen(),
              arguments: {'image': filePath, 'name': arguments['name']});
        }

        if (extensionCheck(mainURL) == "mp3") {
          logs("Its audio");

          controller.isPlayingList[index] = !controller.isPlayingList[index];
          controller.update();
          logs(
              "isPlayList =------------------------> ${controller.isPlayingList.toString()}");

//false
          if (!controller.player.playing) {
            logs("Music not playing");
            controller.isPlayingList = List.filled(100, false);
            controller.update();
            controller.player.setUrl(filePath);
            controller.player.play();
            controller.isPlayingList[index] = true;
            controller.update();
            //true
          } else {
            logs("Music already playing");
            controller.player.stop();
            controller.update();
            controller.isPlayingList = List.filled(100, false);
            controller.update();
          }
        } else {
          OpenFile.open(filePath);
        }
      } else {
        logs("Downloading Start");
        downloadAndSavePDF(mainURL, folderName, controller, index);
      }
    }
  }

  Future<void> isFileDownloadedCheck(
      index, folderName, pdfURL, ChatingPageController controller) async {
    var dirPath =
        "${await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)}/CHATAPP/$folderName";
    Directory dir = Directory(dirPath);
    List splitUrl = pdfURL.split("/");
    final filePath =
        '${dir.path}/myFile${splitUrl.last.toString().substring(splitUrl.last.toString().length - 10, splitUrl.last.toString().length)}.${extensionCheck(pdfURL)}';

    if (await File(filePath).exists()) {
      isFileDownLoadedList[index] = true;
      if (filePath.contains(".mp4")) {
        // downloadedVideoList[index] = filePath;
      }
      controller.update();
    }
  }


  extensionCheck(pdfURL) {
    if (pdfURL.toString().contains("sentDoc.${"jpg"}")) {
      return "jpg";
    }
    if (pdfURL.toString().contains("sentDoc.${"png"}")) {
      return "png";
    }
    if (pdfURL.toString().contains("sentDoc.${"mp4"}")) {
      return "mp4";
    }
    if (pdfURL.toString().contains("sentDoc.${"mp3"}")) {
      return "mp3";
    }
    if (pdfURL.toString().contains("sentDoc.${"pdf"}")) {
      return "pdf";
    }
    if (pdfURL.toString().contains("sentDoc.${"doc"}")) {
      return "doc";
    }
    if (pdfURL.toString().contains("sentDoc.${"docx"}")) {
      return "docx";
    }
  }

  Future<void> getPermission() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    await Permission.accessMediaLocation.request();

    final PermissionStatus permissionStatus1 = await Permission.storage.status;
    final PermissionStatus permissionStatus2 =
        await Permission.manageExternalStorage.status;
    final PermissionStatus permissionStatus3 =
        await Permission.accessMediaLocation.status;

    if (permissionStatus1.isGranted &&
        permissionStatus2.isGranted &&
        permissionStatus3.isGranted) {
      //do
    } else {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      await Permission.accessMediaLocation.request();
    }
  }

  //=========================== audio =============================//

  audioSendTap() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.path != null) {
        audioFile = File(file.path!);
        // ignore: unrelated_type_equality_checks
        if (await isFileLarge(File(file.path!)) == false) {
          goToAttachmentScreen(
              selectedImage: file.path,
              members: arguments['members'],
              extension: "");
        }
      } else {}

      logs('Selected MP3 file: ${file.name}');
    } else {
      logs('User canceled file picking');
    }
  }

  onSendAudio(String msgType, controller) async {
    DatabaseService.uploadAudio(File(audioFile!.path), controller)
        .then((value) {
      logs('message---> $value');
      SendMessageModel sendMessageModel = SendMessageModel(
          type: msgType,
          members: arguments['members'],
          message: value,
          sender: AuthService.auth.currentUser!.phoneNumber!,
          isGroup: false);
      DatabaseService.instance.addNewMessage(sendMessageModel);
    });
    controller.update();
  }

  //========================= video =============================//

  Future<void> pickVideoGallery(GetxController controller, members) async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (await isFileLarge(File(pickedFile.path)) == false) {
        selectedVideo = (File(pickedFile.path));

        goToAttachmentScreen(
            selectedImage: selectedVideo!.path,
            members: members,
            thumbnail: await getVideoThumb(pickedFile.path));
        logs(selectedVideo.toString());
        controller.update();
      }
    }
  }

  Future getVideoThumb(file) async {
    var dirPath =
        "${await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)}/CHATAPP/THUMB";

    Directory dir = Directory(dirPath);
    if (!await dir.exists()) {
      dir.create();
    }

    return await VideoThumbnail.thumbnailFile(
      video: file,
      thumbnailPath:
          "${await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)}/CHATAPP/THUMB",
      imageFormat: ImageFormat.PNG,
      maxHeight: 64,
      quality: 75,
    );
  }

  videoSendTap() {
    pickVideoGallery(controller!, arguments['members']);
  }

  onSendVideo(String msgType, controller) async {
    DatabaseService.uploadAudio(File(audioFile!.path), controller)
        .then((value) {
      logs('message---> $value');
      SendMessageModel sendMessageModel = SendMessageModel(
          type: msgType,
          members: arguments['members'],
          message: value,
          sender: AuthService.auth.currentUser!.phoneNumber!,
          isGroup: false);
      DatabaseService.instance.addNewMessage(sendMessageModel);
    });
    controller.update();
  }

  //========================= pick images =============================//

  Future<void> pickImageGallery(GetxController controller, members) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      goToAttachmentScreen(
          selectedImage: selectedImage!.path,
          members: members,
          thumbnail: await compressFile(File(selectedImage!.path)));
      // uploadImage(selectedImage!);
      logs(selectedImage.toString());
      controller.update();
    }
  }

  Future<void> pickImageCamera(GetxController controller, members) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      goToAttachmentScreen(
          selectedImage: selectedImage!.path,
          members: members,
          thumbnail: await compressFile(File(selectedImage!.path)));
      // uploadImage(selectedImage!);
      logs(selectedImage.toString());
      controller.update();
    }
  }

  Future<String> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 1,
    );
    return compressedFile.path;
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

  Future<bool> isFileLarge(File file) async {
    int fileSizeInBytes = await file.length();

    double fileSizeInMB = (fileSizeInBytes / (1024 * 1024)).toDouble();

    if (fileSizeInMB < 2) {
      logs('File is smaller than 2 MB. Performing action...');
      return false;
    } else {
      ToastUtil.successToast("File is larger than 2 MB.");

      logs('Image is larger than 2 MB.');
      return true;
    }
  }

  buildPopupMenu(BuildContext context, ChatingPageController controller) {
    return PopupMenuButton(
      offset: const Offset(-10, kToolbarHeight),
      onSelected: (value) {
        isFileDownLoadingList = isFileDownLoadingList.toList();
        isFileDownLoadingList.add(false);
        isFileDownLoadedList = isFileDownLoadedList.toList();
        isFileDownLoadedList.add(false);

        controller.update();
        if (value == 0) {
          buildImagePickerMenu(context);
        }
        if (value == 1) {
          audioSendTap();
        }
        if (value == 2) {
          videoSendTap();
        }
        if (value == 3) {
          pickDocument(controller!);
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
                  AppText(S.of(Get.context!).audio),
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
        'about': arguments['about'],
      });
    }
    if (value == 3) {
      blockedNumbers.add(arguments['number']);
      UsersService.instance.blockUser(blockedNumbers, arguments['number']);

      controller!.update();
    }
  }

  buildDoubleClickView() {
    return Container(
      alignment: Alignment.center,
      height: 15.px,
      width: 15.px,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(Get.context!).colorScheme.primary,
          )),
      child: Icon(
        Icons.done_all,
        color: Theme.of(Get.context!).colorScheme.primary,
        size: 12.px,
      ),
    );
  }

  buildSingleClickView() {
    return Container(
      alignment: Alignment.center,
      height: 15.px,
      width: 15.px,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: Theme.of(Get.context!).colorScheme.primary)),
      child: Icon(
        Icons.done,
        color: Theme.of(Get.context!).colorScheme.primary,
        size: 12.px,
      ),
    );
  }

  getChatLength() async {
    final chatStream = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(snapshots.docs.first.id)
        .collection('chats')
        .get();
    final chatLength = chatStream.docs.length;

    if (isFileDownLoadingList.isEmpty) {
      isFileDownLoadingList = List.filled(chatLength, false);
      isFileDownLoadedList = List.filled(chatLength, false);
      downloadedVideoList = List.filled(chatLength, false);
      controller!.durationList = List.filled(chatLength, Duration.zero);
      controller!.positionList = List.filled(chatLength, Duration.zero);
      controller!.isPlayingList = List.filled(chatLength, false);
      controller!.isPlayingList = List.filled(chatLength, false);
    } else {
      // isFileDownLoadingList = isFileDownLoadingList.toList();
      // isFileDownLoadingList.add(false);
      // isFileDownLoadedList = isFileDownLoadedList.toList();
      // isFileDownLoadedList.add(false);

      // controller!.durationList = controller!.durationList.toList();
      // controller!.durationList.add(Duration.zero);
      // controller!.positionList = controller!.positionList.toList();
      // controller!.positionList.add(Duration.zero);
      // controller!.isPlayingList = controller!.isPlayingList.toList();
      // controller!.isPlayingList.add(false);
    }
  }

  updateChatLength(int length) {
    if (length >= isFileDownLoadedList.length) {
      int lenDiff = length - isFileDownLoadedList.length;
      for (int i = 0; i < lenDiff; i++) {
        isFileDownLoadingList = isFileDownLoadingList.toList();
        isFileDownLoadingList.add(false);
        isFileDownLoadedList = isFileDownLoadedList.toList();
        isFileDownLoadedList.add(false);

        downloadedVideoList = downloadedVideoList.toList();
        downloadedVideoList.add(false);
        controller!.durationList = controller!.durationList.toList();
        controller!.durationList.add(Duration.zero);
        controller!.positionList = controller!.positionList.toList();
        controller!.positionList.add(Duration.zero);
        controller!.isPlayingList = controller!.isPlayingList.toList();
        controller!.isPlayingList.add(false);
      }
    }
  }

  getBlockedList() async {
    if(arguments["isGroup"]) {
      isBlocked = await UsersService.instance
          .isBlockedByLoggedInUser(arguments['number']);
      logs('blocked----------> ${isBlocked}');
    }
  }
  getChatId()
  async {
    snapshots = await DatabaseService.instance
        .getChatDoc(arguments['members']);

  }

  chatStream()
  {
    getChatsStream =
        DatabaseService.instance.getChatStream(
          snapshots.docs.first.id,
        );

  }
  markMessage()
  {
    DatabaseService.instance.markMessagesAsSeen(
     snapshots.docs.first.id,
        arguments['number']);
  }
}
