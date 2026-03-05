import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/voucher/model/voucher_model.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/user_subscription/data/user_subscription.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/Picklist/picklist_item.dart';
import '../../../../core/utility/helper.dart';
import '../../../login/repository/authenticator.dart';

class GSTDetails {
  double gstPer;
  bool withGST;

  double grossAmount;
  double gstAmount;
  double netAmount;

  GSTDetails({required this.gstPer, required this.withGST, required this.grossAmount, required this.gstAmount, required this.netAmount});
}

class AccSubscriptionController extends GetxController {
  VoucherModel? voucher;
  final TextEditingController amount = TextEditingController();
  PicklistItem? selectedPaymentMode;
  List<PicklistItem> paymentModes = [];
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

  Future<void> loadPaymentModes(List<String> payments) async {
    try {
      final db = await fb.getDB();
      final auth = Get.find<Authenticator>();
      if (auth.state == null) {
        showAlert("No branch found!", AlertType.error);
      }
      final resp = await db.collection('picklists').where('isActive', isEqualTo: true).where('id', whereIn: payments).get();
      paymentModes = resp.docs.map((m) => PicklistItem.fromJSON(makeMapSerialize(m.data()))).toList();
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

  GSTDetails getCalculationDetails({required UserSubscription selectedUser, required ServiceModel service}) {
    double gstPer = service.gstPer;
    bool withGST = service.withGST;
    double billAmount = service.totalDays == selectedUser.totalSessions
        ? parseDouble(data: service.totalAmount, defaultValue: 0)
        : parseDouble(data: (service.amount * selectedUser.totalSessions), defaultValue: 0);
    double gstAmount = 0;
    double totalAmount = billAmount;
    if (withGST) {
      gstAmount = (billAmount * gstPer) / 100;
      totalAmount += gstAmount;
    }

    return GSTDetails(gstPer: gstPer, withGST: withGST, grossAmount: billAmount, gstAmount: gstAmount, netAmount: totalAmount);
  }

  Future<void> makePaid({required UserSubscription selectedUser, required ServiceModel service, required String remarks}) async {
    final db = await fb.getDB();
    final batch = db.batch();
    final auth = Get.find<Authenticator>();
    if (voucher == null) {
      throw Exception('No voucher found!');
    }
    if (auth.state == null) {
      throw Exception("Not Authenticated!");
    }
    if (selectedPaymentMode == null) {
      throw Exception("No Payment Method found!");
    }
    final resp = await db.collection('payment').where('branchId', isEqualTo: auth.state!.branchId).count().get();

    int count = resp.count ?? 0;
    String voucherNumber = '${voucher!.prefix}${(count + 1).toString().padLeft(4, '0')}${voucher!.suffix}';

    double paidAmount = parseDouble(data: amount.text, defaultValue: 0);
    double gstPer = service.gstPer;
    bool withGST = service.withGST;
    double billAmount = service.totalDays == selectedUser.totalSessions
        ? parseDouble(data: service.totalAmount, defaultValue: 0)
        : parseDouble(data: (service.amount * selectedUser.totalSessions), defaultValue: 0);
    double gstAmount = 0;
    double totalAmount = billAmount;
    if (withGST) {
      gstAmount = (billAmount * gstPer) / 100;
      totalAmount += gstAmount;
    }
    if (paidAmount > totalAmount) {
      throw Exception('Paid amount is greater than total amount');
    }

    String uID = Uuid().v4();
    batch.update(db.collection('userSubscription').doc(selectedUser.id), {
      'voucherNumber': voucherNumber,
      'remarks': remarks,
      'isActive': true,
      'accountantId': auth.state!.id,
      'paidAt': Timestamp.now(),
    });
    batch.set(db.collection('payment').doc(uID), {
      'id': uID,
      'branchId': auth.state!.branchId,
      'userId': selectedUser.userId,
      'subscriptionId': selectedUser.subscriptionId,
      'voucherNumber': voucherNumber,
      'voucherId': voucher!.id,
      'voucherAmount': totalAmount,
      'paidAmount': paidAmount,
      'grossAmount': billAmount,
      'gstAmount': gstAmount,
      'withGST': withGST,
      'netAmount': totalAmount,
      'createdAt': Timestamp.now(),
      'paidBy': selectedPaymentMode!.name,
      'paymentModeId': selectedPaymentMode!.id,
    });
    await batch.commit();
  }
}
