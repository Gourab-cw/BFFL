import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/service.dart';

import '../../login/data/user.dart';

class SubscriptionControllerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SubscriptionController(), fenix: true);
  }
}

class SubscriptionController extends GetxController {
  List<ServiceModel> list = [];

  Future<void> fetchSubscription(FirebaseFirestore db) async {
    final resp = await db.collection("Subscription").get();
    List<ServiceModel> list0 = resp.docs.map((m) => ServiceModel.fromJson(makeMapSerialize(m.data()))).toList();
    List<String> trainerIds = list0.map((l) => l.trainerId).expand((element) => element).toList();
    List<UserG> trainers = [];
    if (trainerIds.isNotEmpty) {
      final trainerResp = await db.collection("User").where("id", whereIn: trainerIds).get();
      trainers = trainerResp.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data()))).toList();
    }
    list = list0.map((l) {
      return l.copyWith(trainersData: trainers.where((t) => l.trainerId.contains(t.id)).toList());
    }).toList();
    update();
  }

  ServiceModel? getServiceById(String id) {
    return list.firstWhereOrNull((f) => f.id == id);
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
