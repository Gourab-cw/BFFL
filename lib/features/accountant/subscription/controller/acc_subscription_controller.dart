import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/user_subscription/data/user_subscription.dart';

import '../../../../core/utility/helper.dart';
import '../../../login/repository/authenticator.dart';

class AccSubscriptionController extends GetxController {
  List<UserSubscription> list = [];
  final fb = Get.find<FB>();
  Future<void> getList() async {
    try {
      final db = await fb.getDB();
      final auth = Get.find<Authenticator>();
      if (auth.state == null) {
        showAlert("No branch found!", AlertType.error);
      }
      final resp = await db
          .collection('userSubscription')
          .where('branchId', isEqualTo: auth.state!.branchId)
          .where('paidAt', isEqualTo: null)
          .where('isActive', isEqualTo: false)
          .limit(15)
          .orderBy('createdAt')
          .get();
      list = resp.docs.map((m) => UserSubscription.fromJSON(makeMapSerialize(m.data()))).toList();
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  UserSubscription? selectedUser;
  Future<void> getDetails(UserSubscription us) async {
    try {
      final db = await fb.getDB();
      final auth = Get.find<Authenticator>();
      if (auth.state == null) {
        showAlert("No branch found!", AlertType.error);
      }
      final resp = await db.collection('User').doc(us.userId).get();
      selectedUser = us.copyWith(user: UserG.fromJSON(makeMapSerialize(resp.data())));
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> updateDetails(UserSubscription us, String remarks) async {
    try {
      final db = await fb.getDB();
      final auth = Get.find<Authenticator>();
      if (auth.state == null) {
        showAlert("No branch found!", AlertType.error);
      }
      await db.collection('userSubscription').doc(us.id).update({
        'paidAt': Timestamp.now(),
        'accountantId': auth.state!.id,
        'remarks': remarks,
        'isActive': true,
      });
      await getList();
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }
}
