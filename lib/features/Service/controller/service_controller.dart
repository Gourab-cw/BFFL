import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
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
  List<ServiceModel> services = [];
  List<SlotModel> slots = [];
  ServiceModel? selectedService;
  SlotModel? selectedSlot;
  Map<String, dynamic> selectedMember = {};
  DateTime? selectedDate;
  late FirebaseFirestore db;
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

  bool availableSlot(SlotModel s) {
    int sIndex = services.indexWhere((sv) => sv.id == s.serviceId);
    if (sIndex == -1) return false;
    return s.bookingCount < services[sIndex].maxBooking;
  }

  Future<List<Map<String, dynamic>>> getMemberList(String q) async {
    try {
      final resp = await db
          .collection("User")
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

  Future<void> bookSlot() async {
    try {
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

      final sUid = const Uuid().v4();

      final data = {
        "id": sUid,
        "isActive": true,
        "serviceId": selectedService!.id,
        "slotId": selectedSlot?.id,
        "date": selectedSlot?.date,
        "memberId": memberId,
        "trainerId": "",
        "hasAttend": false,
        "attendedAt": null,
        "feedback": "",
        "trainerFeedback": "",
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
        showAlert("Fully booked for the slot!", AlertType.error);
        return;
      }
      final batch = db.batch();
      batch.set(db.collection("session").doc(sUid), data);
      batch.update(db.collection("slots").doc(selectedSlot!.id), {"bookingCount": FieldValue.increment(1)});
      await batch.commit();
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
  }

  Future<void> getServiceDetails(String serviceId, String branchId) async {
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
        return s.date == date && formatHour.difference(DateTime(d.year, d.month, d.day, 12)).isNegative;
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
            formatHour.difference(DateTime(d.year, d.month, d.day, 18)).isNegative &&
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
