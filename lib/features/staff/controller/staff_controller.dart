import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/branch/data/branch_model.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';

class StaffController extends GetxController {
  List<UserG> staffList = [];
  List<BranchModel> branchList = [];

  final auth = Get.find<Authenticator>();
  final fb = Get.find<FB>();

  Future<void> makeActiveInactive(UserG user) async {
    final db = await fb.getDB();
    final userAuth = auth.state;
    if (userAuth == null) {
      throw Exception('Unable to authenticate');
      Get.offAllNamed('/login');
    }
    await db.collection('User').doc(user.id).update({'isActive': !user.isActive});
    await getStaffList();
  }

  Future<void> getStaffList() async {
    final db = await fb.getDB();
    final user = auth.state;
    if (user == null) {
      throw Exception('Unable to authenticate');
      Get.offAllNamed('/login');
    }
    Query<Map<String, dynamic>> query = db
        .collection('User')
        .where('companyId', isEqualTo: user.companyId)
        .where(
          'userType',
          whereNotIn: [userTypeMap2[UserType.admin], userTypeMap2[UserType.chargesLedger], userTypeMap2[UserType.paymentLedger], userTypeMap2[UserType.member]],
        );
    if (user.userType != UserType.admin) {
      query = query.where('branchId', isEqualTo: user.branchId);
    }
    final snapshot = await query.get();
    staffList = snapshot.docs.map((e) => UserG.fromJSON(makeMapSerialize(e.data()))).toList();

    List<String> branchIds = [];
    branchIds = staffList.where((s) => branchList.indexWhere((b) => b.id == s.branchId) == -1).map((m) => m.branchId).toList();
    if (branchIds.isNotEmpty) {
      final branchSnap = await db.collection('Branch').where('id', whereIn: branchIds).get();
      branchList.addAll(branchSnap.docs.map((m) => BranchModel.fromFirestore(m)));
    }
    update();
  }
}
