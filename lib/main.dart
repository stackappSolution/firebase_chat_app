import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/pages/intro_page/intro_page.dart';
import 'package:signal/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signal/routes/routes_helper.dart';
import 'app/app/utills/theme_util.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemeUtil.loadThemeMode();
  runApp(DevicePreview(
      enabled: true,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => const MyApp()
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
            // themeMode: ThemeUtil.selectedTheme,
            // theme: Themes.light,
            // darkTheme: Themes.dark,
            debugShowCheckedModeBanner: false,
            home: IntroPage(),
            defaultTransition: Transition.fadeIn,
            initialRoute: RouteHelper.getIntroPage(),
            getPages: RouteHelper.routes,
           // darkTheme: ThemeData.light(),
          //  themeMode: ThemeUtil.selectedTheme,
            theme: Themes.light,
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.fadeIn,
            initialRoute: RouteHelper.getHomeScreen(),
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
