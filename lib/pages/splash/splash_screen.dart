import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/pages/splash/splash_view_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/auth_service.dart';

import '../../constant/color_constant.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
  SplashViewModel? splashViewModel;

  @override
  Widget build(BuildContext context) {
    splashViewModel ?? (splashViewModel = SplashViewModel(this));
    Timer(const Duration(seconds: 5), () {
      SharedPreferences.getInstance().then((prefs) {
        if (AuthService.auth.currentUser != null) {
          RouteHelper.getHomeScreen();
        } else if (AuthService.auth.currentUser?.phoneNumber?.isNotEmpty == true) {
          RouteHelper.getProfileScreen();
        } else {
          RouteHelper.getIntroScreen();
        }
      });
    });


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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