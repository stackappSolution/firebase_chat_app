import 'package:flutter/material.dart';

class AppColorConstant {
  static const Color appScaffold = Color(0xFFD8D6D9);
  static const Color appTransparent = Color(0x00000000);
  static const Color appWhite = Color(0xffFFFFFF);
  static const Color appBlack = Color(0xFF000000);
  static const Color appLightBlack = Color(0xFF5E5F60);
  static const Color lightGrey = Color(0xFFF6F6F6);
  static const Color appLightGrey = Color(0xFFF6F6F6);
  static const Color appTheme= Color(0xFFFE9532);
  static const Color orange = Colors.orange;
  static const Color lightOrange = Color(0xFFF6EDE1);

  static Color hex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<BoxShadow> appBoxShadow = [
    BoxShadow(
      offset: const Offset(1, 3),
      spreadRadius: 0.2,
      color: appLightBlack.withOpacity(0.2),
      blurRadius: 2,
    ),
  ];

  static List<BoxShadow> appDarkBoxShadow = [
    BoxShadow(
      offset: const Offset(0, 3),
      spreadRadius: 0.2,
      color: appWhite.withOpacity(0.2),
      blurRadius: 2,
    ),
  ];
}