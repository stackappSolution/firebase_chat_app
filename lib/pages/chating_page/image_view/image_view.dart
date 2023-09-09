import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/controller/chating_page_controller.dart';
import 'package:signal/pages/chating_page/image_view/image_view_model.dart';

// ignore: must_be_immutable
class ImageView extends StatelessWidget {
  ImageView({Key? key}) : super(key: key);

  ImageViewModel? imageViewModel;
  ChatingPageController? controller;

  @override
  Widget build(BuildContext context) {
    imageViewModel ?? (imageViewModel = ImageViewModel(this));
    return GetBuilder<ChatingPageController>(
      initState: (state) {
        imageViewModel!.arguments = Get.arguments;
        Future.delayed(const Duration(milliseconds: 10),() {
          controller= Get.find<ChatingPageController>();
        },);


        logs('image------------> ${imageViewModel!.arguments['image']}');
        imageViewModel!.imageUrl= imageViewModel!.arguments['image'];


      },
      init: ChatingPageController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: getBody(context),
          appBar: getAppbar(context),
        );
      },
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText(imageViewModel!.arguments['name']),
    );
  }

  getBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(5.px),
          height: 350.px,
          width: double.infinity,
          child: PhotoView(minScale: PhotoViewComputedScale.contained * 1.0,
              maxScale: PhotoViewComputedScale.covered * 0.8,
              backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
              imageProvider: NetworkImage(imageViewModel!.imageUrl!)),
        )
      ],
    );
  }




}


