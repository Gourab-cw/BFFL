import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';

import '../core/utility/firebase_service.dart';

class MainStore extends GetxController {
  late FirebaseG firebaseG;

  AppLoaderController appLoaderController = AppLoaderController();
  Rx<bool> giveCallLogRequiredPermission = false.obs;
  Rx<bool> locationAllowed = false.obs;
  Rx<bool> showLocationDisclaimer = false.obs;
  Rx<bool> isLoggedIn = false.obs;
  Rx<bool> isDarkEnable = false.obs;
  Rx<bool> saveuser = true.obs;
  Rx<String> auth = ''.obs;
  RxInt bottomNavBarIndex = (-1).obs;
  RxMap<dynamic, dynamic> authData = {}.obs;
  RxDouble longitude = 0.0.obs;
  RxDouble latitude = 0.0.obs;

  void makeLoading() {
    appLoaderController.loading.value = true;
  }

  void stopLoading() {
    appLoaderController.loading.value = false;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    firebaseG = FirebaseG();
    super.onInit();
  }
}

getAuth() {
  MainStore mainStore = Get.find();
  return mainStore.authData.value;
}
