import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';

import '../../login/data/user.dart';

class MemberApproveController extends GetxController {
  List<UserG> list = [];
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  Future<void> getApprovalUserList() async {
    final db = await fb.getDB();
    if (auth.state != null) {
      final resp = await db.collection('User').where('branchId', isEqualTo: auth.state!.branchId).where('isApproved', isEqualTo: false).get();
      list = resp.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data()))).toList();
      update();
    }
  }

  Future<void> approveMember(UserG user) async {
    try {
      final db = await fb.getDB();
      if (auth.state != null) {
        await db.collection('User').doc(user.id).update({'isApproved': true, 'activeFrom': Timestamp.now()});
        await getApprovalUserList();
      }
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }
}
