import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/features/Service/presentation/service_view.dart';
import 'package:healthandwellness/features/home/presentation/home.dart';
import 'package:healthandwellness/features/login/repository/user_notifier.dart';

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
  final UserNotifier userRef = Get.find<UserNotifier>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  final List<Widget> _pages = [Home(), ServiceView(), ServiceView(), Home()];

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      child: GetBuilder<UserNotifier>(
        init: userRef,
        autoRemove: false,
        builder: (context) {
          return Scaffold(
            bottomNavigationBar: userRef.state == null ? null : BottomNavbar(),
            body: Padding(
              padding: EdgeInsets.only(top: safePadding.top, bottom: safePadding.bottom, left: safePadding.left + 5, right: safePadding.right + 5),
              child: userRef.state == null ? Login() : Obx(() => IndexedStack(index: mainStore.bottomNavBarIndex.value, children: _pages)),
            ),
          );
        },
      ),
      // ),
    );
  }
}
