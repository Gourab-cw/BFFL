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
      () => Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...List.generate(menus.length, (i) {
              final m = menus[i];
              final isSelected = mainStore.bottomNavBarIndex.value == i;
              return GestureDetector(
                onTap: () {
                  SystemSound.play(SystemSoundType.click);
                  mainStore.bottomNavBarIndex.value = i;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? mainStore.theme.value.HeadColor.withAlpha(20) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        m.values.toList()[0].icon,
                        size: isSelected ? 22 : 20,
                        color: isSelected ? mainStore.theme.value.HeadColor : Colors.grey.shade600,
                      ),
                      const SizedBox(height: 2),
                      TextHelper(
                        text: parseString(data: m.keys.toList()[0], defaultValue: ''),
                        fontweight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontsize: isSelected ? 11 : 10,
                        color: isSelected ? mainStore.theme.value.HeadColor : Colors.grey.shade600,
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(height: 2),
                    TextHelper(
                      text: 'Logout',
                      fontsize: 10,
                      color: Colors.red.shade700,
                      textalign: TextAlign.center,
                      fontweight: FontWeight.w600,
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
