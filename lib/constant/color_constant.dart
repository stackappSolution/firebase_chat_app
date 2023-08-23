import 'package:flutter/material.dart';

class AppColorConstant {
  static const Color appTransparent = Color(0x00000000);
  static const Color appWhite = Color(0xffFFFFFF);
  static const Color appBlack = Color(0xFF000000);
  static const Color offBlack = Color(0xFF525252);
  static const Color offBlackSend = Color(0xFF414141);
  static const Color appLightBlack = Color(0xFF5E5F60);
  static const Color appLightGrey = Color(0xFFF6F6F6);
  static const Color red = Color(0xFFdb1e1e);
  static const Color appYellowBorder = Color(0xFFFE9532);
  static const Color lightOrange = Color(0xFFF6EDE1);
  static const Color chatOrange = Color(0xFFFCD5A5);
  static const Color iconOrange = Color(0xFFF6BE78);
  static const Color purple = Color(0xFFAF57BE);
  static const Color lightpurple = Color(0xFFEFE3F1);
  static const Color blackOff = Color(0xFF4B4B4B);
  static const Color darkPrimary = Color(0xFF242424);
  static const Color darkSecondary = Color(0xFF949494);
  static const Color appYellow = Color(0xFFf69533);
  static const Color yellowLight = Color(0xFFfce9d4);
  static const Color grey = Color(0xFF808080);
  static const Color blue = Color(0xFF0000FF);
  static const Color lightPurple = Color(0xFFEFE3F1);

  // static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFC2C2C2);

  // static const Color blue = Color(0xFF2196F3);

  static const Color darkBlue = Color(0xFF2e5ef5);
  static const Color darkPink = Color(0xFFd4153e);
  static const Color darkOrange = Color(0xFFcb3f0e);
  static const Color yellowGrey = Color(0xFF706858);
  static const Color darkGreen = Color(0xFF377747);
  static const Color lightGreen = Color(0xFF098664);
  static const Color teal = Color(0xFF007c93 );
  static const Color lightSky = Color(0xFF2f6ba4 );
  static const Color appPurple = Color(0xFF6158cb);
  static const Color pinkPurple = Color(0xFF9d30cb);
  static const Color greyPink = Color(0xFF92606b);
  static const Color appGrey = Color(0xFF71707f);
  static const Color extraDarkOrange = Color(0xFF8d2402);
  static const Color extraLight = Color(0xFFc25702);
  static const Color darkGrey = Color(0xFF464458);
  static const Color darkPurple = Color(0xFF7335c1);
  static const Color pink = Color(0xFFbe478d);
  static const Color green = Color(0xFF026d4b);
  static const Color extraLightGreen = Color(0xFF169b73);
  static const Color extraLightPurple = Color(0xFF6966a2);
  static const Color extraDarkSky = Color(0xFF0d65b7);
  static const Color extraLightSky = Color(0xFF3d7eba);


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
