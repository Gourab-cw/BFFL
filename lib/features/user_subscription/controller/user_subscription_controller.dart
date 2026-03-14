import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/core/voucher/model/voucher_model.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:ulid/ulid.dart';

import '../data/user_subscription.dart';

enum UserSubscriptionType { trial, dayWise, slotWise }

class UserSubscriptionController extends GetxController {
  VoucherModel? voucher;
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  // UserSubscriptionType selectedSubscriptionType = UserSubscriptionType.trial;

  List<UserG> chargesLedgers = [];
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

  List<UserSubscription> allSubscriptions = [];
  List<UserSubscription> subscriptionList = [];

  List<Map<String, dynamic>> subDataGridData = <Map<String, dynamic>>[];
  // UserSubscription? selectedSubscription;

  Map<String, dynamic> user = {};
  String subscriptionId = "";
  String startDate = "";
  String endDate = "";
  int usedSessions = 0;
  int totalSessions = 0;
  double price = 0;

  Future<void> getVoucher() async {
    if (parseString(data: user['id'], defaultValue: '') == "") {
      throw Exception("No user found!");
    }
    final db = await fb.getDB();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      throw Exception('Not authenticated');
    }
    Query<Map<String, dynamic>> query = db
        .collection('voucherType')
        .where('docTypeId', isEqualTo: 19)
        .where('isActive', isEqualTo: true)
        .where('companyId', isEqualTo: auth.state!.companyId);

    if (auth.state!.userType != UserType.admin) {
      query = query.where('branchId', isEqualTo: auth.state!.branchId);
    }
    final resp = await query.get();
    voucher = VoucherModel.fromJson(makeMapSerialize(resp.docs.first.data()));
    update();
  }

  Future<void> saveUserSubscription() async {
    if (parseString(data: user['id'], defaultValue: '') == "") {
      throw Exception("No user found!");
    }
    String branchId = parseString(data: auth.state?.branchId, defaultValue: "");
    String companyId = parseString(data: auth.state?.companyId, defaultValue: "");
    if (companyId == "") {
      throw Exception("No company found!");
    }
    if (branchId == "") {
      throw Exception("No branch found!");
    }
    if (allSubscriptions.isEmpty) {
      throw Exception("No subscription item found!");
    }

    if (voucher == null) {
      throw Exception("Voucher not found!");
    }
    if (chargesLedgers.isEmpty) {
      throw Exception("No charges ledger found!");
    }
    final db = await fb.getDB();

    final now = Timestamp.fromDate(DateTime.now());
    final batch = db.batch();
    final ref = db.collection('userSubscription');
    final ledgerRef = db.collection('transaction');
    for (final f in allSubscriptions) {
      final ledgerTransactionId = Ulid().toString();
      final ledgerTransaction1Id = Ulid().toString();
      final ledgerTransaction2Id = Ulid().toString();
      final ledgerTransaction3Id = Ulid().toString();
      final ledgerTransaction4Id = Ulid().toString();

      batch.set(ledgerRef.doc(ledgerTransactionId), {
        'id': ledgerTransactionId,
        'billId': f.id,
        'userId': parseString(data: f.userId, defaultValue: ''),
        'branchId': branchId,
        'drCr': 'dr',
        'voucherTypeId': f.voucherTypeId,
        'voucherTypeName': f.voucherTypeName,
        'voucherNo': f.name,
        'subscriptionId': f.subscriptionId,
        'subscriptionName': f.subscriptionName,
        'amount': parseDouble(data: f.netAmount).toPrecision(2),
        'ledgerId': f.userId,
        'ledgerName': f.userName,
        'companyId': companyId,
        'createdAt': now,
        'updatedAt': now,
      });

      batch.set(ledgerRef.doc(ledgerTransaction1Id), {
        'id': ledgerTransaction1Id,
        'billId': f.id,
        'userId': parseString(data: f.userId, defaultValue: ''),
        'branchId': branchId,
        'drCr': 'cr',
        'voucherTypeId': f.voucherTypeId,
        'voucherTypeName': f.voucherTypeName,
        'voucherNo': f.name,
        'subscriptionId': f.subscriptionId,
        'subscriptionName': f.subscriptionName,
        'amount': f.grossAmount,
        'ledgerId': f.subscriptionId,
        'ledgerName': f.subscriptionName,
        'companyId': companyId,
        'createdAt': now,
        'updatedAt': now,
        'remarks':
            'Subscription of ${parseDateToString(data: f.startDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: '')} - ${parseDateToString(data: f.endDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: '')} ( ${f.totalSessions} sessions )',
      });

      if (f.discAmount > 0) {
        batch.set(ledgerRef.doc(ledgerTransaction2Id), {
          'id': ledgerTransaction2Id,
          'billId': f.id,
          'userId': parseString(data: f.userId, defaultValue: ''),
          'branchId': branchId,
          'drCr': 'dr',
          'voucherTypeId': f.voucherTypeId,
          'voucherTypeName': f.voucherTypeName,
          'voucherNo': f.name,
          'subscriptionId': f.subscriptionId,
          'subscriptionName': f.subscriptionName,
          'amount': parseDouble(data: f.discAmount).toPrecision(2),
          'ledgerId': chargesLedgers.firstWhere((m) => m.base == 'discount').id,
          'ledgerName': chargesLedgers.firstWhere((m) => m.base == 'discount').name,
          'companyId': companyId,
          'createdAt': now,
          'updatedAt': now,
        });
      }
      batch.set(ledgerRef.doc(ledgerTransaction3Id), {
        'id': ledgerTransaction3Id,
        'billId': f.id,
        'userId': parseString(data: f.userId, defaultValue: ''),
        'branchId': branchId,
        'drCr': 'cr',
        'voucherTypeId': f.voucherTypeId,
        'voucherTypeName': f.voucherTypeName,
        'voucherNo': f.name,
        'subscriptionId': f.subscriptionId,
        'subscriptionName': f.subscriptionName,
        'amount': parseDouble(data: f.taxAmount / 2).toPrecision(2),
        'ledgerId': chargesLedgers.firstWhere((m) => m.base == 'cgst').id,
        'ledgerName': chargesLedgers.firstWhere((m) => m.base == 'cgst').name,
        'companyId': companyId,
        'createdAt': now,
        'updatedAt': now,
      });
      batch.set(ledgerRef.doc(ledgerTransaction4Id), {
        'id': ledgerTransaction4Id,
        'billId': f.id,
        'userId': parseString(data: f.userId, defaultValue: ''),
        'branchId': branchId,
        'drCr': 'cr',
        'voucherTypeId': f.voucherTypeId,
        'voucherTypeName': f.voucherTypeName,
        'voucherNo': f.name,
        'subscriptionId': f.subscriptionId,
        'subscriptionName': f.subscriptionName,
        'amount': parseDouble(data: f.taxAmount / 2).toPrecision(2),
        'ledgerId': chargesLedgers.firstWhere((m) => m.base == 'sgst').id,
        'ledgerName': chargesLedgers.firstWhere((m) => m.base == 'sgst').name,
        'companyId': companyId,
        'createdAt': now,
        'updatedAt': now,
      });

      batch.set(ref.doc(f.id), {...f.toJSON(), 'companyId': auth.state!.companyId, 'createdBy': auth.state!.id});
    }
    // int count = ((await db.collection('userSubscription').count().get()).count) ?? 0;
    // for (final f in subDataGridData) {
    //   final id = const Uuid().v4();
    //   // count++;
    //   // UserSubscription subscription = UserSubscription(
    //   //   id: id,
    //   //   name: 'SUB${count.toString().padLeft(4, '0')}',
    //   //   userId: parseString(data: user['id'], defaultValue: ''),
    //   //   branchId: branchId,
    //   //   subscriptionId: f['serviceId'],
    //   //   startDate: f['startDate'] is DateTime ? DateFormat('yyyy-MM-dd').format(f['startDate']) : '',
    //   //   endDate: f['endDate'] is DateTime ? DateFormat('yyyy-MM-dd').format(f['endDate']) : '',
    //   //   totalSessions: parseInt(data: f['sessionCount'], defaultInt: 0),
    //   //   remainingSessions: parseInt(data: f['sessionCount'], defaultInt: 0),
    //   //   usedSessions: 0,
    //   //   isActive: false,
    //   //   createdAt: now,
    //   //   updatedAt: now,
    //   // );
    //   // batch.set(db.collection('userSubscription').doc(id), subscription.toJSON());
    // }
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getMembers(String q) async {
    try {
      final db = await fb.getDB();
      final auth = Get.find<Authenticator>();
      if (auth.state == null) {
        throw Exception('Not authenticated');
      }
      Query<Map<String, dynamic>> query = db
          .collection("User")
          .where("userType", isEqualTo: userTypeMap2[UserType.member])
          .where("isActive", isEqualTo: true)
          .where("searchTerm", isGreaterThanOrEqualTo: q.replaceAll(" ", "").toLowerCase().trim())
          .where("searchTerm", isLessThanOrEqualTo: '${q.replaceAll(" ", "").toLowerCase().trim()}\uf8ff')
          .limit(10);
      if (auth.state!.userType != UserType.admin) {
        query = query.where("branchId", isEqualTo: auth.state?.branchId);
      }
      final resp = await query.get();
      return resp.docs.map((m) => makeMapSerialize(m.data())).toList();
    } catch (e) {
      showAlert("$e", AlertType.error);
      return [];
    }
  }

  Future<void> getSubscriptionList(String userId) async {
    try {
      final db = await fb.getDB();
      final auth = Get.find<Authenticator>();
      if (auth.state == null) {
        showAlert("No branch found!", AlertType.error);
      }
      final resp = await db
          .collection('userSubscription')
          .where('branchId', isEqualTo: auth.state!.branchId)
          .where('userId', isEqualTo: userId)
          .limit(5)
          .orderBy('createdAt')
          .get();
      subscriptionList = resp.docs.map((m) => UserSubscription.fromJSON(makeMapSerialize(m.data()))).toList();
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }
}
