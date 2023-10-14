import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/notification_service.dart';
import 'app/app/utills/theme_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/generated/l10n.dart';

import 'constant/color_constant.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemeUtil.loadThemeMode();
  await NotificationService.instance.initializeNotification();
  NotificationService.instance.initialize();
  SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness:(ThemeUtil.isDark)?Brightness.light:Brightness.dark,
    statusBarColor: (ThemeUtil.isDark)
        ? AppColorConstant.darkPrimary
        : AppColorConstant.appWhite,
    statusBarBrightness:
    (ThemeUtil.isDark) ? Brightness.light : Brightness.dark,
  ));
  String? token = await FirebaseMessaging.instance.getToken();
  logs('Token---------------------> $token');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  bool get isProfileCompleted => false;

  @override
  Widget build(BuildContext context) {
    Locale? locale;
    return ResponsiveSizer(
      builder: (BuildContext context, Orientation orientation, screenType) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: GetMaterialApp(
            locale: locale,
            title: 'Flutter matrimonial app',
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.fadeIn,
            initialRoute:RouteHelper.getSplashScreen(),
            getPages: RouteHelper.routes,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            themeMode: ThemeUtil.selectedTheme,
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],

            localizationsDelegates:  const [
              S.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          ),
        );
      },
    );
  }
}
