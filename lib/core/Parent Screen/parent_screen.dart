import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/features/Service/presentation/service_view.dart';
import 'package:healthandwellness/features/home/presentation/home.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';

import '../../features/calendar_report/presentation/calender_report.dart';
import '../../features/login/presentation/login.dart';
import '../utility/app_loader.dart';
import '../widget/bottom_nav_bar.dart';

class ParentScreen extends ConsumerStatefulWidget {
  const ParentScreen({super.key});

  @override
  ConsumerState<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends ConsumerState<ParentScreen> {
  final MainStore mainStore = Get.find<MainStore>();
  final Authenticator userRef = Get.find<Authenticator>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  final List<Widget> _pages = [Home(), ServiceView(), CalenderReport(), Home()];

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      child: GetBuilder<Authenticator>(
        init: userRef,
        autoRemove: false,
        builder: (context) {
          return Scaffold(
            bottomNavigationBar: userRef.state == null ? null : BottomNavbar(),
            body: Padding(
              padding: EdgeInsets.only(top: safePadding.top, bottom: safePadding.bottom, left: safePadding.left + 5, right: safePadding.right + 5),
              child: userRef.state == null ? Login() : Obx(() => _pages[mainStore.bottomNavBarIndex.value]),
            ),
          );
        },
      ),
      // ),
    );
  }
}
