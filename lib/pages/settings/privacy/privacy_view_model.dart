import 'dart:io';

import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:signal/pages/settings/privacy/privacy_screen.dart';

class PrivacyViewModel{


  PrivacyScreen? privacyScreen;
  List<String> blockedNumbers = [];


  Future<void> secureScreen() async {
    (Platform.isAndroid)
        ? await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE)
        : print('===>iOS');
  }

  PrivacyViewModel(this.privacyScreen);


}