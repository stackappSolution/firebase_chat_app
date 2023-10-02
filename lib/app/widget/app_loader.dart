import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:signal/constant/color_constant.dart';

class AppLoader extends StatelessWidget {
  Widget? widget;

  AppLoader({this.widget, super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.background.withOpacity(0.5),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: AppColorConstant.appYellow,
              ),
              widget ?? const SizedBox()
            ],
          )),
        ));
  }
}
