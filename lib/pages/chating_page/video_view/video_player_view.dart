import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/chating_page/video_view/video_player_view_model.dart';
import 'package:signal/service/database_service.dart';
import 'package:video_player/video_player.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../app/widget/app_text.dart';
import '../../../controller/video_player_controller.dart';
import '../../../service/network_connectivity.dart';

// ignore: must_be_immutable
class VideoPlayerView extends StatelessWidget {
  VideoPlayerViewModel? videoPlayerViewModel;
  VideosPlayerController? videosPlayerController;

  VideoPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    videoPlayerViewModel ?? (videoPlayerViewModel = VideoPlayerViewModel(this));

    return GetBuilder<VideosPlayerController>(
      init: VideosPlayerController(),
      dispose: (state) {
        //  controller!.player.dispose();
      },
      initState: (state) {
        NetworkConnectivity.checkConnectivity(context);
        videoPlayerViewModel!.argument = Get.arguments;
        videoPlayerViewModel!.videoFilePath =
            videoPlayerViewModel!.argument['video'];
        logs("parameter data---->${videoPlayerViewModel!.videoFilePath}");

        videoPlayerViewModel!.videoPlayerController =
            VideoPlayerController.networkUrl(
                Uri.parse(videoPlayerViewModel!.argument['video']));

        videoPlayerViewModel!.initializeVideoPlayer =
            videoPlayerViewModel!.videoPlayerController!.initialize();
        videoPlayerViewModel!.videoPlayerController!.setLooping(false);

        Future.delayed(
          const Duration(milliseconds: 200),
          () {
            final videosPlayerController = Get.find<VideosPlayerController>();
            videoPlayerViewModel!.fileSize(videosPlayerController,
                videoPlayerViewModel!.argument['video']);

            videoPlayerViewModel!.videoPlayerController!.addListener(() {
              videoPlayerViewModel!.sliderValue = videoPlayerViewModel!
                  .videoPlayerController!.value.position.inMilliseconds
                  .toDouble();
              logs("Slider Value ----> ${videoPlayerViewModel!.sliderValue}");
              videosPlayerController!.update();
            });
          },
        );
      },
      builder: (VideosPlayerController controller) {
        return WillPopScope(
          onWillPop: () async {
            videoPlayerViewModel!.stopVideoPlayback();
            return true;
          },
          child: SafeArea(
              child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: videoShowView(controller, context),
            appBar: getAppBar(),
          )),
        );
      },
    );
  }

  getAppBar() {
    return AppAppBar(
      leading: IconButton(
          onPressed: () {
            videoPlayerViewModel!.videoPlayerController.dispose();
            videoPlayerViewModel!.stopVideoPlayback();
            Get.back();
          },
          icon: const Icon(Icons.clear)),
    );
  }

  videoShowView(VideosPlayerController controller, BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          child: SingleChildScrollView(
            child: Column(children: [
              FutureBuilder(
                future: videoPlayerViewModel!.initializeVideoPlayer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AspectRatio(
                          aspectRatio: videoPlayerViewModel!
                              .videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(
                              videoPlayerViewModel!.videoPlayerController!),
                        ),
                        InkWell(
                          onTap: () {
                            if (videoPlayerViewModel!
                                .videoPlayerController!.value.isPlaying) {
                              videoPlayerViewModel!.videoPlayerController!
                                  .pause();
                            } else {
                              videoPlayerViewModel!.videoPlayerController!
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
                                    videoPlayerViewModel!.formatDuration(
                                        videoPlayerViewModel!
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
                                    value: videoPlayerViewModel!.sliderValue,
                                    onChanged: (value) {
                                      videoPlayerViewModel!.sliderValue = value;
                                      controller.update();
                                      videoPlayerViewModel!
                                          .videoPlayerController
                                          .seekTo(Duration(
                                              milliseconds: value.toInt()));

                                      controller.update();
                                      logs(
                                          "slider valuse  -- >${videoPlayerViewModel!.sliderValue}");
                                    },
                                    max: videoPlayerViewModel!
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
                                    child: (!videoPlayerViewModel!
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
                                      videoPlayerViewModel!.formatDuration(
                                          videoPlayerViewModel!
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
                      videoPlayerViewModel!.fileSizes.toString(),
                      color: AppColorConstant.darkSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ]),
          ),
        ),
        if (DatabaseService.isLoading) AppLoader(),
      ],
    );
  }
}
