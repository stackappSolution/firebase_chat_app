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

  @override
  Widget build(BuildContext context) {
    videoPlayerViewModel ?? (videoPlayerViewModel = VideoPlayerViewModel(this));
    return GetBuilder<ChatingPageController>(dispose: (state) {
      videoPlayerViewModel!.videoController!.dispose();
    },
      init: ChatingPageController(),
      initState: (state) {
        videoPlayerViewModel!.arguments = Get.arguments;

        logs(
            'url--------------> ${videoPlayerViewModel!.arguments['videoUrl']}');
        videoPlayerViewModel!.videoController =
            VideoPlayerController.networkUrl(Uri.parse(
                "https://d39dguljx616fo.cloudfront.net/public/0466ed02-6512-4065-8f3d-13ca84d4cf9c.mp4"));

        videoPlayerViewModel!.initializeVideoPlayer =
            videoPlayerViewModel!.videoController!.initialize();
        videoPlayerViewModel!.videoController!.setLooping(true);
      },
      builder: (controller) {
        return Scaffold(backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppbar(context),
          body: getBody(controller),
        );
      },
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText(videoPlayerViewModel!.arguments['receiverName'],color: Theme.of(context).colorScheme.primary),
    );
  }

  getBody(ChatingPageController controller) {
    return Stack(
      children: [
        SizedBox(
          child: FutureBuilder(
            future: videoPlayerViewModel!.initializeVideoPlayer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: Device.height * 0.70,
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
                color: AppColorConstant.appWhite,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
