import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/holiday/data/holiday.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../Service/data/service.dart';
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

  List<HolidayModel> holidayList = [];

  TextEditingController period = TextEditingController(text: '60');

  List<ServiceModel> getSelectedService(String date, String startTime, String endTime, SubscriptionController sc) {
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

  Future<void> slotDataFeelFromLastMonth() async {
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

    final firstDayThisMonth = DateTime(month!.year, month!.month - 1, 1);
    final firstDayNextMonth = DateTime(month!.year, month!.month, 1);
    int previousMonthsDays = firstDayNextMonth.difference(firstDayThisMonth).inDays;
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    final monthsResp = await Future.wait(
      List.generate(previousMonthsDays, (index) {
        return db.collection('slots').where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime(month!.year, month!.month - 1, index + 1))).get();
      }),
    );
    List<SlotModel> fetchedSlots = [];
    for (var element in monthsResp) {
      for (var element0 in element.docs) {
        final s = SlotModel.fromFirestore(element0);
        fetchedSlots.add(s);
      }
    }
    for (SlotModel s in fetchedSlots) {
      int slotIndex = slots.indexWhere(
        (ss) => ss.startTime == s.startTime && ss.endTime == s.endTime && ss.date == s.date && ss.serviceId == s.serviceId && s.trainerId == s.trainerId,
      );
      if (slotIndex == -1) {
        slots.add(
          s.copyWith(
            id: '',
            hasComplete: false,
            completeAt: null,
            bookingCount: 0,
            month: DateTime(month!.year, month!.month),
            totalAttend: 0,
            trainerRemarks: '',
            trainerStartTime: null,
            date: DateTime(month!.year, month!.month, DateFormat('yyyy-MM-dd').parse(s.date).day),
          ),
        );
      }
    }
    update();
  }

  Future<void> slotDataFeelFromSelectedWeek(int y, int m, int w, {int weekCount = 4}) async {
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
    String startDate = DateFormat('yyyy-MM-dd').format(DateTime(y, m, ((w - 1) * 7)));
    String endDate = DateFormat('yyyy-MM-dd').format(DateTime(y, m, ((w - 1) * 7)).add(const Duration(days: 7)));
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    final db = await fb.getDB();

    List<SlotModel> localSlots =
        (await db.collection('slots').where('date', isGreaterThanOrEqualTo: startDate).where('date', isLessThanOrEqualTo: endDate).get()).docs
            .map((m) => SlotModel.fromFirestore(m))
            .toList();
    List<SlotModel> modifiedSlots = [];

    Map<String, List<SlotModel>> dayWiseSlot = {};

    for (var element in localSlots) {
      String day = DateFormat('EEE').format(DateFormat('yyyy-MM-dd').parse(element.date));
      if (dayWiseSlot[day] == null) {
        dayWiseSlot[day] = [element];
      } else {
        dayWiseSlot[day]!.add(element);
      }
    }
    final now = DateTime.now();
    List.generate(days, (index) {
      String day = DateFormat('EEE').format(DateTime(now.year, now.month, index + 1));
      if (dayWiseSlot[day] != null) {
        for (var f in dayWiseSlot[day]!) {
          final value = f.copyWith(
            id: '',
            date: DateTime(now.year, now.month, index + 1),
            hasComplete: false,
            completeAt: null,
            bookingCount: 0,
            month: DateTime(now.year, now.month),
            totalAttend: 0,
            trainerRemarks: '',
            trainerStartTime: null,
          );
          modifiedSlots.add(value);
        }
      }
    });
    for (SlotModel s in modifiedSlots) {
      int slotIndex = slots.indexWhere(
        (ss) => ss.startTime == s.startTime && ss.endTime == s.endTime && ss.date == s.date && ss.serviceId == s.serviceId && s.trainerId == s.trainerId,
      );
      if (slotIndex == -1) {
        int startTime = parseInt(data: s.startTime.replaceAll(':', ''), defaultInt: 0);
        int endTime = parseInt(data: s.endTime.replaceAll(':', ''), defaultInt: 0);

        int lunchStartTime = parseInt(data: auth.branch!.lunchStart.replaceAll(':', ''), defaultInt: 0);
        int lunchEndTime = parseInt(data: auth.branch!.lunchEnd.replaceAll(':', ''), defaultInt: 0);

        bool isLunchBreak = startTime >= lunchStartTime && endTime <= lunchEndTime;

        if (!isLunchBreak) {
          slots.add(s);
        }
      }
    }
    update();
  }

  Future<void> saveSlots(FirebaseFirestore db, UserG user) async {
    // List<Map<String, dynamic>> data = [];
    final auth = Get.find<Authenticator>();
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
      int startTime = parseInt(data: s.startTime.replaceAll(':', ''), defaultInt: 0);
      int endTime = parseInt(data: s.endTime.replaceAll(':', ''), defaultInt: 0);

      int lunchStartTime = parseInt(data: auth.branch!.lunchStart.replaceAll(':', ''), defaultInt: 0);
      int lunchEndTime = parseInt(data: auth.branch!.lunchEnd.replaceAll(':', ''), defaultInt: 0);

      bool isLunchBreak = startTime >= lunchStartTime && endTime <= lunchEndTime;
      if (!isLunchBreak) {
        batch.set(docRef, data);
      }
    }
    await batch.commit();
  }

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    final auth = Get.find<Authenticator>();
    holidayList = (await db.collection('holiday').where('branchId', isEqualTo: auth.branch!.id).get()).docs
        .map((m) => HolidayModel.fromFirebase(makeMapSerialize(m.data()), m.id))
        .toList();
    super.onInit();
  }
}
