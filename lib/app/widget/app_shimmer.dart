import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/color_constant.dart';

class AppShimmerView extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;

  const AppShimmerView({Key? key, this.height, this.width, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.px),
      child: Shimmer.fromColors(
        baseColor: AppColorConstant.yellowLight,
        highlightColor: AppColorConstant.appWhite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30.px,
            ),
            SizedBox(
              width: 20.px,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10.px,
                  width: 200.px,
                  color: AppColorConstant.yellowLight,
                ),
                SizedBox(height: 10.px),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.px)),
                    color: AppColorConstant.darkSecondary,
                  ),
                  height: 10.px,
                  width: 150.px,
                ),
                SizedBox(height: 10.px),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.px)),
                    color: AppColorConstant.darkSecondary,
                  ),
                  height: 10.px,
                  width: 100.px,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
