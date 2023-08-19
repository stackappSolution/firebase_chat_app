import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/color_constant.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final Widget? title;
  final List<Widget>? actions;
  final ShapeBorder? shape;
  final Widget? leading;
  final double? leadingWidth;
  final bool? centerTitle;

  const AppAppBar({
    Key? key,
    this.backgroundColor,
    this.title,
    this.actions,
    this.shape,
    this.leading,
    this.leadingWidth,
    this.centerTitle,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: false,
      scrolledUnderElevation: 0,
      leading: leading,
      shape: shape,
      leadingWidth: leadingWidth,
      backgroundColor: AppColorConstant.appWhite,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
    );
  }
}
