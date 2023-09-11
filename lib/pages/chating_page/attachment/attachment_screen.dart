import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/chating_page/attachment/attachment_view_model.dart';

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
                        onPressed: () =>
                            attachmentViewModel!.imageButtonTap(controller),
                        icon: const Icon(Icons.send,
                            color: AppColorConstant.appYellow),
                      ),
                    ),
                  )
                ]),
              ),
              if(attachmentViewModel!.isLoading)
                const AppLoader(),
            ],
          )),
        );
      },
    );
  }
}
