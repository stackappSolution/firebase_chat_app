import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/add_photo_controller.dart';
import 'package:signal/pages/edit_profile/add_photo_view_model.dart';

class AddPhotoScreen extends StatelessWidget {
  AddPhotoViewModel? addPhotoViewModel;

  AddPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    addPhotoViewModel ?? (addPhotoViewModel = AddPhotoViewModel(this));

    return GetBuilder<AddPhotoController>(init: AddPhotoController(),
      builder: (controller) {

        return SafeArea(
          child: Scaffold(
            body: Column(children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
              const CircleAvatar(
                radius: 100,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Container(alignment: Alignment.center,
                        height: 60.px,
                        width: 60.px,
                        decoration: BoxDecoration(color: AppColorConstant.yellowLight,
                            borderRadius: BorderRadius.all(
                          Radius.circular(15.px),
                        )),child: const AppImageAsset(image: AppAsset.camera,),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: 12.px),
                        child: AppText(StringConstant.camera,fontSize: 13.px,),
                      )
                    ],
                  )
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
