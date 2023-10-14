import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/chating_page/attachment/attachment_view_model.dart';
import 'package:signal/pages/chating_page/chating_page_view_modal.dart';
import 'package:signal/service/database_service.dart';
import 'package:video_player/video_player.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../app/app/utills/theme_util.dart';
import '../../../app/widget/app_text.dart';
import '../../../controller/acccount_controller.dart';
import '../../../service/network_connectivity.dart';

// ignore: must_be_immutable
class AttachmentScreen extends StatelessWidget {
  AttachmentViewModel? attachmentViewModel;
  AttachmentController? attachmentController;

  AttachmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    attachmentViewModel ?? (attachmentViewModel = AttachmentViewModel(this));

    return GetBuilder<AttachmentController>(
      init: AttachmentController(),
      dispose: (state) {
        //  controller!.player.dispose();
      },
      initState: (state) {
        NetworkConnectivity.checkConnectivity(context);
        attachmentViewModel!.argument = Get.arguments;
        attachmentViewModel!.selectedImage =
            attachmentViewModel!.argument['image'];
        logs("parameter data---->${attachmentViewModel!.selectedImage}");
        logs(
            "parameter data---->${attachmentViewModel!.argument["extension"]}");

        attachmentViewModel!.videoPlayerController =
            VideoPlayerController.networkUrl(
                Uri.parse(attachmentViewModel!.selectedImage));

        attachmentViewModel!.initializeVideoPlayer =
            attachmentViewModel!.videoPlayerController!.initialize();
        attachmentViewModel!.videoPlayerController!.setLooping(false);

        Future.delayed(
          const Duration(milliseconds: 200),
          () {
            attachmentController = Get.find<AttachmentController>();
            attachmentViewModel!.fileSize(attachmentController);

            attachmentViewModel!.videoPlayerController!.addListener(() {
              attachmentViewModel!.sliderValue = attachmentViewModel!
                  .videoPlayerController!.value.position.inMilliseconds
                  .toDouble();
              attachmentController!.update();
            });
          },
        );
      },
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            attachmentViewModel!.stopVideoPlayback();
            controller.player.dispose();
            return true;
          },
          child: SafeArea(
            child:  Builder(builder: (context) {
              MediaQueryData mediaQuery = MediaQuery.of(context);
              ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
              return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: fileViews(
                controller,
                context,
                fileViewIndex(),
              ),
            );})
          ),
        );
      },
    );
  }

  photoShowView(AttachmentController controller, BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20.px),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          child: Column(children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.clear))),
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: AppImageAsset(
                        isFile: true,
                        image: attachmentViewModel!.selectedImage))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      attachmentViewModel!.imageCrop(context, controller);
                    },
                    icon: const Icon(
                      Icons.crop,
                      color: AppColorConstant.appYellow,
                    )),
                Padding(
                  padding: EdgeInsets.all(8.px),
                  child: AppText(
                    attachmentViewModel!.fileSizes.toString(),
                    color: AppColorConstant.darkSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.px),
              child: AppTextFormField(
                controller: attachmentViewModel!.textController,
                suffixIcon: IconButton(
                  onPressed: () {
                    attachmentViewModel!.imageButtonTap(controller);
                  },
                  icon:
                      const Icon(Icons.send, color: AppColorConstant.appYellow),
                ),
              ),
            )
          ]),
        ),
        if (DatabaseService.isLoading)
          AppLoader(
              widget: AppText(
            "${DatabaseService.downloadPercentage.toString()}%",
            color: Theme.of(context).colorScheme.primary,
          )),
      ],
    );
  }

  videoShowView(AttachmentController controller, BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20.px),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          child: SingleChildScrollView(
            child: Column(children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                      onPressed: () {
                        attachmentViewModel!.stopVideoPlayback();
                        Get.back();
                      },
                      icon: const Icon(Icons.clear))),
              FutureBuilder(
                future: attachmentViewModel!.initializeVideoPlayer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AspectRatio(
                          aspectRatio: attachmentViewModel!
                              .videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(
                              attachmentViewModel!.videoPlayerController!),
                        ),
                        InkWell(
                          onTap: () {
                            if (attachmentViewModel!
                                .videoPlayerController!.value.isPlaying) {
                              attachmentViewModel!.videoPlayerController!
                                  .pause();
                            } else {
                              attachmentViewModel!.videoPlayerController!
                                  .play();
                            }
                            controller.update();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0.px),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40.px,
                                  child: AppText(
                                    attachmentViewModel!.formatDuration(
                                        attachmentViewModel!
                                            .videoPlayerController
                                            .value
                                            .position),
                                    fontSize: 10.px,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    divisions: 1000,
                                    activeColor: AppColorConstant.appYellow,
                                    value: attachmentViewModel!.sliderValue,
                                    onChanged: (value) {
                                      attachmentViewModel!.sliderValue = value;
                                      controller.update();
                                      attachmentViewModel!.videoPlayerController
                                          .seekTo(Duration(
                                              milliseconds: value.toInt()));

                                      controller.update();
                                      logs(
                                          "slider valuse  -- >${attachmentViewModel!.sliderValue}");
                                    },
                                    max: attachmentViewModel!
                                        .videoPlayerController
                                        .value
                                        .duration
                                        .inMilliseconds
                                        .toDouble(),
                                  ),
                                ),
                                SizedBox(
                                    height: 30.px,
                                    width: 30.px,
                                    child: (!attachmentViewModel!
                                            .videoPlayerController!
                                            .value
                                            .isPlaying)
                                        ? Icon(
                                            Icons.play_circle,
                                            color: AppColorConstant.appYellow,
                                            size: 25.px,
                                          )
                                        : Icon(
                                            Icons.pause_circle,
                                            color: AppColorConstant.appYellow,
                                            size: 25.px,
                                          )),
                                Container(
                                  width: 45.px,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5.px),
                                    child: AppText(
                                      attachmentViewModel!.formatDuration(
                                          attachmentViewModel!
                                              .videoPlayerController
                                              .value
                                              .duration),
                                      fontSize: 10.px,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return AppLoader();
                  }
                },
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.px),
                    child: AppText(
                      attachmentViewModel!.fileSizes.toString(),
                      color: AppColorConstant.darkSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 15.px),
                child: AppTextFormField(
                  controller: attachmentViewModel!.textController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      attachmentViewModel!.stopVideoPlayback();
                      attachmentViewModel!.videoButtonTap(controller);
                    },
                    icon: const Icon(Icons.send,
                        color: AppColorConstant.appYellow),
                  ),
                ),
              )
            ]),
          ),
        ),
        if (DatabaseService.isLoading)
          AppLoader(
              widget:
                  AppText("${DatabaseService.downloadPercentage.toString()}%")),
      ],
    );
  }

  documentShowView(AttachmentController controller, BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20.px),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          child: SingleChildScrollView(
            child: Column(children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.clear))),
              SizedBox(
                height: 100.px,
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2.px, color: AppColorConstant.appYellow),
                      borderRadius: BorderRadius.all(Radius.circular(20.px))),
                  height: 300.px,
                  child: Padding(
                    padding: EdgeInsets.all(70.px),
                    child: AppImageAsset(
                      image: AppAsset.docs,
                      height: 100.px,
                    ),
                  )),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(12.px),
                    child: AppText(
                      "${attachmentViewModel!.fileSizes}",
                      color: AppColorConstant.darkSecondary,
                      fontSize: 18.px,
                    ),
                  )),
              SizedBox(
                height: 70.px,
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.px),
                child: AppTextFormField(
                  controller: attachmentViewModel!.textController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      attachmentViewModel!.documentButtonTap(controller,
                          attachmentViewModel!.argument['extension']);
                    },
                    icon: const Icon(Icons.send,
                        color: AppColorConstant.appYellow),
                  ),
                ),
              )
            ]),
          ),
        ),
        if (DatabaseService.isLoading)
          AppLoader(
              widget:
                  AppText("${DatabaseService.downloadPercentage.toString()}%")),
      ],
    );
  }

  audioShowView(AttachmentController controller, BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(30.px),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                        onPressed: () {
                          controller.player.dispose();

                          Get.back();
                        },
                        icon: const Icon(Icons.clear))),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.px, color: AppColorConstant.appYellow),
                        borderRadius: BorderRadius.all(Radius.circular(20.px))),
                    height: 300.px,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 30.px),
                                child: Icon(
                                  Icons.music_note_outlined,
                                  color: AppColorConstant.appYellow,
                                  size: 40.px,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(15.px),
                              child: AppText(
                                attachmentViewModel!.fileSizes.toString(),
                                color: AppColorConstant.darkSecondary,
                              ),
                            ))
                      ],
                    )),
                SizedBox(
                  height: 10.px,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 400.px,
                  margin: EdgeInsets.symmetric(vertical: 15.px),
                  height: 45.px,
                  decoration: BoxDecoration(
                      color: AppColorConstant.appYellow,
                      borderRadius: BorderRadius.circular(12.px)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 4.px),
                          alignment: Alignment.center,
                          height: 50.px,
                          child: AppText(
                            attachmentViewModel!
                                .formatDuration(controller.position),
                            fontSize: 10.px,
                          )),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColorConstant.appWhite,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 8.px,
                              disabledThumbRadius: 8.px),
                        ),
                        child: Expanded(
                          child: Slider(
                            activeColor: AppColorConstant.appWhite,
                            min: 0,
                            divisions: 1000,
                            max: controller.duration.inSeconds.toDouble(),
                            value: controller.position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              controller.position =
                                  Duration(seconds: value.toInt());
                              await controller.player.seek(controller.position);
                              controller.update();
                              //await controller.player.resume();
                            },
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            if (controller.isPlay.value) {
                              await controller.player.pause();
                            } else {
                              await controller.player
                                  .setUrl(attachmentViewModel!.selectedImage);
                              await controller.player.play();
                            }
                          },
                          icon: (controller!.isPlay.value)
                              ? const Icon(
                                  Icons.pause_circle,
                                  color: AppColorConstant.appWhite,
                                )
                              : const Icon(Icons.play_circle,
                                  color: AppColorConstant.appWhite)),
                      Container(
                        width: 50.px,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 4.px),
                        child: AppText(
                          attachmentViewModel!
                              .formatDuration(controller.duration),
                          fontSize: 10.px,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.px,
                ),
                AppTextFormField(
                  controller: attachmentViewModel!.textController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      attachmentViewModel!.audioPlayer.dispose();
                      attachmentViewModel!.audioButtonTap(controller);
                    },
                    icon: const Icon(Icons.send,
                        color: AppColorConstant.appYellow),
                  ),
                )
              ],
            ),
          ),
        ),
        if (DatabaseService.isLoading)
          AppLoader(
              widget:
                  AppText("${DatabaseService.downloadPercentage.toString()}%")),
      ],
    );
  }

  fileViews(controller, context, index) {
    switch (index) {
      case 0:
        {
          return photoShowView(controller, context);
        }

      case 1:
        {
          return videoShowView(controller, context);
        }

      case 2:
        {
          return documentShowView(controller, context);
        }

      case 3:
        {
          return audioShowView(controller, context);
        }
    }
  }

  fileViewIndex() {
    if (attachmentViewModel!.selectedImage.toString().contains(".jpg") ||
        attachmentViewModel!.selectedImage.toString().contains(".png")) {
      return 0;
    }
    if (attachmentViewModel!.selectedImage.toString().contains(".mp4")) {
      return 1;
    }
    if (attachmentViewModel!.selectedImage.toString().contains(".pdf") ||
        attachmentViewModel!.selectedImage.toString().contains(".doc") ||
        attachmentViewModel!.selectedImage.toString().contains("dotx")) {
      return 2;
    }
    if (attachmentViewModel!.selectedImage.toString().contains(".mp3")) {
      return 3;
    }
  }
}
