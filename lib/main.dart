import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/routes/route_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app/utills/theme_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemeUtil.loadThemeMode();
  runApp(const MyApp());
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
            theme: ThemeData(useMaterial3: true),
            //theme: ThemeData.light(),
            darkTheme: ThemeData.light(),
            themeMode: ThemeUtil.selectedTheme,
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
          ),
        );
      },
    );
  }
}
