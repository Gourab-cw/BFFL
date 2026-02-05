import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';

import '../../login/data/user.dart';

class MemberControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MemberController(), fenix: true);
    // TODO: implement dependencies
  }
}

class MemberController extends GetxController {
  List<UserG> members = [];
  RxBool isSearching = false.obs;
  UserG? selectedUser;
  // int currentPage = 1;
  // int totalFetchLimit = 20;
  TextEditingController search = TextEditingController();

  Future<void> searchMembers(FirebaseFirestore db) async {
    String s = search.text.trim();
    if (s.isEmpty && members.isEmpty) {
      fetchMembers(db);
    }
    if (s.isEmpty) {
      return;
    }
    try {
      isSearching.value = true;
      final resp = await db
          .collection("User")
          .where("searchTerm", isGreaterThanOrEqualTo: s)
          .where("searchTerm", isLessThanOrEqualTo: '$s\uf8ff')
          .limit(20)
          .get();
      members = resp.docs.map((doc) => UserG.fromJSON(makeMapSerialize(doc.data()))).toList();
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> fetchMembers(FirebaseFirestore db) async {
    final resp = await db.collection('User').limit(2).get();
    members = resp.docs.map((doc) => UserG.fromJSON(makeMapSerialize(doc.data()))).toList();
    update();
  }

  Future<void> makeApprove(UserG user, FirebaseFirestore db) async {
    await db.collection('User').doc(user.id).update({"isApproved": true});
  }
}
