import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:signal/routes/routes_helper.dart';

class LinkService{

  Future<void>initialLink() async{
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    try {
      if(initialLink == null)  return;
      handleDeepLink(initialLink.link.path);
    } catch (e) {
      print('Errrrrorrrrrrr------->');
    }
  }
  Future<void>handleDeepLink(String path) async {
    print('Navigation: $path');
    switch (path) {
      case 'donate':
        Get.toNamed(RouteHelper.getDonateScreen());
        break;
      case 'link':
        Get.toNamed(RouteHelper.getLinkScreen());
        break;
      case 'profile':
        Get.toNamed(RouteHelper.getProfileScreen());
        break;
      default:
        Get.toNamed(RouteHelper.getNewMessageScreen());
        null;
    }
  }

}
