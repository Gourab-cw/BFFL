import 'package:get/get.dart';
import 'package:healthandwellness/core/branch/data/branch_model.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Payment/data/payment_model.dart';
import 'package:healthandwellness/features/login/data/user.dart';

import '../../login/repository/authenticator.dart';

class PaymentController extends GetxController {
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  PaymentModel? selectedPayment;
  UserG? selectedUser;

  BranchModel? branch;

  Future<void> getUser() async {
    final db = await fb.getDB();
    if (selectedPayment == null) {
      throw Exception('No payment found!');
    }
    final userSnap = await db.collection('User').doc(selectedPayment!.userId).get();
    selectedUser = UserG.fromJSON(makeMapSerialize(userSnap.data()));
    update();
  }

  Future<void> getBranch() async {
    final db = await fb.getDB();
    if (selectedPayment == null) {
      throw Exception('No payment found!');
    }
    final userSnap = await db.collection('Branch').doc(selectedPayment!.branchId).get();
    branch = BranchModel.fromFirestore(userSnap);
    update();
  }
}
