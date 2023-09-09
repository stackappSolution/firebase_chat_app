import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/notification_service.dart';
import 'app/app/utills/theme_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemeUtil.loadThemeMode();
  await NotificationService.instance.initializeNotification();
  NotificationService.instance.initialize();
  FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences.getInstance();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  runApp(const MyApp());
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
            initialRoute: (AuthService.auth.currentUser != null)
                ? RouteHelper.getHomeScreen()
                : RouteHelper.getIntroScreen(),
            getPages: RouteHelper.routes,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            themeMode: ThemeUtil.selectedTheme,
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
