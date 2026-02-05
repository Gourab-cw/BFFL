import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';

import '../data/Subscription.dart';

class SubscriptionControllerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SubscriptionController(), fenix: true);
  }
}

class SubscriptionController extends GetxController {
  List<Subscription> list = [];

  Future<void> fetchSubscription(FirebaseFirestore db) async {
    final resp = await db.collection("Subscription").get();
    list = resp.docs.map((m) => Subscription.fromJSON(makeMapSerialize(m.data()))).toList();
    update();
  }

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    try {
      final fb = Get.find<FB>();
      await fetchSubscription(await fb.getDB());
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
    super.onInit();
  }
}
