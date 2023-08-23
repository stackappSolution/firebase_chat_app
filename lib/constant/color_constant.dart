import 'package:flutter/material.dart';

class AppColorConstant {
  static const Color appScaffold = Color(0xFFD8D6D9);
  static const Color appTransparent = Color(0x00000000);
  static const Color appWhite = Color(0xffFFFFFF);
  static const Color appBlack = Color(0xFF000000);
  static const Color offBlack = Color(0xFF525252);
  static const Color offBlackSend = Color(0xFF414141);
  static const Color appLightBlack = Color(0xFF5E5F60);
  static const Color appLightGrey = Color(0xFFF6F6F6);
  static const Color red= Color(0xFFdb1e1e);
  static const Color appTheme= Color(0xFFFE9532);
  static const Color appYellow = Color(0xFFFE9532);
  static const Color appYellowBorder = Color(0xFFFE9532);
  static const Color darkPrimary = Color(0xFF242424);
  static const Color darkSecondary = Color(0xFF949494);
  static const Color orange = Color(0xFFFF9800);
  static const Color chatOrange =  Color(0xFFFCD5A5);
  static const Color iconOrange =  Color(0xFFF6BE78);
  static const Color lightOrange = Color(0xFFFDC16E);
  static const Color purple = Color(0xFFAF57BE);
  static const Color blackOff = Color(0xFF696969);
  static const Color lightPurple = Color(0xFFEFE3F1);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFC2C2C2);
  static const Color blue = Color(0xFF2196F3);

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
