import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/features/login/repository/user_notifier.dart';
import 'package:moon_design/moon_design.dart';

import '../utility/app_loader.dart';
import '../utility/helper.dart';

class BottomNavbar extends ConsumerStatefulWidget {
  const BottomNavbar({super.key});

  @override
  ConsumerState<BottomNavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends ConsumerState<BottomNavbar> {
  final MainStore mainStore = Get.find<MainStore>();
  final AppLoaderController loaderController = Get.find<AppLoaderController>();
  final UserNotifier user = Get.find<UserNotifier>();
  @override
  Widget build(BuildContext context) {
    final calcWidth = MediaQuery.sizeOf(context).width / (4 + 1);
    return Obx(
      () => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        elevation: 0,
        height: 60,
        notchMargin: 3,
        padding: const EdgeInsets.all(0),
        color: const Color.fromARGB(255, 151, 239, 160),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                SystemSound.play(SystemSoundType.click);
                mainStore.bottomNavBarIndex.value = 0;
                // Get.toNamed("/home");
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 28,
                    width: calcWidth > 40 ? 40 : calcWidth,
                    decoration: BoxDecoration(
                      color: mainStore.bottomNavBarIndex.value == 0 ? Colors.white.withAlpha(160) : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      MoonIcons.generic_home_24_regular,
                      size: 23,
                      color: mainStore.bottomNavBarIndex.value == 0 ? Colors.green.shade900 : Colors.black,
                    ),
                  ),
                  TextHelper(
                    text: parseString(data: 'Home', defaultValue: ''),
                    fontweight: FontWeight.w600,
                    fontsize: 11,
                    width: calcWidth,
                    isWrap: true,
                    textalign: TextAlign.center,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                SystemSound.play(SystemSoundType.click);
                mainStore.bottomNavBarIndex.value = 1;
                // Get.toNamed("/serviceview");
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 28,
                    width: calcWidth > 40 ? 40 : calcWidth,
                    decoration: BoxDecoration(
                      color: mainStore.bottomNavBarIndex.value == 1 ? Colors.white.withAlpha(160) : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      MoonIcons.generic_ticket_24_regular,
                      size: 23,
                      color: mainStore.bottomNavBarIndex.value == 1 ? Colors.green.shade900 : Colors.black,
                    ),
                  ),
                  TextHelper(
                    text: parseString(data: 'Service', defaultValue: ''),
                    fontweight: FontWeight.w600,
                    fontsize: 11,
                    width: calcWidth,
                    isWrap: true,
                    textalign: TextAlign.center,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                SystemSound.play(SystemSoundType.click);
                mainStore.bottomNavBarIndex.value = 2;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 28,
                    width: calcWidth > 40 ? 40 : calcWidth,
                    decoration: BoxDecoration(
                      color: mainStore.bottomNavBarIndex.value == 2 ? Colors.white.withAlpha(160) : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      MoonIcons.time_calendar_24_regular,
                      size: 23,
                      color: mainStore.bottomNavBarIndex.value == 2 ? Colors.green.shade900 : Colors.black,
                    ),
                  ),
                  TextHelper(
                    text: parseString(data: 'Calender', defaultValue: ''),
                    fontweight: FontWeight.w600,
                    fontsize: 11,
                    width: calcWidth,
                    isWrap: true,
                    textalign: TextAlign.center,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                SystemSound.play(SystemSoundType.click);
                loaderController.startLoading();
                try {
                  await user.logOut();
                } catch (e) {
                  showAlert("$e", AlertType.error);
                } finally {
                  loaderController.stopLoading();
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 28,
                    width: calcWidth > 40 ? 40 : calcWidth,
                    decoration: BoxDecoration(
                      color: mainStore.bottomNavBarIndex.value == 4 ? Colors.white.withAlpha(100) : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(Icons.logout, size: 20),
                  ),
                  TextHelper(
                    text: parseString(data: 'Logout', defaultValue: ''),
                    fontweight: FontWeight.w600,
                    fontsize: 11,
                    width: calcWidth,
                    isWrap: true,
                    textalign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
