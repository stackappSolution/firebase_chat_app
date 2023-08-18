import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/pages/edit_profile/edit_profile_screen.dart';
import 'package:signal/pages/intro_page/intro_page.dart';
import 'package:signal/routes/routes_helper.dart';
import 'app/app/utills/theme_util.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:signal/pages/profile/profile_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/pages/signin_pages/sign_in_page.dart';
import 'package:signal/pages/appearance/appearance_screen.dart';
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
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (BuildContext context, Orientation orientation, screenType) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: GetMaterialApp(
            title: 'Flutter matrimonial app',
            //theme: ThemeUtil.getAppTheme(context, ThemeUtil.isDark),
            //theme: ThemeData.light(),
           // darkTheme: ThemeData.dark(),
            themeMode: ThemeUtil.selectedTheme,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            debugShowCheckedModeBanner: false,
            home: ProfileScreen(),
            defaultTransition: Transition.fadeIn,
            // initialRoute: RouteHelper.getHomeScreen(),
            // getPages: RouteHelper.routes,
         //   initialRoute: RouteHelper.getIntroPage(),
            getPages: RouteHelper.routes,
          ),
        );
      },
    );
  }
}
