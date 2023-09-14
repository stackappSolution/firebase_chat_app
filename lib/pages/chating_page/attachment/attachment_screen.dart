import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/chating_page/attachment/attachment_view_model.dart';
import 'package:signal/service/database_service.dart';
import 'package:video_player/video_player.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../controller/acccount_controller.dart';

// ignore: must_be_immutable
class AttachmentScreen extends StatelessWidget {
  AttachmentViewModel? attachmentViewModel;

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
            VideoPlayerController.networkUrl(Uri.parse(
                "https://d39dguljx616fo.cloudfront.net/public/0466ed02-6512-4065-8f3d-13ca84d4cf9c.mp4"));

        attachmentViewModel!.initializeVideoPlayer =
            attachmentViewModel!.videoPlayerController!.initialize();
        attachmentViewModel!.videoPlayerController!.setLooping(true);
      },
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
              body: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20.px),
                decoration:
                    const BoxDecoration(color: AppColorConstant.appWhite),
                child: Column(children: [
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.clear))),
                  if (!attachmentViewModel!.selectedImage
                      .toString()
                      .contains("mp4"))
                    Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            child: AppImageAsset(
                                isFile: true,
                                image: attachmentViewModel!.selectedImage)))
                  else

                    SizedBox(height: double.infinity,
                      child: FutureBuilder(
                        future: attachmentViewModel!.initializeVideoPlayer,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: Device.height * 0.70,
                                width: Device.width,
                                child: AspectRatio(
                                  aspectRatio: attachmentViewModel!
                                      .videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(attachmentViewModel!
                                      .videoPlayerController!),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        if (attachmentViewModel!
                            .videoPlayerController!.value.isPlaying) {
                          attachmentViewModel!.videoPlayerController!.pause();
                        } else {
                          attachmentViewModel!.videoPlayerController!.play();
                        }
                        controller.update();
                      },
                      child: SizedBox(
                        height: 70.px,
                        width: 70.px,
                        child: AppImageAsset(
                          image: attachmentViewModel!
                                  .videoPlayerController!.value.isPlaying
                              ? AppAsset.logOut
                              : AppAsset.phone,
                          color: AppColorConstant.appWhite,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
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
                        onPressed: () =>
                            attachmentViewModel!.imageButtonTap(controller),
                        icon: const Icon(Icons.send,
                            color: AppColorConstant.appYellow),
                      ),
                    ),
                  )
                ]),
              ),
              if (DatabaseService.isLoading) const AppLoader(),
            ],
          )),
        );
      },
    );
  }
}
