

import 'package:get/get.dart';
import 'package:signal/controller/chat_profile_controller.dart';
import 'package:signal/pages/chats/chat_profile/chat_profile_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app/utills/app_utills.dart';

class ChatProfileViewModel{


  ChatProfileScreen? chatProfileScreen;
  ChatProfileController? controller;
  Map<String,dynamic> arguments= {};
  List<String> blockedNumbers=[];
  List<dynamic> addBlockNumbers = [];
  bool isBlockedByLoggedUser = false;
  List totalMembers = [];
  ChatProfileViewModel(this.chatProfileScreen){
    Future.delayed(const Duration(milliseconds: 1),() {
      controller=Get.find<ChatProfileController>();
    },);
  }


  Future<void> launchPhoneURL(String phoneNumber) async {
    final Uri url = Uri.parse('tel: $phoneNumber}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  totalMember(String numbers)
  {
    totalMembers = numbers.split("+");
    totalMembers.removeAt(0);
    logs("members list --- >  ${totalMembers}");

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