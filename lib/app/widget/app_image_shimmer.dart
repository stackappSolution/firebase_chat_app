import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/color_constant.dart';

class AppImageShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;

  const AppImageShimmer({Key? key, this.height, this.width, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.px),
      child: Shimmer.fromColors(
        baseColor: AppColorConstant.yellowLight,
        highlightColor: AppColorConstant.appWhite,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColorConstant.darkSecondary,
          ),
        ),
      ),
    );
  }
}
