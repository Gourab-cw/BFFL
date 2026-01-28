import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/app/firebase_provider.dart';
import 'package:healthandwellness/core/Picklist/picklist_item.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';


class PickListNotifier extends Notifier<List<PicklistItem>>{
  @override
  List<PicklistItem> build() {
    // TODO: implement build
    return [];
  }
  
  Future<void> getPickLists()async{
    if(state.isEmpty){
      final firebaseG = ref.read(firebaseProvider);
      final db = await firebaseG.getDB();
      final resp = await db.collection("picklists").where("isActive",isEqualTo: true).get();
      final List<PicklistItem> list = resp.docs.map((r)=>PicklistItem.fromJSON(makeMapSerialize(r))).toList();
      state = list;
    }
  }

  List<Map<String, String>> getGenderPicklist() {
    return state
        .where((e) => e.typeId == 'GENDER')
        .map((e) => {
      'id': e.id,
      'name': e.name,
    }).toList();
  }

  List<Map<String, String>> getBloodGroupPicklist() {
    return state
        .where((e) => e.typeId == 'BLOOD_GROUP')
        .map((e) => {
      'id': e.id,
      'name': e.name,
    })
        .toList();
  }

  List<Map<String, String>> getMaritalStatusPicklist() {
    return state
        .where((e) => e.typeId == 'MARITAL_STATUS')
        .map((e) => {
      'id': e.id,
      'name': e.name,
    }).toList();
  }

}