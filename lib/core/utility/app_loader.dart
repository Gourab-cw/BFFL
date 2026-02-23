import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoaderController extends GetxController {
  final RxBool loading = false.obs;
  Timer? _timer;

  void startLoading({Duration timeout = const Duration(seconds: 100)}) {
    if (loading.value) return;

    loading.value = true;

    _timer?.cancel();
    _timer = Timer(timeout, () {
      stopLoading();
    });
  }

  void stopLoading() {
    if (!loading.value) return;

    _timer?.cancel();
    _timer = null;
    loading.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class AppLoader extends StatelessWidget {
  final Widget child;
  const AppLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Loader.getLoader();

    return Obx(() {
      return PopScope(
        canPop: !controller.loading.value,
        child: Stack(
          children: [
            child,
            if (controller.loading.value)
              Positioned.fill(
                child: Container(
                  color: Colors.white54,
                  child: const Center(
                    child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Colors.blue)),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class Loader {
  Loader._internal();

  static final Loader _instance = Loader._internal();

  factory Loader() {
    return _instance;
  }
  static AppLoaderController? loader;

  static _init() {
    if (loader == null) {
      if (!Get.isRegistered<AppLoaderController>()) {
        Get.put(AppLoaderController());
      }
      loader = Get.find<AppLoaderController>();
    }
  }

  static AppLoaderController getLoader() {
    _init();
    return loader!;
  }

  static void startLoading() {
    if (loader == null) {
      _init();
    }
    loader!.startLoading();
  }

  static void stopLoading() {
    loader!.stopLoading();
  }
}
