import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/pages/appearance/appearance_screen.dart';

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
            theme: Themes.light,
            darkTheme: Themes.dark,
            debugShowCheckedModeBanner: false,
            home: AppearanceScreen(),
            defaultTransition: Transition.fadeIn,
            // initialRoute: RouteHelper.getHomeScreen(),
            // getPages: RouteHelper.routes,
          ),
        );
      },
    );
  }
}
