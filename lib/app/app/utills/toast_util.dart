import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Toast {
  void warningToast(String msg, Color color, {int? maxLine}) {
    BotToast.showNotification(
      title: (_) => Text(
        msg,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.px,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: (_) => Padding(
        padding: EdgeInsets.only(top: 8.px),
        child: Text(
          msg,
          style: TextStyle(color: Colors.white, fontSize: 13.px),
          maxLines: maxLine ?? 2,
        ),
      ),
      backgroundColor: color,
      borderRadius: 15,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(seconds: 1),
    );
  }

  static void successToast(String msg) {
    BotToast.showNotification(
      title: (_) => Text(
        msg,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.px,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.green,
      borderRadius: 15,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(seconds: 1),
    );
  }
}
