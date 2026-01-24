import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';

class AppLoaderController extends GetxController {
  RxBool loading = false.obs;
  Rxn<Timer> loadingTimer = Rxn<Timer>(null);
}

class AppLoader extends StatefulWidget {
  final Widget child;
  const AppLoader({super.key, required this.child});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  MainStore mainStore = Get.find<MainStore>();

  @override
  void initState() {
    mainStore.appLoaderController.loading.listen((v) {
      if (v && mainStore.appLoaderController.loadingTimer.value == null) {
        mainStore.appLoaderController.loadingTimer.value = Timer(const Duration(seconds: 100), () {
          if (mainStore.appLoaderController.loading.value) {
            mainStore.appLoaderController.loading.value = false;
            if (mainStore.appLoaderController.loadingTimer.value != null) {
              mainStore.appLoaderController.loadingTimer.value!.cancel();
              mainStore.appLoaderController.loadingTimer.value = null;
            }
          }
        });
      } else if (!v && mainStore.appLoaderController.loadingTimer.value != null) {
        mainStore.appLoaderController.loadingTimer.value!.cancel();
        mainStore.appLoaderController.loadingTimer.value = null;
      }
      mainStore.appLoaderController.update();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      // mainStore.appLoaderController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppLoaderController>(
      init: mainStore.appLoaderController,
      builder: (controller) {
        return PopScope(
          canPop: !controller.loading.value,
          child: Stack(
            children: [
              widget.child,
              if (controller.loading.value)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white54),
                    child: const Center(
                      child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Colors.blue)),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
