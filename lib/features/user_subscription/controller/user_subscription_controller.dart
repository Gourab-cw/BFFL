import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../data/user_subscription.dart';

enum UserSubscriptionType { trial, dayWise, slotWise }

class UserSubscriptionController extends GetxController {
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  // UserSubscriptionType selectedSubscriptionType = UserSubscriptionType.trial;
  List<UserSubscription> allSubscriptions = [];

  List<Map<String, dynamic>> subDataGridData = <Map<String, dynamic>>[];
  // UserSubscription? selectedSubscription;

  Map<String, dynamic> user = {};
  String subscriptionId = "";
  String startDate = "";
  String endDate = "";
  int usedSessions = 0;
  int totalSessions = 0;
  double price = 0;

  UserSubscriptionType? subscriptionType;
  Future<void> saveUserSubscription() async {
    try {
      if (parseString(data: user['id'], defaultValue: '') == "") {
        return showAlert("No user found!", AlertType.error);
      }
      String branchId = parseString(data: auth.state?.branchId, defaultValue: "");
      if (branchId == "") {
        return showAlert("No branch found!", AlertType.error);
      }
      if (subscriptionType == null) {
        return showAlert("No subscription type found!", AlertType.error);
      }
      if (subDataGridData.isEmpty) {
        return showAlert("No subscription item found!", AlertType.error);
      }
      if (subDataGridData.any((s) => parseString(data: s['serviceId'], defaultValue: '') == '')) {
        return showAlert("Need to provide service! ", AlertType.error);
      }

      if (subscriptionType == UserSubscriptionType.trial || subscriptionType == UserSubscriptionType.slotWise) {
        if (subDataGridData.any((s) => parseInt(data: s['sessionCount'], defaultInt: 0) <= 0)) {
          return showAlert("Session count need!", AlertType.error);
        }
      }
      if (subscriptionType == UserSubscriptionType.dayWise) {
        if (subDataGridData.any((s) => s['startDate'] is! DateTime || s['endDate'] is! DateTime)) {
          return showAlert("Service need start and end date! ", AlertType.error);
        }
      }
      final db = await fb.getDB();

      final now = DateTime.now();
      final batch = db.batch();
      int count = ((await db.collection('userSubscription').count().get()).count) ?? 0;
      for (final f in subDataGridData) {
        final id = const Uuid().v4();
        count++;
        UserSubscription subscription = UserSubscription(
          id: id,
          name: 'SUB${count.toString().padLeft(4, '0')}',
          userId: parseString(data: user['id'], defaultValue: ''),
          branchId: branchId,
          subscriptionId: f['serviceId'],
          startDate: f['startDate'] is DateTime ? DateFormat('yyyy-MM-dd').format(f['startDate']) : '',
          endDate: f['endDate'] is DateTime ? DateFormat('yyyy-MM-dd').format(f['endDate']) : '',
          totalSessions: parseInt(data: f['sessionCount'], defaultInt: 0),
          remainingSessions: parseInt(data: f['sessionCount'], defaultInt: 0),
          usedSessions: 0,
          paidAt: null,
          isActive: false,
          createdAt: now,
          updatedAt: now,
          type: subscriptionType!,
        );
        batch.set(db.collection('userSubscription').doc(id), subscription.toJSON());
      }
      await batch.commit();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<List<Map<String, dynamic>>> getMembers(String q) async {
    try {
      final db = await fb.getDB();
      final auth = Get.find<Authenticator>();
      final resp = await db
          .collection("User")
          .where("userType", isEqualTo: userTypeMap2[UserType.member])
          .where("branchId", isEqualTo: auth.state?.branchId)
          .where("searchTerm", isGreaterThanOrEqualTo: q.replaceAll(" ", "").toLowerCase().trim())
          .where("searchTerm", isLessThanOrEqualTo: '${q.replaceAll(" ", "").toLowerCase().trim()}\uf8ff')
          .limit(4)
          .get();
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
      allSubscriptions = resp.docs.map((m) => UserSubscription.fromJSON(makeMapSerialize(m.data()))).toList();
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }
}
