

import 'package:get/get.dart';
import 'package:signal/controller/chat_profile_controller.dart';
import 'package:signal/pages/chats/chat_profile/chat_profile_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatProfileViewModel{


  ChatProfileScreen? chatProfileScreen;
  ChatProfileController? controller;

  Map<String,dynamic> arguments= {};
  List<dynamic> blockedNumbers=[];
  List<dynamic> addBlockNumbers = [];
  ChatProfileViewModel(this.chatProfileScreen){
    Future.delayed(const Duration(milliseconds: 1),() {
      controller=Get.find<ChatProfileController>();
    },);
  }


  launchPhoneURL(String phoneNumber) async {
    final Uri url = Uri.parse('tel: $phoneNumber}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  mainTap(index) {
    switch (index) {
      case 1:
        {}
        break;
      case 2:
        {
          Get.toNamed(RouteHelper.getChatColorWallpaperScreen());
        }
        break;
      case 3:
        {

        }
        break;
      case 4:
        {

        }
        break;
      case 5:
        {

        }
        break;
    }
  }



}