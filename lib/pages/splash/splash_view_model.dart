import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/pages/splash/splash_screen.dart';
import 'package:signal/routes/app_navigation.dart';

class SplashViewModel {
  SplashScreen? splashScreen;
  String? phoneNumber;
  String? messaging;

  SplashViewModel(this.splashScreen);

  redirect(int index) async {
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
}