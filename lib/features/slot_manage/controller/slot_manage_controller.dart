import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:healthandwellness/features/subscriptions/data/Subscription.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../login/data/user.dart';
import '../data/slot_making_model.dart';

class SlotControllerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SlotController(), fenix: true);
  }
}

class SlotController extends GetxController {
  DateTime? month;
  DateTime? dailyStart;
  DateTime? dailyEnd;
  List<Map<String, dynamic>> slotData = <Map<String, dynamic>>[];

  List<SlotModel> slots = [];

  TextEditingController period = TextEditingController(text: '60');

  List<Subscription> getSelectedService(String date, String startTime, String endTime, SubscriptionController sc) {
    final List<String> newL = [];
    final l = slots
        .where((s) {
          if (s.id == "" && s.date == date && s.startTime == startTime && s.endTime == endTime) {
            newL.add(s.serviceId);
          }
          return s.date == date && s.startTime == startTime && s.endTime == endTime;
        })
        .map((m) => m.serviceId)
        .toList();
    return sc.list.where((w) => l.contains(w.id)).map((m) {
      if (newL.contains(m.id)) {
        return m.copyWith(isNewSlot: true);
      }
      return m;
    }).toList();
  }

  Future<void> slotDataFeel() async {
    if (month == null) {
      showAlert("Select a month to continue!", AlertType.error);
      return;
    }
    if (dailyStart == null) {
      showAlert("Select start time to continue!", AlertType.error);
      return;
    }
    if (dailyEnd == null) {
      showAlert("Select end time to continue!", AlertType.error);
      return;
    }
    List<Map<String, dynamic>> slotsFeelData = generateOneHourSlots(
      DateFormat("HH:mm").format(dailyStart!),
      DateFormat("HH:mm").format(dailyEnd!),
      parseInt(data: period.text, defaultInt: 60),
    );

    final firstDayThisMonth = DateTime(month!.year, month!.month, 1);
    final firstDayNextMonth = DateTime(month!.year, month!.month + 1, 1);
    int days = firstDayNextMonth.difference(firstDayThisMonth).inDays;

    for (int i = 0; i < slotsFeelData.length; i++) {
      for (int j = 0; j < days; j++) {
        slotsFeelData[i] = makeMapSerialize({...slotsFeelData[i], (j + 1).toString(): []});
      }
    }
    slotData = slotsFeelData;

    String startDate = DateFormat('yyyy-MM-dd').format(DateTime(month!.year, month!.month, 1));
    String endDate = DateFormat('yyyy-MM-dd').format(DateTime(month!.year, month!.month + 1, 1));
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    slots = (await db.collection('slots').where('date', isGreaterThanOrEqualTo: startDate).where('date', isLessThan: endDate).get()).docs
        .map((m) => SlotModel.fromFirestore(m))
        .toList();
    update();
  }

  Future<void> saveSlots(FirebaseFirestore db, UserG user) async {
    // List<Map<String, dynamic>> data = [];
    final batch = db.batch();
    for (final SlotModel s in slots) {
      final data = makeMapSerialize(s.toFirestore());
      String uid = Uuid().v4();
      if (data['id'] != "" || data['id'].length > 5) {
        uid = data['id'];
      } else {
        data['id'] = uid;
      }
      final docRef = db.collection('slots').doc(uid);
      batch.set(docRef, data);
    }
    await batch.commit();
  }
}
