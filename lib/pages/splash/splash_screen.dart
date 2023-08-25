import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/constant/app_asset.dart';

import '../../constant/color_constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
     Get.toNamed('/intro');
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(decoration: const BoxDecoration(   gradient: LinearGradient(
          colors: [AppColorConstant.lightOrange,AppColorConstant.appWhite, AppColorConstant.appWhite, AppColorConstant.lightOrange],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
        child: Center(
          child: AppImageAsset(image: AppAsset.splash, height: 70.px, width: 70.px),
        ),
      ),
    );
  }
}