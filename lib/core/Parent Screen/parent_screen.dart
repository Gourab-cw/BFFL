import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/widget/bottom_nav_bar_trainer.dart';
import 'package:healthandwellness/features/Service/presentation/service_view.dart';
import 'package:healthandwellness/features/home/presentation/home.dart';
import 'package:healthandwellness/features/home/presentation/trainer_home.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/members/presentation/members.dart';
import 'package:moon_design/moon_design.dart';

import '../../features/accountant/subscription/presentation/acc_subscription_list.dart';
import '../../features/attendance/attendance.dart';
import '../../features/calendar_report/presentation/calender_report.dart';
import '../../features/home/presentation/member_home.dart';
import '../../features/login/presentation/login.dart';
import '../../features/member_approve/presentation/member_approve_register.dart';
import '../../features/receptionist/schedule/presentation/daily_schedule.dart';
import '../../features/slot_details_trainer/presentation/slot_details_register.dart';
import '../../features/staff_register/presentation/staff_register.dart';
import '../utility/app_loader.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/bottom_navbar_accountant.dart';
import '../widget/bottom_navbar_admin.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  final MainStore mainStore = Get.find<MainStore>();
  final Authenticator userRef = Get.find<Authenticator>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  final List<Widget> _pages = [Home(), DailySchedule(), Members(), StaffRegister(), Home()];
  final List<Widget> _branchManagerPages = [Home(), DailySchedule(), Members(), CalenderReport(), Home()];
  final List<Widget> _trainerPages = [HomeTrainer(), SlotDetailsRegister(), Attendance(), HomeTrainer()];
  final List<Widget> _memberPages = [HomeMember(), ServiceView(), HomeTrainer()];
  final List<Widget> _adminPages = [HomeMember(), MemberApproveRegister(), HomeTrainer()];
  final List<Widget> _accPages = [AccSubscriptionList(), HomeTrainer()];
  List<Map<String, Icon>> trainerMenus = [
    {"Home": Icon(MoonIcons.generic_home_24_regular)},
    {"Slots": Icon(MoonIcons.time_calendar_24_regular)},
    {"Attendance": Icon(MoonIcons.generic_user_24_regular)},
  ];

  List<Map<String, Icon>> receptionistMenus = [
    {"Home": Icon(MoonIcons.generic_home_24_regular)},
    {"Schedule": Icon(MoonIcons.time_calendar_24_regular)},
    {"Patients": Icon(MoonIcons.generic_users_24_regular)},
    {"Staff": Icon(Icons.badge_outlined, size: 20)},
  ];
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
      return BottomNavbarTrainer(menus: trainerMenus);
    }
    if (userRef.state?.userType == UserType.admin) {
      return BottomNavbarAdmin();
    }
    if (userRef.state?.userType == UserType.accountant) {
      return BottomNavbarAccountant();
    }
    if (userRef.state?.userType == UserType.receptionist) {
      // return BottomNavbarTrainer(menus: trainerMenus);
      return BottomNavbarTrainer(menus: receptionistMenus);
    }
    return BottomNavbar();
  }

  List<Widget> getPages() {
    if (userRef.state?.userType == UserType.trainer) {
      return _trainerPages;
    }
    if (userRef.state?.userType == UserType.member) {
      return _memberPages;
    }
    if (userRef.state?.userType == UserType.admin) {
      return _adminPages;
    }
    if (userRef.state?.userType == UserType.accountant) {
      return _accPages;
    }
    return _pages;
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      child: GetBuilder<MainStore>(
        init: mainStore,
        autoRemove: false,
        builder: (context) {
          return GetBuilder<Authenticator>(
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
          );
        },
      ),
      // ),
    );
  }
}
