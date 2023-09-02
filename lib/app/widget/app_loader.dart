import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/constant/color_constant.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: Device.height,
      width: Device.height,
      color: AppColorConstant.appWhite.withOpacity(0.9),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
