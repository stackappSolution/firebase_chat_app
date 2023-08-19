import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'app/app/utills/theme_util.dart';
import 'package:signal/pages/chating_page/chating_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemeUtil.loadThemeMode();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (BuildContext context, Orientation orientation, screenType) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: const GetMaterialApp(
            title: 'Flutter matrimonial app',
            //theme: ThemeUtil.getAppTheme(context, ThemeUtil.isDark),
            //theme: ThemeData.light(),
            // darkTheme: ThemeData.dark(),
            //  themeMode: ThemeUtil.selectedTheme,
            //  theme: Themes.light,
            //  darkTheme: Themes.dark,
            debugShowCheckedModeBanner: false,
            home: ChatingPage(),
            // defaultTransition: Transition.fadeIn,
            // initialRoute: RouteHelper.getHomeScreen(),
            // getPages: RouteHelper.routes,
            // defaultTransition: Transition.fadeIn,
            // initialRoute: RouteHelper.getIntroPage(),
            // getPages: RouteHelper.routes,
          ),
        );
      },
    );
  }
}
