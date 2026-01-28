import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthandwellness/features/test/presentation/count_ui.dart';

import 'app/mainstore.dart';
import 'app/routes.dart';
import 'core/Parent Screen/parent_screen.dart';
import 'features/login/presentation/login.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    MainStore mainStore = Get.put(MainStore());
    runApp(const MyApp());
  }, (error, stackTrace) async {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GetMaterialApp(
        title: 'Health and Wellness',
        theme: ThemeData(
          useMaterial3: true,
          useSystemColors: true,
          textTheme: GoogleFonts.monaSansTextTheme(ThemeData.light().textTheme),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade100),
        ),
        getPages: routes,
        home: ParentScreen(),
      ),
    );
  }
}
