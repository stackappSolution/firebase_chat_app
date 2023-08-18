import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/pages/intro_page/intro_page.dart';
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
            theme: ThemeData(useMaterial3: true),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeUtil.selectedTheme,
            debugShowCheckedModeBanner: false,
            home: IntroPage(),
            defaultTransition: Transition.fadeIn,
            initialRoute: RouteHelper.getIntroPage(),
            getPages: RouteHelper.routes,
          ),
        );
      },
    );
  }
}
