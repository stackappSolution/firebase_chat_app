import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../constant/color_constant.dart';
import '../../widget/app_text.dart';

class ToastUtil {
  static void warningToast(
    String msg,
  ) {
    BotToast.showNotification(
      title: (_) => AppText(
        msg,
        fontSize: 12.px,
        color: AppColorConstant.red,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: AppColorConstant.appYellow,
      borderRadius: 6.px,
      duration: const Duration(seconds: 1),
      animationDuration: const Duration(milliseconds: 350),
    );
  }

  static void successToast(String msg) {
    BotToast.showNotification(
      title: (_) => Text(
        msg,
        style: TextStyle(
          color: AppColorConstant.appWhite,
          fontSize: 16.px,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.green,
      borderRadius: 15.0,
      duration: const Duration(seconds: 1),
      animationDuration: const Duration(milliseconds: 350),
    );
  }

  static void messageToast(String msg) {
    BotToast.showNotification(
      title: (_) => Text(
        msg,
        style: TextStyle(
          color: AppColorConstant.appWhite,
          fontSize: 16.px,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColorConstant.appYellow,
      borderRadius: 15.0,
      duration: const Duration(seconds: 1),
      animationDuration: const Duration(milliseconds: 350),
    );
  }
}
