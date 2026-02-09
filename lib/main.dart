import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthandwellness/core/Binding/init_binding.dart';

import 'app/mainstore.dart';
import 'app/routes.dart';
import 'core/utility/app_loader.dart';
import 'core/utility/firebase_service.dart';
import 'features/login/repository/authenticator.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    MainStore mainStore = Get.put(MainStore());
    Get.put(FB(), permanent: true);
    Get.put(Authenticator(), permanent: true);
    Get.put(AppLoaderController(), permanent: true);
    runApp(const MyApp());
  }, (error, stackTrace) async {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Health and Wellness',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff8fdf8),
        appBarTheme: AppBarThemeData(backgroundColor: Colors.green.shade300),
        useMaterial3: true,
        useSystemColors: true,
        textTheme: GoogleFonts.monaSansTextTheme(ThemeData.light().textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade100),
      ),
      initialRoute: '/',
      getPages: routes,
      initialBinding: InitBindings(),
    );
  }
}
