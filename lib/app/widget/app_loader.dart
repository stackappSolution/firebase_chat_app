import 'package:flutter/material.dart';
import 'package:signal/constant/color_constant.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColorConstant.appWhite.withOpacity(0.9),
      child: const Center(child: CircularProgressIndicator(color: AppColorConstant.appYellow,)),
    );
  }
}
