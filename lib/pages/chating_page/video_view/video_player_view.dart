import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/pages/chating_page/video_view/video_player_view_model.dart';
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
          body: getBody(controller),
          bottomNavigationBar: buildBottomBar(controller,context),
        );
      },
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText(videoPlayerViewModel!.arguments['receiverName'],
          color: Theme.of(context).colorScheme.primary),
    );
  }

  getBody(ChatingPageController controller) {
    return SizedBox(
      height: Device.height*0.75,
      child: Stack(
        children: [
          SizedBox(
            child: FutureBuilder(
              future: videoPlayerViewModel!.initializeVideoPlayer,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: Device.height * 0.75,
                      width: Device.width,
                      child: AspectRatio(
                        aspectRatio: videoPlayerViewModel!
                            .videoController!.value.aspectRatio,
                        child:
                            VideoPlayer(videoPlayerViewModel!.videoController!),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                if (videoPlayerViewModel!.videoController!.value.isPlaying) {
                  videoPlayerViewModel!.videoController!.pause();
                } else {
                  videoPlayerViewModel!.videoController!.play();
                }
                controller.update();
              },
              child: SizedBox(
                height: 70.px,
                width: 70.px,
                child: AppImageAsset(
                  image: videoPlayerViewModel!.videoController!.value.isPlaying
                      ? AppAsset.pause
                      : AppAsset.play,
                  color: AppColorConstant.appLightBlack,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBottomBar(ChatingPageController controller,BuildContext context) {
    return Container(color: AppColorConstant.appBlack.withOpacity(0.8),
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
