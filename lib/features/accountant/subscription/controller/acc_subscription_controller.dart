import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/voucher/model/voucher_model.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/user_subscription/data/multi_subscription.dart';
import 'package:healthandwellness/features/user_subscription/data/user_subscription.dart';
import 'package:ulid/ulid.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utility/helper.dart';
import '../../../login/repository/authenticator.dart';

class GSTDetails {
  double gstPer;
  bool withGST;

  double discPer;
  double discAmount;

  bool discountWithGST;
  double totalAmount;
  double grossAmount;
  double gstAmount;
  double netAmount;

  GSTDetails({
    required this.gstPer,
    required this.withGST,
    required this.totalAmount,
    required this.grossAmount,
    required this.gstAmount,
    required this.netAmount,
    required this.discPer,
    required this.discAmount,
    required this.discountWithGST,
  });

  factory GSTDetails.empty() =>
      GSTDetails(gstPer: 0, withGST: false, grossAmount: 0, totalAmount: 0, gstAmount: 0, netAmount: 0, discPer: 0, discAmount: 0, discountWithGST: false);
}

class AccSubscriptionController extends GetxController {
  VoucherModel? voucher;
  final TextEditingController search = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController discAmountController = TextEditingController();
  RxDouble discAmount = 0.0.obs;
  final TextEditingController discPerController = TextEditingController();
  UserG? selectedPaymentMode;
  List<UserG> paymentModes = [];
  List<UserG> chargesLedgers = [];
  List<MultiSubscription> list = [];
  final fb = Get.find<FB>();

  MultiSubscription? selectedUser;

  GSTDetails gstDetails = GSTDetails.empty();

  Future<void> getList({bool force = false}) async {
    try {
      final db = await fb.getDB();
      final auth = Get.find<Authenticator>();
      if (list.isNotEmpty && !force) {
        return;
      }
      if (auth.state == null) {
        showAlert("No branch found!", AlertType.error);
      }
      final resp = await db
          .collection('userSubscription')
          .where('branchId', isEqualTo: auth.state!.branchId)
          .where('dueAmount', isGreaterThan: 0)
          .limit(15)
          .orderBy('createdAt')
          .get();
      final userSubscriptions = resp.docs.map((m) => UserSubscription.fromJSON(makeMapSerialize(m.data()))).toList();

      Map<String, List<UserSubscription>> groupBySubscription = {};
      for (final UserSubscription u in userSubscriptions) {
        if (groupBySubscription[u.name] != null) {
          groupBySubscription[u.name]!.add(u);
        } else {
          groupBySubscription[u.name] = [u];
        }
      }
      List<MultiSubscription> mList = [];
      for (String key in groupBySubscription.keys) {
        UserSubscription usf = groupBySubscription[key]!.first;
        double discAmount = 0;
        double discPer = 0;
        double totalAmount = 0;
        double grossAmount = 0;
        double taxAmount = 0;
        double netAmount = 0;
        double dueAmount = 0;
        for (final m in groupBySubscription[key]!) {
          discAmount += m.discAmount;
          totalAmount += m.totalAmount;
          grossAmount += m.grossAmount;
          taxAmount += m.taxAmount;
          netAmount += m.netAmount;
          dueAmount += m.dueAmount;
          discPer += m.discPer;
        }
        discPer = discPer / groupBySubscription[key]!.length;
        mList.add(
          MultiSubscription(
            id: usf.name,
            voucherTypeId: usf.voucherTypeId,
            voucherTypeName: usf.voucherTypeName,
            userId: usf.userId,
            userName: usf.userName,
            branchId: usf.branchId,
            name: usf.name,
            createdAt: usf.createdAt,
            updatedAt: usf.updatedAt,
            discAmount: discAmount,
            discPer: discPer,
            totalAmount: totalAmount,
            grossAmount: grossAmount,
            taxAmount: taxAmount,
            netAmount: netAmount,
            dueAmount: dueAmount,
            subscriptions: groupBySubscription[key]!,
          ),
        );
      }
      list = mList;
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
      final resp = await db.collection('User').where('isActive', isEqualTo: true).where('id', whereIn: payments).get();
      paymentModes = resp.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data()))).toList();
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> loadChargesLedgers() async {
    try {
      final db = await fb.getDB();
      final auth = Get.find<Authenticator>();
      if (auth.state == null) {
        showAlert("No branch found!", AlertType.error);
      }
      final resp = await db.collection('User').where('isActive', isEqualTo: true).where('userType', isEqualTo: 's4Jt0ceWglK1ZAwerJKS').get();
      chargesLedgers = resp.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data()))).toList();
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> getDetails(MultiSubscription us) async {
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
      await getList(force: true);
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  GSTDetails getCalculationDetails({
    required UserSubscription selectedUser,
    required ServiceModel service,
    bool updateByDiscAmount = false,
    bool updateByDiscPer = false,
  }) {
    bool withDiscountOnGST = parseBool(
      data: chargesLedgers.firstWhereOrNull((f) => f.name.toLowerCase().removeAllWhitespace.contains('discount'))?.withGST,
      defaultValue: false,
    );
    bool voucherHaveDiscount = parseBool(data: voucher?.withDiscount, defaultValue: false);
    double gstPer = service.gstPer;
    bool withGST = service.withGST;
    double discountAmount = parseDouble(data: discAmountController.text, defaultValue: 0);
    double discountPer = parseDouble(data: discAmountController.text, defaultValue: 0);
    double grossAmount = service.totalDays == selectedUser.totalSessions
        ? parseDouble(data: service.totalAmount, defaultValue: 0)
        : parseDouble(data: (service.amount * selectedUser.totalSessions), defaultValue: 0);
    double totalAmount = grossAmount;
    if (!withDiscountOnGST && voucherHaveDiscount) {
      if (updateByDiscAmount) {
        discountAmount = parseDouble(data: discAmountController.text, defaultValue: 0);
        discountPer = discountAmount / grossAmount * 100;
      } else if (updateByDiscPer) {
        discountPer = parseDouble(data: discPerController.text, defaultValue: 0);
        discountAmount = discountPer / 100 * grossAmount;
      }
      grossAmount = grossAmount - discountAmount;
    }
    double gstAmount = 0;
    double netAmount = grossAmount;
    if (withGST) {
      gstAmount = (grossAmount * gstPer) / 100;
      netAmount += gstAmount;
    }
    if (withDiscountOnGST && voucherHaveDiscount) {
      if (updateByDiscAmount) {
        discountAmount = parseDouble(data: discAmountController.text, defaultValue: 0);
        discountPer = discountAmount / netAmount * 100;
      } else if (updateByDiscPer) {
        discountPer = parseDouble(data: discPerController.text, defaultValue: 0);
        discountAmount = discountPer / 100 * netAmount;
      }
      netAmount = netAmount - discountAmount;
    }

    discPerController.text = parseDoubleWithLength(data: discountPer, defaultValue: '');
    discAmountController.text = discountAmount.toString();
    gstDetails = GSTDetails(
      totalAmount: totalAmount,
      gstPer: gstPer,
      withGST: withGST,
      grossAmount: grossAmount,
      gstAmount: gstAmount,
      netAmount: netAmount,
      discPer: discountPer,
      discAmount: discountAmount,
      discountWithGST: withDiscountOnGST,
    );
    return GSTDetails(
      totalAmount: totalAmount,
      gstPer: gstPer,
      withGST: withGST,
      grossAmount: grossAmount,
      gstAmount: gstAmount,
      netAmount: netAmount,
      discPer: discountPer,
      discAmount: discountAmount,
      discountWithGST: withDiscountOnGST,
    );
  }

  Future<void> makePaid({required MultiSubscription selectedUser, required String txnValue, required String remarks}) async {
    // Future<void> makePaid({required MultiSubscription selectedUser, required ServiceModel service, required String txnValue, required String remarks}) async {
    final db = await fb.getDB();
    final batch = db.batch();
    final auth = Get.find<Authenticator>();
    final UserG? user = selectedUser.user;
    if (user == null) {
      throw Exception('No user found!');
    }
    double advanceAmount = user.balance < 0 ? 0 : user.balance;
    if (voucher == null) {
      throw Exception('No voucher found!');
    }
    if (auth.state == null) {
      throw Exception("Not Authenticated!");
    }
    final resp = await db.collection('payment').where('branchId', isEqualTo: auth.state!.branchId).count().get();

    int count = resp.count ?? 0;

    String voucherNumber = '${voucher!.prefix}${(count + 1).toString().padLeft(4, '0')}${voucher!.suffix}';

    // adv = 00
    // paid = 2000,
    // bill = 1000 ,

    // adv = 200
    // paid = 100,
    // bill = 400 ,

    // adv = 100
    // paid = 600,
    // bill = 400 ,

    // adv = 600
    // paid = 00,
    // bill = 400 ,

    // adjustedBalanceAmount =  paid==0? -bill : (bill>adv && adv>0)? -adv : paid - bill;

    double paidAmount = parseDouble(data: amount.text, defaultValue: 0);
    double adjustedBalanceAmount = paidAmount == 0
        ? -selectedUser.dueAmount
        : (selectedUser.dueAmount > advanceAmount && advanceAmount > 0)
        ? -advanceAmount
        : paidAmount - selectedUser.dueAmount;

    double paymentByAdvanceAmount = advanceAmount == 0
        ? 0
        : selectedUser.dueAmount < advanceAmount
        ? selectedUser.dueAmount
        : advanceAmount;

    if (selectedPaymentMode == null && selectedUser.dueAmount > advanceAmount) {
      throw Exception("No Payment Method found!");
    }
    if (paidAmount <= 0 && selectedUser.dueAmount > advanceAmount) {
      throw Exception('Please enter paid amount');
    }

    // if (paidAmount > selectedUser.netAmount) {
    //   // advanceAmount = paidAmount - selectedUser.netAmount;
    //   // throw Exception('Paid amount is greater than total amount');
    // }
    if (selectedUser.dueAmount <= 0) {
      throw Exception('No due amount found');
    }
    if ((selectedUser.dueAmount - advanceAmount) < paidAmount) {
      advanceAmount = paidAmount - (selectedUser.dueAmount - advanceAmount);
    }
    final advanceResp = await db
        .collection('User')
        .where('userType', isEqualTo: userTypeMap2[UserType.paymentLedger])
        .where('base', isEqualTo: 'advance')
        .where('isActive', isEqualTo: true)
        .get();
    UserG? advanceUser = advanceResp.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data()))).firstOrNull;

    final now = Timestamp.fromDate(DateTime.now());
    String uID = Uuid().v4();
    double paidAmountCalc = paidAmount;
    List<Map<String, dynamic>> subscriptions = selectedUser.subscriptions.map((m) => m.toJSON()).toList();
    for (int i = 0; i < subscriptions.length; i++) {
      final f = subscriptions[i];
      if (paidAmountCalc <= 0) {
        subscriptions[i]['paidAmount'] = 0;
        continue;
      }
      final dueAmount = parseDouble(data: f['dueAmount']);
      final due = dueAmount > paidAmountCalc ? (dueAmount - paidAmountCalc) : 0;
      double paidAmountCalc0 = paidAmountCalc;
      paidAmountCalc0 = dueAmount > paidAmountCalc0 ? paidAmountCalc0 : dueAmount;
      paidAmountCalc = dueAmount > paidAmountCalc ? 0 : (paidAmountCalc - dueAmount);

      subscriptions[i]['paidAmount'] = paidAmountCalc0;
      batch.update(db.collection('userSubscription').doc(f['id']), {'isActive': true, 'dueAmount': due});
    }

    batch.set(db.collection('payment').doc(uID), {
      'id': uID,
      'branchId': auth.state!.branchId,
      'companyId': auth.state!.companyId,
      'userId': selectedUser.userId,
      'userName': selectedUser.userName,
      // 'services': selectedUser.subscriptions.map((m) => m.toJSON()).toList(),
      'subscriptionId': selectedUser.id,
      'voucherNumber': voucherNumber,
      'voucherId': voucher!.id,
      'voucherAmount': selectedUser.netAmount,
      'paidAmount': paidAmount,
      'advanceAmount': advanceAmount,
      'grossAmount': selectedUser.grossAmount,
      // 'gstPer': service.gstPer,
      'gstAmount': selectedUser.taxAmount,
      'netAmount': selectedUser.netAmount,
      'dueAmount': selectedUser.dueAmount,
      'subscriptions': subscriptions,
      'paymentModeName': selectedPaymentMode!.name,
      'paymentModeId': selectedPaymentMode!.id,
      'isPosted': false,
      'remarks': remarks,
      'txnValue': txnValue,
      'accountantId': auth.state!.id,
      'createdAt': Timestamp.now(),
    });
    final ledgerRef = db.collection('transaction');
    final ledgerTransactionId = Ulid().toString();
    final ledgerTransaction1Id = Ulid().toString();
    final ledgerTransactionAdvanceId = Ulid().toString();
    if (advanceAmount > 0) {
      if (advanceUser == null) {
        throw Exception('No advance ledger found');
      }
      // Advance ledger payment entry
      batch.set(ledgerRef.doc(ledgerTransactionAdvanceId), {
        'id': ledgerTransactionAdvanceId,
        'billId': selectedUser.id,
        'userId': parseString(data: selectedUser.userId, defaultValue: ''),
        'branchId': selectedUser.branchId,
        'drCr': 'cr',
        'voucherTypeId': voucher!.id,
        'voucherTypeName': voucher!.name,
        'voucherNo': selectedUser.name,
        'subscriptionId': selectedUser.name,
        'amount': parseDouble(data: advanceAmount).toPrecision(2),
        'ledgerId': advanceUser.id,
        'ledgerName': advanceUser.name,
        'companyId': auth.state!.companyId,
        'createdAt': now,
        'updatedAt': now,
      });
    }

    if (paymentByAdvanceAmount > 0) {
      if (advanceUser == null) {
        throw Exception('No advance ledger found');
      }
      // Advance ledger payment entry
      batch.set(ledgerRef.doc(ledgerTransactionAdvanceId), {
        'id': ledgerTransactionAdvanceId,
        'billId': selectedUser.id,
        'userId': parseString(data: selectedUser.userId, defaultValue: ''),
        'branchId': selectedUser.branchId,
        'drCr': 'dr',
        'voucherTypeId': voucher!.id,
        'voucherTypeName': voucher!.name,
        'voucherNo': selectedUser.name,
        'subscriptionId': selectedUser.name,
        'amount': parseDouble(data: paymentByAdvanceAmount).toPrecision(2),
        'ledgerId': advanceUser.id,
        'ledgerName': advanceUser.name,
        'companyId': auth.state!.companyId,
        'createdAt': now,
        'updatedAt': now,
      });
    }

    // User ledger payment entry
    batch.set(ledgerRef.doc(ledgerTransactionId), {
      'id': ledgerTransactionId,
      'billId': selectedUser.id,
      'userId': parseString(data: selectedUser.userId, defaultValue: ''),
      'branchId': selectedUser.branchId,
      'drCr': 'cr',
      'voucherTypeId': voucher!.id,
      'voucherTypeName': voucher!.name,
      'voucherNo': selectedUser.name,
      'subscriptionId': selectedUser.name,
      'amount': parseDouble(data: advanceAmount > 0 ? paidAmount - advanceAmount : paidAmount).toPrecision(2),
      'ledgerId': selectedUser.userId,
      'ledgerName': selectedUser.userName,
      'companyId': auth.state!.companyId,
      'createdAt': now,
      'updatedAt': now,
    });

    if (paidAmount > 0) {
      // Payment method ledger payment entry
      batch.set(ledgerRef.doc(ledgerTransaction1Id), {
        'id': ledgerTransaction1Id,
        'billId': selectedUser.id,
        'userId': parseString(data: selectedUser.userId, defaultValue: ''),
        'branchId': selectedUser.branchId,
        'drCr': 'dr',
        'voucherTypeId': voucher!.id,
        'voucherTypeName': voucher!.name,
        'voucherNo': selectedUser.name,
        'subscriptionId': selectedUser.name,
        'amount': parseDouble(data: paidAmount).toPrecision(2),
        'ledgerId': selectedPaymentMode!.id,
        'ledgerName': selectedPaymentMode!.name,
        'companyId': auth.state!.companyId,
        'createdAt': now,
        'updatedAt': now,
      });
    }

    batch.update(db.collection('User').doc(selectedUser.userId), {'balance': FieldValue.increment(adjustedBalanceAmount)});
    await batch.commit();
    await getList(force: true);
    update();
  }
}
