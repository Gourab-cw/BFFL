import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/user_type/data/user_type.dart';

import '../core/utility/firebase_service.dart';

class MainStore extends GetxController {
  late FirebaseG firebaseG;
  Rx<bool> giveCallLogRequiredPermission = false.obs;
  List<UserTypeModel> userTypes = [];
  Rx<bool> locationAllowed = false.obs;
  Rx<bool> showLocationDisclaimer = false.obs;
  Rx<bool> isLoggedIn = false.obs;
  Rx<bool> isDarkEnable = false.obs;
  Rx<bool> saveuser = true.obs;
  Rx<String> auth = ''.obs;
  RxInt bottomNavBarIndex = (0).obs;
  RxMap<dynamic, dynamic> authData = {}.obs;
  RxDouble longitude = 0.0.obs;
  RxDouble latitude = 0.0.obs;

  Future<void> fetchUserTypes() async {
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    final resp = await db.collection('UserType').get();
    userTypes = resp.docs.map((m) => UserTypeModel.fromJson(makeMapSerialize(m.data()))).toList();
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
