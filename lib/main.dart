import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'app/app/utills/theme_util.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/edit_profile/edit_profile_screen.dart';
import 'package:signal/pages/intro_page/intro_page.dart';
import 'package:signal/pages/settings/settings_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'app/app/utills/theme_util.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:signal/pages/profile/profile_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/pages/signin_pages/sign_in_page.dart';
import 'package:signal/pages/appearance/appearance_screen.dart';
import 'app/app/utills/theme_util.dart';
import 'package:signal/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signal/routes/routes_helper.dart';
import 'app/app/utills/theme_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemeUtil.loadThemeMode();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //systemNavigationBarColor: AppColorConstant.appWhite, // navigation bar color
    statusBarColor: (ThemeUtil.isDark)
        ? AppColorConstant.darkPrimary
        : AppColorConstant.appWhite,
    statusBarBrightness:
        (ThemeUtil.isDark) ? Brightness.dark : Brightness.light,
  ));
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            debugShowCheckedModeBanner: false,
            home: IntroPage(),
            themeMode: ThemeUtil.selectedTheme,
            defaultTransition: Transition.fadeIn,
            getPages: RouteHelper.routes,
            localizationsDelegates: const [
              S.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,

            // initialRoute: RouteHelper.getHomeScreen(),
            // home: const LoginScreen(),
            // initialRoute: RouteHelper.getHomeScreen(),
            // getPages: RouteHelper.routes,
            // getPages: RouteHelper.routes,
            // initialRoute: RouteHelper.getSignInPage(),
            //  home: SignInPage(),

            // initialRoute: RouteHelper.getHomeScreen(),
            // getPages: RouteHelper.routes,
            // initialRoute: RouteHelper.getSignInPage(),

            // getPages: RouteHelper.routes,
          ),
        );
      },
    );
  }
}
