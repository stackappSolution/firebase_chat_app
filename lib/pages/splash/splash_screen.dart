import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/pages/splash/splash_view_model.dart';

import '../../constant/color_constant.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
  SplashViewModel? splashViewModel;

  @override
  Widget build(BuildContext context) {
    splashViewModel ?? (splashViewModel = SplashViewModel(this));
    Timer(const Duration(seconds: 5), () {
     Get.toNamed('/intro');
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(decoration: const BoxDecoration(gradient: LinearGradient(
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