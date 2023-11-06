import 'dart:io';

import 'package:signal/pages/invite/invite_member_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteViewModel {
  InviteMemberScreen? inviteMemberScreen;
  Map<String, dynamic> parameter = {};

  InviteViewModel(this.inviteMemberScreen);

  void inviteFriends() async {
    if (Platform.isAndroid) {
      String uri =
          'sms:${parameter['phoneNo']}?body=${Uri.encodeComponent("Lets switch to signal: \n http://signal.org/install")}';
      await launchUrl(Uri.parse(uri));
    } else if (Platform.isIOS) {
      String uri =
          'sms:${parameter['phoneNo']}&body=${Uri.encodeComponent("Lets switch to signal: \n http://signal.org/install")}';
      await launchUrl(Uri.parse(uri));
    }
  }
}
