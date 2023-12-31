import 'package:flutter/material.dart';


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
      // ignore: deprecated_member_use
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0.0,
      scrolledUnderElevation: 0,
      leading: leading,
      shape: shape,
      leadingWidth: leadingWidth,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
    );
  }
}
