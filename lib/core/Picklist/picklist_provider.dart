import 'package:get/get.dart';
import 'package:healthandwellness/core/Picklist/picklist_item.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';

class PickListBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => PickListNotifier(), fenix: true);
  }
}

class PickListNotifier extends GetxController {
  List<PicklistItem> state = [];

  Future<void> getPickLists() async {
    // if (state.isNotEmpty) {
    final firebaseG = Get.find<FB>();
    final db = await firebaseG.getDB();
    final resp = await db.collection("picklists").where("isActive", isEqualTo: true).get();
    final List<PicklistItem> list = resp.docs.map((r) {
      return PicklistItem.fromJSON(makeMapSerialize(r.data()));
    }).toList();
    state = list;
    update();
    // }
  }

  List<Map<String, String>> getGenderPicklist() {
    return state.where((e) => e.typeId == 'GENDER').map((e) => {'id': e.id, 'name': e.name}).toList();
  }

  List<Map<String, String>> getBloodGroupPicklist() {
    return state.where((e) => e.typeId == 'BLOOD_GROUP').map((e) => {'id': e.id, 'name': e.name}).toList();
  }

  List<Map<String, String>> getMaritalStatusPicklist() {
    return state.where((e) => e.typeId == 'MARITAL_STATUS').map((e) => {'id': e.id, 'name': e.name}).toList();
  }

  List<Map<String, String>> getReferredPicklist() {
    return state.where((e) => e.typeId == 'REFERRED').map((e) => {'id': e.id, 'name': e.name}).toList();
  }

  List<Map<String, String>> getUserServicePicklist() {
    return state.where((e) => e.typeId == 'USER_SERVICE').map((e) => {'id': e.id, 'name': e.name}).toList();
  }
}
