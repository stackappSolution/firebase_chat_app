import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:signal/pages/profile/profile_screen.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/pages/signin_pages/sign_in_page.dart';
import 'package:signal/routes/route_helper.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
            home: ChatingPage(),
            defaultTransition: Transition.fadeIn,
            // initialRoute: RouteHelper.getHomeScreen(),
            // getPages: RouteHelper.routes,
           // initialRoute: RouteHelper.getHomeScreen(),
            // home: const LoginScreen(),
            // initialRoute: RouteHelper.getHomeScreen(),
            // getPages: RouteHelper.routes,
            // getPages: RouteHelper.routes,
            // initialRoute: RouteHelper.getSignInPage(),
            //  home: SignInPage(),

          ),
        );
      },
    );
  }
}
