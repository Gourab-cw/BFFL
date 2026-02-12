import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:moon_design/moon_design.dart';

import '../utility/app_loader.dart';
import '../utility/helper.dart';

class BottomNavbarMember extends StatefulWidget {
  const BottomNavbarMember({super.key});

  @override
  State<BottomNavbarMember> createState() => _BottomNavbarMemberState();
}

class _BottomNavbarMemberState extends State<BottomNavbarMember> {
  final MainStore mainStore = Get.find<MainStore>();
  final AppLoaderController loaderController = Get.find<AppLoaderController>();
  final Authenticator user = Get.find<Authenticator>();
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
                      MoonIcons.generic_users_24_regular,
                      size: 27,
                      color: mainStore.bottomNavBarIndex.value == 1 ? Colors.green.shade900 : Colors.black,
                    ),
                  ),
                  TextHelper(
                    text: parseString(data: 'Members', defaultValue: ''),
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
                      MoonIcons.generic_user_24_regular,
                      size: 23,
                      color: mainStore.bottomNavBarIndex.value == 2 ? Colors.green.shade900 : Colors.black,
                    ),
                  ),
                  TextHelper(
                    text: parseString(data: 'Attendance', defaultValue: ''),
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
