import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/shared_preferences.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/modal/notification_model.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/users_service.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../app/app/utills/toast_util.dart';
import '../../app/widget/app_image_assets.dart';
import '../../constant/app_asset.dart';
import '../../constant/string_constant.dart';
import '../../modal/message.dart';
import '../../modal/send_message_model.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';
import '../../service/notification_api_services.dart';

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
  bool isBlockedByReceiver = false;
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

  List isFileDownLoadedList = [];
  List isPlayList = [];

  String selectedEmoji = '';
  bool isBlockedByLoggedInUser = false;
  List<bool> isFileDownLoadingList = <bool>[];
  String? backWallpaper;
  Color? chatbubblecolor;

  TextEditingController chatController = TextEditingController();
  ChatingPageController? controller;
  String statusText = "";
  bool isRecording = false;
  bool isComplete = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  int downloadPercentage = 0;
  int i = 0;
  String? recordFilePath;
  Color? wallColorbackground;
  String? wallImage;
  bool iconChange = false;
  final firestore = FirebaseFirestore.instance;
  Color? bubblColors;
  List<MessageModel> selectedMessage = [];
  List<bool> selectedMessageTrueFalse = [];
  bool sendMsg = false;
  String imageLink = '';

  ChatingPageViewModal([this.chatingPage]) {
    Future.delayed(const Duration(milliseconds: 0), () async {
      controller = Get.find<ChatingPageController>();
      fontSize = await getStringValue(StringConstant.setFontSize);
      controller!.update();
    });
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      isComplete = false;
      controller!.update();
      RecordMp3.instance.start(recordFilePath!, (type) {
        controller!.update();
      });
      chatController.text = "Recoding start....";
      isRecording = true;
      controller!.update();
    }
  }

  stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      File audioFile = File(recordFilePath!);
      uploadAudio(audioFile);
      isComplete = true;
      controller!.update();
      chatController.text = "";
      isRecording = false;
      controller!.update();
    }
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  Future<String> uploadAudio(File url) async {
    isLoading = true;
    controller!.update();

    final storage = FirebaseStorage.instance
        .ref('chat')
        .child("audio")
        .child(AuthService.auth.currentUser!.phoneNumber!)
        .child('${DateTime.now()}sentDoc.mp3');

    final UploadTask uploadTask =
        storage.putFile(url, SettableMetadata(contentType: 'AUDIO'));
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
      downloadPercentage = (progress * 100).round();
      logs("download ---- > ${progress.toString()}");
      controller!.update();
    });

    await uploadTask.whenComplete(() {
      logs('File uploaded successfully');
    });

    storage.getDownloadURL().then(
      (value) {
        logs("value -- > $value");
        downloadAndSaveFile(value, "SENT/AUDIO");

        SendMessageModel sendMessageModel = SendMessageModel(
            type: "audio",
            members: arguments['members'],
            message: value,
            sender: AuthService.auth.currentUser!.phoneNumber!,
            isGroup: false,
            text: "");
        DatabaseService.instance.addNewMessage(sendMessageModel);
        notification('🎶 audio');
      },
    );
    logs("isLoading-----$isLoading");
    return await storage.getDownloadURL();
  }

  downloadAndSaveFile(
    String pdfURL,
    folderName,
  ) async {
    List splitUrl = pdfURL.split("/");
    final response = await http.get(Uri.parse(pdfURL));
    String? fileName;
    var rootPath;
    rootPath ??= await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    var dirPath = "$rootPath/CHATAPP/$folderName";
    logs("dir path -- $dirPath");
    Directory dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    fileName =
        "myFile${splitUrl.last.toString().substring(splitUrl.last.toString().length - 10, splitUrl.last.toString().length)}.${extensionCheck(pdfURL)}";
    File file = File("${dir.path}/$fileName");
    logs("saved file path --->  ${file.path}");

    await file.writeAsBytes(response.bodyBytes);
    isLoading = false;
    controller!.update();
    logs("isLoading-----$isLoading");
    logs("downloaded path --- > $fileName");
  }

  Future<void> notification(String message) async {
    logs("Chatting page members ---- > ${arguments['members']}");
    String a = await controller!.getUserFcmToken(arguments['number']);
    ResponseService.postRestUrl(message, a);

    NotificationModel notificationModel = NotificationModel(
      time:
          ' ${DateTime.now().hour}:${DateTime.now().minute} | ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      sender: AuthService.auth.currentUser!.phoneNumber,
      receiver: arguments['number'],
      receiverName:
          await UsersService.instance.getUserName('${arguments['number']}'),
      senderName: await UsersService.instance
          .getUserName('${AuthService.auth.currentUser!.phoneNumber}'),
      message: message,
    );

    logs(
        'receiver name----> ${await UsersService.instance.getUserName('${arguments['number']}')}');
    logs('receiver number----> ${arguments['number']}');
    logs(
        'sender name----> ${await UsersService.instance.getUserName('${AuthService.auth.currentUser!.phoneNumber}')}');
    logs('sender number----> ${AuthService.auth.currentUser!.phoneNumber}');
    logs('message ----> $message');

    await UsersService.instance.notification(notificationModel);
    a = '';
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
    final PermissionStatus permissionStatus1 = await Permission.storage.status;
    final PermissionStatus permissionStatus2 = await Permission.manageExternalStorage.status;
    final PermissionStatus permissionStatus3 = await Permission.accessMediaLocation.status;
    if (!permissionStatus1.isGranted && !permissionStatus2.isGranted && !permissionStatus3.isGranted  ) {
      getPermission();
    } else {
      logs("download Entered");
      downloadAndSavePDF(mainURL, folderName, controller, index);

      var dirPath =
          "${await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)}/CHATAPP/$folderName";
      Directory dir = Directory(dirPath);
      List splitUrl = mainURL.split("/");

      final filePath =
          '${dir.path}/myFile${splitUrl.last.toString().substring(splitUrl.last.toString().length - 10, splitUrl.last.toString().length)}.${extensionCheck(mainURL)}';

      logs("ckeck file  --- > $filePath");
      if (await File(filePath).exists()) {
        isFileDownLoadedList[index] = true;
        controller.update();
        logs(" The file has already been downloaded, open it.");
        logs("saved file path  ---- > $filePath");
        if (extensionCheck(mainURL) == "jpg" ||
            extensionCheck(mainURL) == "png") {
          logs("It's Image");
          Get.toNamed(RouteHelper.getImageViewScreen(),
              arguments: {'image': filePath, 'name': arguments['name']});
        }

        if (extensionCheck(mainURL) == "mp4") {
          logs("Its video");
          Get.toNamed(RouteHelper.getVideoPlayerScreen(),
              arguments: {'video': filePath});
        }
        if (extensionCheck(mainURL) == "mp3") {
          logs("It's audio");
          if (!controller.player.playing) {
            logs("Music not playing");
            controller!.positionList = List.filled(100, Duration.zero);
            controller!.isPlayingList = List.filled(100, false);
            controller.update();
            controller.player.setUrl(filePath);
            controller.player.play();
            controller.isPlayingList[index] = true;
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
        isGroup: false,
      );
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
        );
        logs(selectedVideo.toString());
        controller.update();
      }
    }
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

  //========================= pick images =============================//

  Future<void> pickImageGallery(GetxController controller, members) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );

    if (pickedFile != null) {
      selectedImage = (File(pickedFile.path));
      goToAttachmentScreen(
          selectedImage: selectedImage!.path,
          members: members,
          thumbnail: await compressFile(
              File(selectedImage!.path))); // uploadImage(selectedImage!);
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
          thumbnail: await compressFile(
              File(selectedImage!.path))); // uploadImage(selectedImage!);
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

  Future<String> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 1,
    );
    return compressedFile.path;
  }

  buildNavigationMenu(BuildContext context, ChatingPageController controller) {
    return PopupMenuButton(
      onSelected: (value) {
        isFileDownLoadingList = isFileDownLoadingList.toList();
        isFileDownLoadingList.add(false);
        isFileDownLoadedList = isFileDownLoadedList.toList();
        isFileDownLoadedList.add(false);

        controller.update();
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
                children: (!isBlockedByLoggedInUser)
                    ? [
                        AppText(S.of(Get.context!).block),
                        const Icon(Icons.block),
                      ]
                    : [
                        const AppText(StringConstant.unBlock),
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
      if (isBlockedByLoggedInUser) {
        blockedNumbers.remove(arguments['number']);
        UsersService.instance.unblockUser(arguments['number']);
        getBlockedList(controller);
        controller!.update();
      } else {
        blockedNumbers.add(arguments['number']);
        UsersService.instance.blockUser(blockedNumbers, arguments['number']);
        getBlockedList(controller);
        controller!.update();
      }
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

  showEmojiMenu(BuildContext context, Offset position, roomId, messageId,
      receiverNumber, isGroup) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final selectedEmoji = await showMenu<String>(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.px)),
      position: RelativeRect.fromRect(position & const Size(0, 0),
          overlay.localToGlobal(const Offset(-200, 100)) & overlay.size),
      context: context,
      items: [
        PopupMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () async {
                    addEmoji(
                        roomId, messageId, receiverNumber, "🙏", "🙏", isGroup);
                    selectedMessageTrueFalse[0] = false;
                    controller!.update();
                    Navigator.pop(context, "🙏");
                  },
                  child: AppText("🙏", fontSize: 22.px)),
              GestureDetector(
                  onTap: () {
                    addEmoji(
                        roomId, messageId, receiverNumber, "😂", "😂", isGroup);
                    selectedMessageTrueFalse[0] = false;
                    controller!.update();
                    Navigator.pop(context, "😂");
                  },
                  child: AppText('😂', fontSize: 22.px)),
              GestureDetector(
                  onTap: () {
                    addEmoji(
                        roomId, messageId, receiverNumber, "😮", "😮", isGroup);
                    selectedMessageTrueFalse[0] = false;
                    controller!.update();
                    Navigator.pop(context, "😮");
                  },
                  child: AppText('😮', fontSize: 22.px)),
              GestureDetector(
                  onTap: () {
                    addEmoji(
                        roomId, messageId, receiverNumber, "❤️", "❤️", isGroup);
                    selectedMessageTrueFalse[0] = false;
                    controller!.update();
                    Navigator.pop(context, "❤️");
                  },
                  child: AppText('❤️', fontSize: 22.px)),
              GestureDetector(
                  onTap: () {
                    addEmoji(
                        roomId, messageId, receiverNumber, "👍", "👍", isGroup);
                    selectedMessageTrueFalse[0] = false;
                    controller!.update();
                    Navigator.pop(context, "👍");
                  },
                  child: AppText('👍', fontSize: 22.px)),
              GestureDetector(
                  onTap: () {
                    addEmoji(
                        roomId, messageId, receiverNumber, "😥", "😥", isGroup);
                    selectedMessageTrueFalse[0] = false;
                    controller!.update();
                    Navigator.pop(context, "😥");
                  },
                  child: AppText('😥', fontSize: 22.px)),
              SizedBox(width: 5.px,),
              GestureDetector(
                  onTap: () {
                    String SelectedEmoji = '';
                    showBottomSheet(context: context, builder: (context) {
                      return  Container(
                        height: 250.px,
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            SelectedEmoji = emoji.emoji;
                            addEmoji(
                                roomId, messageId, receiverNumber, emoji.emoji, emoji.emoji, isGroup);
                            Navigator.pop(context, emoji.emoji);
                            controller!.update();

                          },
                        ),
                      );

                    },);
                    selectedMessageTrueFalse[0] = false;
                    Navigator.pop(context,SelectedEmoji);
                    controller!.update();
                  },
                  child: const Icon(Icons.add_circle_outline_sharp)),
            ],
          ),
        ),
      ],
    );
    if (selectedEmoji != null) {
      this.selectedEmoji = selectedEmoji;
      controller!.update();
    }
  }

  ///=================    array union to work =============== /////

  Future<void> addEmoji(roomId, messageId, receiverNumber, receiverEmoji,
      senderEmoji, isGroup) async {
    logs('messageidddddd-->$messageId');
    logs('roomidddddddd-->$roomId');

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('chats')
        .doc(messageId);
    logs('documentReference-->$documentReference');

    DocumentSnapshot documentSnapshot = await documentReference.get();
    Map<String, dynamic> currentData =
        documentSnapshot.data() as Map<String, dynamic>;

    Map<String, dynamic> emojiData = currentData['emoji'] ?? {};
    logs('receivernumber-->$receiverNumber');
    logs('senderNumber-->${AuthService.auth.currentUser!.phoneNumber}');
    if (isGroup) {
      // Ensure that 'groupEmojis' is an array in the Firestore document
      emojiData['groupEmojis'] = emojiData['groupEmojis'] ?? [];

      // Create a new emoji object
      Map<String, dynamic> emojiToAdd = {
        "id": AuthService.auth.currentUser!.phoneNumber,
        "emoji": receiverEmoji,
      };
      // Check if the sender already has an emoji in 'groupEmojis'
      final senderIndex = emojiData['groupEmojis']
          .indexWhere((emoji) => emoji['id'] == emojiToAdd['id']);

      if (senderIndex != -1) {
        // Replace the existing emoji
        emojiData['groupEmojis'][senderIndex] = emojiToAdd;
      } else {
        // Add the emoji to 'groupEmojis' array
        emojiData['groupEmojis'].add(emojiToAdd);
      }
      // Update 'groupEmojis' in Firestore
      await documentReference.update({
        'emoji.groupEmojis': emojiData['groupEmojis'],
      });
    } else {
      //Handle one-on-one chat
      if (receiverNumber == AuthService.auth.currentUser!.phoneNumber) {
        emojiData.remove('senderEmoji');

        emojiData['senderEmoji'] = {
          "id": AuthService.auth.currentUser!.phoneNumber,
          "emoji": senderEmoji,
        };
      } else {
        emojiData.remove('receiverEmoji');
        emojiData['receiverEmoji'] = {
          "id": AuthService.auth.currentUser!.phoneNumber,
          "emoji": senderEmoji,
        };
      }
      // Update the 'emoji' field in the Firestore document
      await documentReference.update({'emoji': emojiData});
    }
  }

  /// ======================Delete Emoji Function ==============///
  Future<void> deleteEmoji(
      roomId, messageId, receiverNumber, receiverEmoji, senderEmoji) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('chats')
        .doc(messageId);

    DocumentSnapshot documentSnapshot = await documentReference.get();
    Map<String, dynamic> currentData =
        documentSnapshot.data() as Map<String, dynamic>;

    Map<String, dynamic> emojiData = currentData['emoji'] ?? {};

    if (receiverNumber != AuthService.auth.currentUser!.phoneNumber) {
      if (emojiData.containsKey('receiverEmoji')) {
        emojiData.remove('receiverEmoji');
      }
    } else {
      if (emojiData.containsKey('senderEmoji')) {
        emojiData.remove('senderEmoji');
      }
    }

    currentData['emoji'] = emojiData;

    await documentReference.set(currentData);

    logs('currrrrrrrentDaata-->$currentData');
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
      controller!.durationList = List.filled(chatLength, Duration.zero);
      controller!.positionList = List.filled(chatLength, Duration.zero);
      controller!.isPlayingList = List.filled(chatLength, false);
      selectedMessageTrueFalse = List.filled(chatLength, false);
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
        selectedMessageTrueFalse = selectedMessageTrueFalse.toList();
        selectedMessageTrueFalse.add(false);
        controller!.durationList = controller!.durationList.toList();
        controller!.durationList.add(Duration.zero);
        controller!.positionList = controller!.positionList.toList();
        controller!.positionList.add(Duration.zero);
        controller!.isPlayingList = controller!.isPlayingList.toList();
        controller!.isPlayingList.add(false);
      }
    }
  }

  getBlockedList(ChatingPageController? controller) async {
    if (!arguments["isGroup"]) {
      isBlockedByLoggedInUser = await UsersService.instance
          .isBlockedByLoggedInUser(arguments['number']);
      controller!.update();
      logs('blocked ----------> $isBlockedByLoggedInUser');
    }
  }

  getChatId() async {
    snapshots = await DatabaseService.instance.getChatDoc(arguments['members']);
  }

  chatStream() {
    getChatsStream = DatabaseService.instance.getChatStream(
      snapshots.docs.first.id,
    );
  }

  markMessage() {
    if (arguments.isNotEmpty) {
      DatabaseService.instance
          .markMessagesAsSeen(snapshots.docs.first.id, arguments['number']);
    }
  }

  Future<void> getColorFromFirestore() async {
    final users = FirebaseFirestore.instance.collection("users");
    final userDocument = users.doc(FirebaseAuth.instance.currentUser!.uid);
    final documentSnapshot = await userDocument.get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data != null && data['colorCode'] != null) {
        wallImage = data['wallpaper'];
        if (wallImage!.isEmpty) {
          wallColorbackground = Color(int.parse(data['colorCode'], radix: 16));
        }
        logs('wallColorBackground-->$wallColorbackground');
        logs('wallimage-->$wallImage');
        controller!.update();
      }
    }
  }

  Future<Color> getChatBubbleColors() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final colorRef = firestore.collection('users').doc(user.uid);
      final documentSnapshot = await colorRef.get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        final colorHex = data?['bubbleColor'];
        if (colorHex != null) {
          bubblColors = Color(int.parse(data!['bubbleColor'], radix: 16));
          logs('bubbllllllleeeeColors-->$bubblColors');
        }
      }
    }
    return AppColorConstant.appYellow;
  }

  forwardMessage(int index, MessageModel message, BuildContext context, details) {
    selectedMessage.length < 1
        ? showEmojiMenu(
            context,
            details.globalPosition,
            snapshots.docs[0]['id'],
            message.messageId,
            message.sender,
            arguments["isGroup"],
          )
        : null;
    if (index >= 0 && index < selectedMessageTrueFalse.length) {
      selectedMessageTrueFalse[index] = !selectedMessageTrueFalse[index];

      if (selectedMessageTrueFalse[index]) {
        errorLogs(message.messageType.toString());
        selectedMessage.add(message);
      } else {
        selectedMessage.removeWhere((msg) => msg.messageId == message.messageId);
      }
      controller!.update();
    } else {
      logs('Invalid index: $index');
    }
  }

   forwordMessage(element) async {
    logs("Members---${arguments['members']}");

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('members', isEqualTo: arguments['members'])
        .get();
    logs("ref Id ---- >${querySnapshot.docs.length.toString()}");

    MessageModel messageModel = MessageModel(
        messageStatus: false,
        message: element.message,
        isSender: true,
        messageTimestamp: DateTime.now().millisecondsSinceEpoch,
        messageType: element.messageType,
        sender: AuthService.auth.currentUser!.phoneNumber,
        text: element.text,
        thumb: element.thumb,
        messageId: element.messageId);

    DocumentReference messageRef = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(querySnapshot.docs.first.id)
        .collection('chats')
        .add(messageModel.toJson());
    String messageId = messageRef.id;
    await messageRef.update({'messageid': messageId});

    (element.messageType == 'text')
        ? notification(element.message)
        : (element.messageType == 'image')
        ? notification('📷 photo')
        : (element.messageType == 'audio')
        ? notification('🎶 audio')
        : (element.messageType == 'doc')
        ? notification('📃 document')
        : notification('🎥 video');
  }

}
