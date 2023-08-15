import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/page/profile/profile_screen.dart';
import 'package:signal/routes/routes_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return ResponsiveSizer(
      builder: (BuildContext context, Orientation orientation, screenType) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: GetMaterialApp(
            title: 'Flutter matrimonial app',
            theme: ThemeData(useMaterial3: true),
            debugShowCheckedModeBanner: false,
            home: ProfileScreen(),
            defaultTransition: Transition.fadeIn,
            initialRoute: RouteHelper.getHomeScreen(),
            getPages: RouteHelper.routes,
            // home: const LoginScreen(),
          ),
        );
      },
    );
  }
}
