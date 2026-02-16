import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/Service/data/session_model.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:healthandwellness/features/user_subscription/data/user_subscription.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utility/firebase_service.dart';

class ServiceControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceController(), fenix: true);
    // TODO: implement dependencies
  }
}

class ServiceController extends GetxController {
  SessionModel? selectedReschedule;
  List<UserG> trainers = [];
  List<ServiceModel> services = [];
  List<SlotModel> slots = [];
  ServiceModel? selectedService;
  UserSubscription? userSubscription;
  SlotModel? selectedSlot;
  Map<String, dynamic> selectedMember = {};
  DateTime? selectedDate;
  late FirebaseFirestore db;

  final auth = Get.find<Authenticator>();
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    final fb = Get.find<FB>();
    db = await fb.getDB();
    super.onInit();
  }

  bool? haveSlot(String date) {
    List<SlotModel> s = slots.where((s) => s.serviceId == parseString(data: selectedService?.id, defaultValue: "") && s.date == date).toList();
    if (s.isEmpty) return null;
    int count = s.map((m) => m.bookingCount).fold(0, (a, b) => a + b);
    return count < parseInt(data: selectedService?.maxBooking, defaultInt: 0) * s.length;
  }

  bool? availableSlot(SlotModel s, {SessionModel? withRescheduleData}) {
    if (withRescheduleData != null) {
      if (s.date == withRescheduleData.date && s.startTime == withRescheduleData.startTime && s.endTime == withRescheduleData.endTime) {
        return null;
      }
    }
    int now = parseInt(data: DateFormat('yyyy-MM-dd').format(DateTime.now()).replaceAll('-', ''), defaultInt: 0);
    int slotDate = parseInt(data: s.date.replaceAll('-', ''), defaultInt: 0);
    if (slotDate == now) {
      int currentTime = parseInt(data: DateFormat('HH:mm').format(DateTime.now()).replaceAll(':', ''), defaultInt: 0);
      int endTime = parseInt(data: s.endTime.replaceAll(':', ''), defaultInt: 0);
      return endTime > currentTime;
    }
    int sIndex = services.indexWhere((sv) => sv.id == s.serviceId);
    if (sIndex == -1) return false;
    return s.bookingCount < services[sIndex].maxBooking;
  }

  Future<List<Map<String, dynamic>>> getMemberList(String q) async {
    try {
      final resp = await db
          .collection("User")
          .where('userType', isEqualTo: userTypeMap2[UserType.member])
          .where("searchTerm", isGreaterThanOrEqualTo: q.replaceAll(" ", "").toLowerCase().trim())
          .where("searchTerm", isLessThanOrEqualTo: '${q.replaceAll(" ", "").toLowerCase().trim()}\uf8ff')
          .limit(20)
          .get();
      return resp.docs
          .map(
            (doc) => ({
              "id": doc.id,
              "name": parseString(data: doc.data()?['name'], defaultValue: ""),
              "address": parseString(data: doc.data()?['address'], defaultValue: ""),
            }),
          )
          .toList();
    } catch (e) {
      showAlert("$e", AlertType.error);
      return [];
    }
  }

  Future<void> bookSlot({SessionModel? reschedule}) async {
    try {
      if (userSubscription == null) {
        showAlert("Subscription not found!", AlertType.error);
        return;
      }
      if (selectedService == null) {
        showAlert("Select a service to continue!", AlertType.error);
        return;
      }

      if (selectedSlot == null) {
        showAlert("Select a slot to continue!", AlertType.error);
        return;
      }

      String memberId = parseString(data: selectedMember["id"], defaultValue: "");

      if (memberId.isEmpty) {
        showAlert("Select a member to continue!", AlertType.error);
        return;
      }
      if (selectedService!.trainerId.isEmpty) {
        showAlert("No trainer found!", AlertType.error);
        return;
      }

      final sUid = const Uuid().v4();

      final data = {
        "id": sUid,
        "isActive": true,
        "serviceId": selectedService!.id,
        "slotId": selectedSlot?.id,
        "startTime": selectedSlot?.startTime,
        "endTime": selectedSlot?.endTime,
        "date": selectedSlot?.date,
        "memberId": memberId,
        "subscriptionId": userSubscription!.id,
        "trainerId": selectedService!.trainerId[0],
        "hasAttend": false,
        "attendedAt": null,
        "feedback": "",
        "trainerFeedback": "",
        "isTrail": false,
        "createdAt": Timestamp.now(),
      };

      final slotData = await db.collection("slots").doc(selectedSlot!.id).get();
      if (!slotData.exists) {
        showAlert("Slot not exist!", AlertType.error);
        return;
      }
      int booked = parseInt(data: makeMapSerialize(slotData.data())["bookingCount"], defaultInt: -1);
      if (booked == -1) {
        showAlert("Booking data issue!", AlertType.error);
        return;
      }
      if (booked >= selectedService!.maxBooking) {
        throw Exception("Fully booked for the slot!");
      }
      final sessionResp = await db
          .collection('session')
          .where('slotId', isEqualTo: selectedSlot?.id)
          .where('memberId', isEqualTo: memberId)
          .where('isActive', isEqualTo: true)
          .get();
      if (sessionResp.docs.isNotEmpty) {
        throw Exception("You already have booking on this slot!");
      }
      final batch = db.batch();
      batch.set(db.collection("session").doc(sUid), data);
      batch.update(db.collection("slots").doc(selectedSlot!.id), {"bookingCount": FieldValue.increment(1)});
      if (reschedule != null) {
        batch.update(db.collection("slots").doc(reschedule.slotId), {"bookingCount": FieldValue.increment(-1)});
        batch.delete(db.collection("session").doc(reschedule.id));
        batch.set(db.collection("history").doc(reschedule.memberId).collection('session').doc(reschedule.id), {
          'updateAt': Timestamp.now(),
          ...reschedule.toFirestore(),
        });
      } else {
        batch.update(db.collection("userSubscription").doc(userSubscription!.id), {"remainingSessions": FieldValue.increment(-1)});
      }
      userSubscription = userSubscription!.copyWith(remainingSessions: (userSubscription!.remainingSessions - 1));
      await batch.commit();
      update();
      showAlert("Session booked successfully", AlertType.success);
    } on FirebaseException catch (e) {
      showAlert(e.message ?? "Firestore error occurred", AlertType.error);
    } catch (e, st) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> getServiceList() async {
    final resp = await db.collection("Subscription").where('isActive', isEqualTo: true).get();
    if (resp.docs.isNotEmpty) {
      services = resp.docs.map((doc) {
        return ServiceModel.fromJson(doc.data());
      }).toList();
      update();
    }
    List<String> trainerIds = [];
    for (final s in services) {
      for (var s in s.trainerId) {
        trainerIds.add(s);
      }
    }
    final resp1 = await db.collection("User").where('id', whereIn: trainerIds).get();
    trainers = resp1.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data()))).toList();
    update();
  }

  Future<void> getServiceDetails(String serviceId, String branchId, {isReschedule = false}) async {
    if (auth.state == null) {
      return showAlert("No user found", AlertType.error);
    }
    final query = db
        .collection('userSubscription')
        .where('paidAt', isNull: false)
        .where('subscriptionId', isEqualTo: serviceId)
        .where('isActive', isEqualTo: true)
        .where('endDate', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (!isReschedule) {
      query.where('remainingSessions', isGreaterThan: 0);
    }
    final availableSubscription = await query.get();
    List<UserSubscription> userSubs = availableSubscription.docs.map((m) => UserSubscription.fromJSON(makeMapSerialize(m.data()))).toList();
    List<UserSubscription> userSubs1 = userSubs.where((w) {
      if (w.endDate == '') {
        return true;
      }
      return !DateFormat('yyyy-MM-dd').parse(w.endDate).difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).isNegative;
    }).toList();
    if (userSubs1.isEmpty) {
      throw Exception("You have no subscription for this service");
    }
    userSubscription = null;
    userSubscription = userSubs1[0];
    final String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
    final resp = await db
        .collection('slots')
        .where('branchId', isEqualTo: branchId)
        .where('serviceId', isEqualTo: serviceId)
        .where('isActive', isEqualTo: true)
        .where('month', isGreaterThanOrEqualTo: currentMonth)
        .orderBy('month')
        .get();

    if (resp.docs.isNotEmpty) {
      slots = resp.docs.map((doc) {
        return SlotModel.fromFirestore(doc);
      }).toList();
      update();
    }
  }

  DateTime? _formatHour(String hour, String date) {
    if (hour.contains(':') && hour.split(':').length == 2) {
      DateTime d = DateFormat("yyyy-MM-dd").parse(date);
      return DateTime(d.year, d.month, d.day, parseInt(data: hour.split(':')[0], defaultInt: 0), parseInt(data: hour.split(':')[1], defaultInt: 0));
    }
    return null;
  }

  List<SlotModel> getSelectedDaySlots(String date) {
    DateTime d = DateFormat('yyyy-MM-dd').parse(date);
    final s = slots.where((s) {
      DateTime? formatHour = _formatHour(s.endTime, s.date);
      if (formatHour == null) {
        return false;
      } else {
        return s.date == date && formatHour.difference(DateTime(d.year, d.month, d.day, 13)).isNegative;
      }
    }).toList();
    s.sort((a, b) => parseInt(data: a.endTime.replaceAll(":", ""), defaultInt: 0).compareTo(parseInt(data: b.endTime.replaceAll(":", ""), defaultInt: 0)));
    return s;
  }

  List<SlotModel> getSelectedAfterNoonSlots(String date) {
    DateTime d = DateFormat('yyyy-MM-dd').parse(date);
    final s = slots.where((s) {
      DateTime? formatHour = _formatHour(s.endTime, s.date);
      if (formatHour == null) {
        return false;
      } else {
        return s.date == date &&
            formatHour.difference(DateTime(d.year, d.month, d.day, 19)).isNegative &&
            !formatHour.difference(DateTime(d.year, d.month, d.day, 13)).isNegative;
      }
    }).toList();
    s.sort((a, b) => parseInt(data: a.endTime.replaceAll(":", ""), defaultInt: 0).compareTo(parseInt(data: b.endTime.replaceAll(":", ""), defaultInt: 0)));
    return s;
  }

  List<SlotModel> getSelectedEveSlots(String date) {
    DateTime d = DateFormat('yyyy-MM-dd').parse(date);
    final s = slots.where((s) {
      DateTime? formatHour = _formatHour(s.endTime, s.date);
      if (formatHour == null) {
        return false;
      } else {
        return s.date == date && !formatHour.difference(DateTime(d.year, d.month, d.day, 19)).isNegative;
      }
    }).toList();
    s.sort((a, b) => parseInt(data: a.endTime.replaceAll(":", ""), defaultInt: 0).compareTo(parseInt(data: b.endTime.replaceAll(":", ""), defaultInt: 0)));
    return s;
  }
}
