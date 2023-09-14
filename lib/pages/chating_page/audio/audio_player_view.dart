import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/date_formation.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/chating_page_controller.dart';

class AudioPlayerView extends StatelessWidget {
  final String message;

  AudioPlayerView({Key? key, required this.message}) : super(key: key);

  ChatingPageController? controller;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatingPageController>(
      init: ChatingPageController(),
      initState: (state) {
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            controller = Get.find<ChatingPageController>();
          },
        );
      },
      builder: (controller) {
        return Container(
          width: 265.px,
          margin: EdgeInsets.all(8.px),
          height: 45.px,
          decoration: BoxDecoration(
              color: AppColorConstant.appGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.px)),
          child: Row(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColorConstant.appBlack,
                  thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 8.px, disabledThumbRadius: 8.px),
                ),
                child: SizedBox(
                  width: 150.px,
                  child: Slider(
                    activeColor: AppColorConstant.appBlack,
                    min: 0,
                    max: controller.duration.inSeconds.toDouble(),
                    value: controller.position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      controller.position = Duration(seconds: value.toInt());
                      await controller.player.seek(controller.position);
                      await controller.player.resume();
                      controller.update();

                    },
                  ),
                ),
              ),
              AppText(
                DateFormation().formatTime(controller.position),
                color: AppColorConstant.appBlack,
              ),
              IconButton(
                  onPressed: () async {
                    if (controller.isPlay.value) {
                      await controller.player.pause();
                    } else {
                      UrlSource audio = UrlSource(message);
                      await controller.player.play(audio);
                      logs('audio-----------> $audio');
                    }
                    controller.update();
                  },
                  icon: (controller.isPlay.value)
                      ? const Icon(
                          Icons.pause_circle,
                          color: AppColorConstant.appBlack,
                        )
                      : const Icon(Icons.play_circle,
                          color: AppColorConstant.appBlack)),
            ],
          ),
        );
      },
    );
  }
}
