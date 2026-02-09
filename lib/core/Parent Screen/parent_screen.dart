import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/widget/bottom_nav_bar_trainer.dart';
import 'package:healthandwellness/features/Service/presentation/service_view.dart';
import 'package:healthandwellness/features/home/presentation/home.dart';
import 'package:healthandwellness/features/home/presentation/trainer_home.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';

import '../../features/attendance/attendance.dart';
import '../../features/calendar_report/presentation/calender_report.dart';
import '../../features/login/presentation/login.dart';
import '../utility/app_loader.dart';
import '../widget/bottom_nav_bar.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  final MainStore mainStore = Get.find<MainStore>();
  final Authenticator userRef = Get.find<Authenticator>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  final List<Widget> _pages = [Home(), ServiceView(), CalenderReport(), Home()];
  final List<Widget> _trainerPages = [HomeTrainer(), ServiceView(), Attendance(), HomeTrainer()];

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      // try {
      //   await mainStore.fetchUserTypes();
      // } catch (e) {
      //   showAlert("$e", AlertType.error);
      // }
    });
    super.initState();
  }

  Widget getBottomNavBar() {
    if (userRef.state?.userType == UserType.trainer) {
      return BottomNavbarTrainer();
    }
    return BottomNavbar();
  }

  List<Widget> getPages() {
    if (userRef.state?.userType == UserType.trainer) {
      return _trainerPages;
    }
    return _pages;
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      child: GetBuilder<Authenticator>(
        init: userRef,
        autoRemove: false,
        builder: (context) {
          return Scaffold(
            bottomNavigationBar: userRef.state == null ? null : getBottomNavBar(),
            body: Padding(
              padding: EdgeInsets.only(top: safePadding.top, bottom: safePadding.bottom, left: safePadding.left + 5, right: safePadding.right + 5),
              child: userRef.state == null ? Login() : Obx(() => getPages()[mainStore.bottomNavBarIndex.value]),
            ),
          );
        },
      ),
      // ),
    );
  }
}
