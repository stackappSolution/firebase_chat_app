import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';

import '../app/widget/app_alert_dialog.dart';
import '../app/widget/app_button.dart';
import '../app/widget/app_text.dart';
import '../constant/color_constant.dart';

class NetworkConnectivity {
  static bool isOnline = false;

  NetworkConnectivity._();

  static final _instance = NetworkConnectivity._();

  static NetworkConnectivity get instance => _instance;
  static final networkConnectivity = Connectivity();
  static final controller = StreamController.broadcast();
  static String status = "";
  static bool isConnected = false;
  Map source = {ConnectivityResult.none: false};

  Stream get myStream => controller.stream;

  static void initialise() async {
    ConnectivityResult result = await networkConnectivity.checkConnectivity();
    checkStatus(result);
    networkConnectivity.onConnectivityChanged.listen((result) {
      logs('Connectivity mode ---->$result');
      checkStatus(result);
    });
  }

  static checkStatus(ConnectivityResult result) async {
    isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  static void checkConnectivity(context) {
    initialise();
    NetworkConnectivity.instance.myStream.listen((source) {
      source = source;
      logs('source $source');
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          status =
              source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          isConnected = true;
          break;
        case ConnectivityResult.wifi:
          status = source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          isConnected = true;
          break;
        case ConnectivityResult.none:
        default:
          isConnected = false;
          status = 'Offline';
      }
      (isConnected == false)
          ? showDialog(
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.all(20.px),
                  child: AppAlertDialog(
                    shape: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.px)),
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "Network Error",
                            fontWeight: FontWeight.w500,
                            fontSize: 22.px,
                          ),
                          AppText(
                            "\nSorry, there was a network error. Please check your internet connection and try again. If the problem persists, contact your network administrator or service provider for assistance. We apologize for any inconvenience.",
                            fontSize: 15.px,
                            textAlign: TextAlign.justify,
                          )
                        ]),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.px, bottom: 10.px),
                        child: AppButton(
                          onTap: () {
                            Get.back();
                          },
                          fontColor: AppColorConstant.appWhite,
                          string: "Back",
                          fontSize: 20,
                          borderRadius: BorderRadius.circular(15),
                          height: 40,
                          color: AppColorConstant.appYellow,
                          stringChild: false,
                          width: 100,
                        ),
                      )
                    ],
                    insetPadding: EdgeInsets.zero,
                  ),
                );
              },
            )
          : null;
    });
  }

  void disposeStream() => controller.close();
}
