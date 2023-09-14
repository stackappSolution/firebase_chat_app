import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/chating_page/attachment/attachment_view_model.dart';
import 'package:signal/service/database_service.dart';
import 'package:video_player/video_player.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../app/widget/app_text.dart';
import '../../../controller/acccount_controller.dart';

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
      initState: (state) {
        attachmentViewModel!.argument = Get.arguments;
        attachmentViewModel!.selectedImage =
            attachmentViewModel!.argument['image'];
        logs("parameter data---->${attachmentViewModel!.selectedImage}");

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
        if (attachmentViewModel!.selectedImage.toString().contains("mp4")) {
          attachmentViewModel!.isVideo = true;
          logs("file formate is video ----- >${attachmentViewModel!.isVideo}");
        } else {
          attachmentViewModel!.isVideo = false;
          controller.update();

          logs("file formate is video ----- >${attachmentViewModel!.isVideo}");
        }
        return WillPopScope(
          onWillPop: () async {
            attachmentViewModel!.stopVideoPlayback();
            return true;
          },
          child: SafeArea(
              child: Scaffold(
                  body: (!attachmentViewModel!.isVideo)
                      ? photoShowView(controller, context)
                      : videoShowView(controller, context))),
        );
      },
    );
  }

  photoShowView(AttachmentController controller, BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20.px),
          decoration: const BoxDecoration(color: AppColorConstant.appWhite),
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
            IconButton(
                onPressed: () async {
                  attachmentViewModel!.imageCrop(context, controller);
                },
                icon: const Icon(
                  Icons.crop,
                  color: AppColorConstant.appYellow,
                )),
            Padding(
              padding: EdgeInsets.only(top: 15.px),
              child: AppTextFormField(
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
        if (DatabaseService.isLoading) const AppLoader(),
      ],
    );
  }

  videoShowView(AttachmentController controller, BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20.px),
          decoration: const BoxDecoration(color: AppColorConstant.appWhite),
          child: Column(children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.clear))),
            Expanded(
              child: SizedBox(
                child: FutureBuilder(
                  future: attachmentViewModel!.initializeVideoPlayer,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 400.px,
                              child: AspectRatio(
                                aspectRatio: attachmentViewModel!
                                    .videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(attachmentViewModel!
                                    .videoPlayerController!),
                              ),
                            ),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: AppText(
                                      attachmentViewModel!.formatDuration(
                                          attachmentViewModel!
                                              .videoPlayerController
                                              .value
                                              .position),
                                      fontSize: 10.px,
                                    ),
                                  ),
                                  Slider(
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
                                  SizedBox(
                                    child: Padding(
                                      padding:  EdgeInsets.only(left: 5.px),
                                      child: AppText(
                                        attachmentViewModel!.formatDuration(
                                            attachmentViewModel!
                                                .videoPlayerController
                                                .value
                                                .duration),
                                        fontSize: 10.px,
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
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.px),
              child: AppTextFormField(
                suffixIcon: IconButton(
                  onPressed: () {
                    attachmentViewModel!.stopVideoPlayback();
                    attachmentViewModel!.videoButtonTap(controller);
                  },
                  icon:
                      const Icon(Icons.send, color: AppColorConstant.appYellow),
                ),
              ),
            )
          ]),
        ),
        if (DatabaseService.isLoading) const AppLoader(),
      ],
    );
  }
}
