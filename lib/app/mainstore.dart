import 'package:get/get.dart';

class MainStore extends GetxController {
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
}

getAuth() {
  MainStore mainStore = Get.find();
  return mainStore.authData.value;
}
