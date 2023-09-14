import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/constant/color_constant.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.background.withOpacity(0.5),
          child: const Center(
              child: CircularProgressIndicator(
            color: AppColorConstant.appYellow,
          )),
        ));
  }
}
