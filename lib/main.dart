import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthandwellness/core/Binding/init_binding.dart';

import 'app/mainstore.dart';
import 'app/routes.dart';
import 'core/utility/firebase_service.dart';
import 'core/utility/helper.dart';
import 'features/login/repository/authenticator.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    MainStore mainStore = Get.put(MainStore());
    Get.put(FB(), permanent: true);
    Get.put(Authenticator(), permanent: true);
    // Get.put(AppLoaderController(), permanent: true);
    final auth = Get.find<Authenticator>();
    try {
      await auth.checkIfUserLogin();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
    // Future(() {
    //   try {
    //     loaderController.startLoading();
    //     user.checkIfUserLogin().whenComplete(() {
    //       loaderController.stopLoading();
    //     });
    //   } catch (e) {
    //     showAlert("$e", AlertType.error);
    //   }
    // });

    runApp(MyApp());
  }, (error, stackTrace) async {});
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final mainStore = Get.find<MainStore>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'Health and Wellness',
        theme: ThemeData(
          // scaffoldBackgroundColor: Color(0xfff8fdf8),
          scaffoldBackgroundColor: mainStore.theme.value.BackgroundColor,
          appBarTheme: AppBarThemeData(
            leadingWidth: 50,
            backgroundColor: mainStore.theme.value.BottomNavColor,
            iconTheme: IconThemeData(color: mainStore.theme.value.BackgroundShadeColor, size: 20),
            titleTextStyle: TextStyle(color: mainStore.theme.value.BackgroundShadeColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          bottomAppBarTheme: BottomAppBarThemeData(color: mainStore.theme.value.BottomNavColor),
          useMaterial3: true,
          useSystemColors: true,
          navigationBarTheme: NavigationBarThemeData(backgroundColor: mainStore.theme.value.HeadColor),
          textTheme: GoogleFonts.monaSansTextTheme(ThemeData.light().textTheme),
          colorScheme: ColorScheme.fromSeed(seedColor: mainStore.theme.value.BackgroundColor),
        ),
        initialRoute: '/',
        getPages: routes,
        initialBinding: InitBindings(),
      ),
    );
  }
}
