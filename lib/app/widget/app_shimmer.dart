import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerView extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;

  const ShimmerView(
      {Key? key, this.height, this.width, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:Colors.black12,
      highlightColor:Colors.white,
      child: Container(
        height: height ?? 40.px,
        width: width ?? 50.px,
        decoration: BoxDecoration(
          color:Colors.black12,
          borderRadius: BorderRadius.circular(borderRadius ?? 4.px),
        ),
      ),
    );
  }
}