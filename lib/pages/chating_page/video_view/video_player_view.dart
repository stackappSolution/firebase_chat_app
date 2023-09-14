import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/pages/chating_page/video_view/video_player_view_model.dart';
import 'package:signal/service/database_service.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatelessWidget {
  VideoPlayerView({Key? key}) : super(key: key);

  VideoPlayerViewModel? videoPlayerViewModel;
  ChatingPageController? controller;

  @override
  Widget build(BuildContext context) {
    videoPlayerViewModel ?? (videoPlayerViewModel = VideoPlayerViewModel(this));
    return GetBuilder<ChatingPageController>(
      dispose: (state) {
        videoPlayerViewModel!.videoController!.dispose();
      },
      init: ChatingPageController(),
      initState: (state) {
        Future.delayed(
          const Duration(milliseconds: 100),
          () {
            controller = Get.find<ChatingPageController>();
            videoPlayerViewModel!.arguments = Get.arguments;

            logs(
                'url--------------> ${videoPlayerViewModel!.arguments['videoUrl']}');
            videoPlayerViewModel!.videoController =
                VideoPlayerController.network(
                    videoPlayerViewModel!.arguments['videoUrl']);
            videoPlayerViewModel!.initializeVideoPlayer =
                videoPlayerViewModel!.videoController!.initialize();

            videoPlayerViewModel!.videoController!.addListener(() {
              videoPlayerViewModel!.videoPlayerValue = videoPlayerViewModel!
                  .videoController!.value.position.inMilliseconds
                  .toDouble();
              controller!.update();
            });
          },
        );
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppbar(context),
          body: videoShowView(controller,context),
        //  bottomNavigationBar: buildBottomBar(controller, context),
        );
      },
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText(videoPlayerViewModel!.arguments['receiverName'] ?? '',
          color: Theme.of(context).colorScheme.primary),
    );
  }

  videoShowView(ChatingPageController controller, BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20.px),
          decoration:  BoxDecoration(color: Theme.of(context).colorScheme.background),
          child: Column(children: [

            Expanded(
              child: SizedBox(
                child: FutureBuilder(
                  future: videoPlayerViewModel!.initializeVideoPlayer,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 500.px,
                              child: AspectRatio(
                                aspectRatio: videoPlayerViewModel!
                                    .videoController!.value.aspectRatio,
                                child: VideoPlayer(
                                    videoPlayerViewModel!.videoController!),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              if (videoPlayerViewModel!
                                  .videoController!.value.isPlaying) {
                                videoPlayerViewModel!.videoController!.pause();
                              } else {
                                videoPlayerViewModel!.videoController!.play();
                                controller.update();
                              }
                              controller.update();
                            },

                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: AppText(
                                      videoPlayerViewModel!.formatDuration(
                                          videoPlayerViewModel!
                                              .videoController!.value.position),
                                      fontSize: 10.px,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),

                                  Slider(
                                    activeColor: AppColorConstant.appYellow,
                                    value: videoPlayerViewModel!.sliderValue,
                                    onChanged: (value) {
                                      videoPlayerViewModel!.sliderValue = value;
                                      controller.update();
                                      videoPlayerViewModel!.videoController!
                                          .seekTo(Duration(
                                              milliseconds: value.toInt()));
                                      controller.update();
                                      logs(
                                          "slider valuse  -- >${videoPlayerViewModel!.sliderValue}");
                                    },
                                    max: videoPlayerViewModel!.videoController!
                                        .value.duration.inMilliseconds
                                        .toDouble(),
                                  ),
                                  SizedBox(
                                      height: 30.px,
                                      width: 30.px,
                                      child: (!videoPlayerViewModel!
                                              .videoController!.value.isPlaying)
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
                                      padding: EdgeInsets.only(left: 5.px),
                                      child: AppText(
                                        videoPlayerViewModel!.formatDuration(
                                            videoPlayerViewModel!
                                                .videoController!
                                                .value
                                                .duration),
                                        fontSize: 10.px,
                                        color: Theme.of(context).colorScheme.primary,
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
          ]),
        ),
        if (DatabaseService.isLoading) const AppLoader(),
      ],
    );
  }

  buildBottomBar(ChatingPageController controller, BuildContext context) {
    return Container(
      color: AppColorConstant.appBlack.withOpacity(0.8),
      height: 80.px,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: AppColorConstant.appWhite,
          thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 8.px, disabledThumbRadius: 8.px),
          thumbColor: AppColorConstant.appWhite,
        ),
        child: Slider(
          value: videoPlayerViewModel!.videoPlayerValue,
          min: 0.0,
          max: videoPlayerViewModel!
              .videoController!.value.duration.inMilliseconds
              .toDouble(),
          onChanged: (value) {
            videoPlayerViewModel!.videoPlayerValue = value;
            controller.update();

            videoPlayerViewModel!.videoController!
                .seekTo(Duration(milliseconds: value.toInt()));
            controller.update();
          },
        ),
      ),
    );
  }
}
