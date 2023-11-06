import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/pages/splash/splash_screen.dart';
import 'package:signal/routes/app_navigation.dart';

import '../../routes/routes_helper.dart';
import '../../service/auth_service.dart';

class SplashViewModel {
  SplashScreen? splashScreen;
  String? phoneNumber;

  SplashViewModel(this.splashScreen) {
    getPermission();
    Future.delayed(
      Duration(seconds: 2),
      () {
        if (AuthService.auth.currentUser != null) {
          goToHomeScreen();
        } else {
          goToIntroPage();
        }
      },
    );
  }

  void redirect(int index) async {
    switch (index) {
      case 1:
        {
          logs("value--> 1");
          goToIntroPage();
        }
        break;
      case 2:
        {
          logs("value-->2");
          goToSignInPage();
        }
        break;
      case 3:
        {
          logs("value-->3");
          goToVerifyPage(phonenumber: 'phoneNo');
        }
        break;
      case 4:
        {
          logs("value-->4");
          goToProfilePage();
        }
        break;
      case 5:
        {
          logs("value-->5");
          goToHomeScreen();
        }
        break;
    }
  }

  Future<void> checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isUserRegistered = prefs.getBool('isUserRegistered') ?? false;

    if (isUserRegistered) {
      goToHomeScreen();
    } else {
      goToIntroPage();
    }
  }

  Future<void> getPermission() async {
    final PermissionStatus permissionStatus = await Permission.contacts.status;

    if (permissionStatus.isGranted) {
      fetchContacts();
    } else {
      final PermissionStatus requestResult =
          await Permission.contacts.request();

      if (requestResult.isGranted) {
        fetchContacts();
      } else {
        logs('Contacts permission denied');
      }
    }
  }

  void fetchContacts() async {
    logs("fetch contact entered");
    contacts = await ContactsService.getContacts();
    logs("saved contact length----->  ${contacts.length}");
  }
}
