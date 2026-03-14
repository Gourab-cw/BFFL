import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/branch/data/branch_model.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';

import '../../../../core/utility/helper.dart';
import '../../../Payment/data/payment_model.dart';
import '../../../login/data/user.dart';
import '../../../login/repository/authenticator.dart';

class AccountantHistoryController extends GetxController {
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  String searchText = '';

  List<PaymentModel> list = [];
  List<BranchModel> branchList = [];

  DocumentSnapshot? lastDocumentSnapshot;
  Future<void> getList({bool force = false}) async {
    final db = await fb.getDB();
    final user = auth.state;
    if (user == null) {
      throw Exception("Not authenticated!");
    }
    if (list.isNotEmpty && !force) {
      return;
    }
    Query<Map<String, dynamic>> query = db.collection('payment');
    if (user.userType != UserType.admin) {
      query = query.where('branchId', isEqualTo: user.branchId);
    }
    if (user.userType == UserType.accountant) {
      query = query.where('accountantId', isEqualTo: user.id);
    }

    query = query.orderBy('createdAt', descending: true);
    if (lastDocumentSnapshot != null) {
      query = query.startAfterDocument(lastDocumentSnapshot!);
    }
    query = query.limit(10);
    final resp = await query.get();
    List<PaymentModel> list2 = resp.docs.map((m) => PaymentModel.fromJson(makeMapSerialize(m.data()))).toList();
    list = [...list, ...list2];
    if (user.userType == UserType.admin) {
      final List<String> haveBranchIds = branchList.map((m) => m.id).toList();
      final List<String> branchIds = list.map((m) => m.branchId).where((w) => !haveBranchIds.contains(w)).toList();
      if (branchIds.isNotEmpty) {
        final branchResp = await db.collection('Branch').where('id', whereIn: branchIds).get();
        branchList = [...branchList, ...branchResp.docs.map((m) => BranchModel.fromFirestore(m))];
      }
    }
    if (resp.docs.isNotEmpty) {
      lastDocumentSnapshot = resp.docs.last;
    }
    update();
  }

  Future<void> updateUserName() async {
    final db = await fb.getDB();
    final batch = db.batch();
    final paymentSnap = await db.collection('payment').get();
    final transactions = paymentSnap.docs.map((m) => PaymentModel.fromJson(makeMapSerialize(m.data())));
    final userIds = transactions.map((m) => m.userId).toList();
    final userSnap = await db.collection('User').where('id', whereIn: userIds).get();
    final users = userSnap.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data())));

    for (var i in transactions) {
      batch.update(db.collection('payment').doc(i.id), {'userName': users.firstWhere((m) => m.id == i.userId).name});
    }

    await batch.commit();
  }
}
