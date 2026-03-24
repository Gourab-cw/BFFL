import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';

import '../utility/app_loader.dart';
import '../utility/helper.dart';

class BottomNavbarTrainer extends StatefulWidget {
  final List<Map<String, Icon>> menus;
  const BottomNavbarTrainer({super.key, required this.menus});

  @override
  State<BottomNavbarTrainer> createState() => _BottomNavbarTrainerState();
}

class _BottomNavbarTrainerState extends State<BottomNavbarTrainer> {
  final MainStore mainStore = Get.find<MainStore>();
  final AppLoaderController loaderController = Get.find<AppLoaderController>();
  final Authenticator user = Get.find<Authenticator>();

  Future<void> showLogoutPopup() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: SizedBox(
            height: 160,
            width: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_rounded, color: Colors.redAccent, size: 30),
                      TextHelper(text: "Logout", textalign: TextAlign.center, fontsize: 18, fontweight: FontWeight.w600),
                    ],
                  ),
                  TextHelper(text: "Do you really want to exit the app?", textalign: TextAlign.center, fontsize: 14, fontweight: FontWeight.w500),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      ButtonHelperG(
                        onTap: () async {
                          loaderController.startLoading();
                          try {
                            await user.logOut();
                            if (context.mounted) {
                              goBack(context);
                            }
                          } catch (e) {
                            showAlert("$e", AlertType.error);
                          } finally {
                            loaderController.stopLoading();
                          }
                        },
                        label: TextHelper(text: "Yes", fontweight: FontWeight.w600, color: mainStore.theme.value.BackgroundColor),
                        width: 70,
                        height: 38,
                      ),
                      ButtonHelperG(
                        onTap: () {
                          goBack(context);
                        },
                        label: TextHelper(text: "Cancel", fontweight: FontWeight.w600, color: mainStore.theme.value.HeadColor),
                        shadow: [],
                        background: mainStore.theme.value.lowShadeColor,
                        width: 70,
                        height: 38,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final menus = widget.menus;
    final calcWidth = MediaQuery.sizeOf(context).width / (4 + 1);
    return Obx(
      () => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        elevation: 0,
        height: 60,
        notchMargin: 3,
        padding: const EdgeInsets.all(0),
        // color: const Color.fromARGB(255, 151, 239, 160),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...List.generate(menus.length, (i) {
              final m = menus[i];
              return GestureDetector(
                onTap: () {
                  SystemSound.play(SystemSoundType.click);
                  mainStore.bottomNavBarIndex.value = i;
                  // Get.toNamed("/home");
                },
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width / (menus.length + 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        height: 28,
                        width: calcWidth > 35 ? 35 : calcWidth,
                        decoration: BoxDecoration(
                          color: mainStore.bottomNavBarIndex.value == i ? mainStore.theme.value.BackgroundShadeColor.withAlpha(100) : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          m.values.toList()[0].icon,
                          size: m.values.toList()[0].size,
                          color: mainStore.bottomNavBarIndex.value == i ? mainStore.theme.value.DarkTextColor : mainStore.theme.value.DarkTextColor,
                        ),
                      ),
                      TextHelper(
                        text: parseString(data: m.keys.toList()[0], defaultValue: ''),
                        fontweight: mainStore.bottomNavBarIndex.value == i ? FontWeight.w600 : FontWeight.w500,
                        fontsize: mainStore.bottomNavBarIndex.value == i ? 11 : 10,
                        width: calcWidth,
                        isWrap: true,
                        color: mainStore.theme.value.DarkTextColor,
                        textalign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
            GestureDetector(
              onTap: () async {
                await showLogoutPopup();
              },
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width / (menus.length + 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 28,
                      width: calcWidth > 40 ? 40 : calcWidth,
                      decoration: BoxDecoration(
                        color: mainStore.bottomNavBarIndex.value == 10 ? Colors.white.withAlpha(160) : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.logout,
                        size: 17,
                        color: mainStore.bottomNavBarIndex.value == 10 ? mainStore.theme.value.HeadColor : mainStore.theme.value.BackgroundColor,
                      ),
                    ),
                    TextHelper(
                      text: parseString(data: 'Logout', defaultValue: ''),
                      fontsize: 10,
                      color: mainStore.bottomNavBarIndex.value == 10 ? mainStore.theme.value.HeadColor : mainStore.theme.value.BackgroundColor,
                      width: calcWidth,
                      isWrap: true,
                      textalign: TextAlign.center,
                      fontweight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
