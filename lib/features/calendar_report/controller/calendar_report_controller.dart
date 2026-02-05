import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:intl/intl.dart';

import '../../subscriptions/data/Subscription.dart';

class CalenderDayResult {
  int booked;
  int maxBookingSlot;
  double bookedPercentage;
  Color backgroundColor;
  Color fontColor;
  Color fontColor1;

  CalenderDayResult({
    required this.booked,
    required this.maxBookingSlot,
    required this.bookedPercentage,
    required this.backgroundColor,
    required this.fontColor,
    required this.fontColor1,
  });
}

class CalendarSlotDetails {
  String slot;
  int booked;
  CalendarSlotDetails({required this.slot, required this.booked});

  Map<String, dynamic> toJSON() {
    return {"slot": slot, "booked": booked};
  }
}

class CalenderDayDetails {
  int booked;
  int maxBookingSlot;
  double bookedPercentage;
  String serviceName;
  List<CalendarSlotDetails> slots;

  CalenderDayDetails({required this.booked, required this.maxBookingSlot, required this.bookedPercentage, required this.serviceName, required this.slots});
}

class CalenderReportController extends GetxController {
  List<SlotModel> slots = [];
  DateTime selectedDate = DateTime.now();
  final SubscriptionController sc = Get.find<SubscriptionController>();
  final FB fb = Get.find<FB>();

  Future<void> loadSlots() async {
    final db = await fb.getDB();
    final auth = Get.find<Authenticator>();
    final resp = await db
        .collection('slots')
        .where('branchId', isEqualTo: auth.state!.branchId)
        .where('isActive', isEqualTo: true)
        .where('month', isGreaterThanOrEqualTo: DateFormat('yyyy-MM').format(selectedDate))
        .get();
    slots = resp.docs.map((r) => SlotModel.fromFirestore(r)).toList();
    update();
  }

  Color _getGreenBg(double percentage) {
    if (percentage == 0) return Colors.transparent;
    if (percentage <= 10) return Colors.green.shade50;
    if (percentage <= 20) return Colors.green.shade100;
    if (percentage <= 30) return Colors.green.shade200;
    if (percentage <= 40) return Colors.green.shade300;
    if (percentage <= 60) return Colors.green.shade400;
    if (percentage <= 80) return Colors.green.shade600;
    if (percentage <= 90) return Colors.green.shade700;
    return Colors.transparent;
  }

  CalenderDayResult totalCount(String date) {
    List<SlotModel> sList = slots.where((s) => s.date == date).toList();
    List<String> serviceIds = slots.where((s) => s.date == date).map((m) => m.serviceId).toList();
    int bCount = sList.map((m) => m.bookingCount).fold(0, (a, b) => a + b);
    int maxCount = sc.list.where((w) => serviceIds.contains(w.id)).map((sc) => sc.maxBooking).fold(0, (a, b) => a + b);

    return CalenderDayResult(
      booked: bCount,
      maxBookingSlot: maxCount,
      bookedPercentage: parseDoubleWithFixLength(data: bCount / maxCount * 100, defaultValue: 0, doubleLength: 0),
      backgroundColor: _getGreenBg(parseDoubleWithFixLength(data: bCount / maxCount * 100, defaultValue: 0, doubleLength: 0)),
      fontColor: parseDoubleWithFixLength(data: bCount / maxCount * 100, defaultValue: 0, doubleLength: 0) >= 25 ? Colors.white : Colors.green.shade900,
      fontColor1: parseDoubleWithFixLength(data: bCount / maxCount * 100, defaultValue: 0, doubleLength: 0) >= 25 ? Colors.grey.shade200 : Colors.grey.shade600,
    );
  }

  List<CalenderDayDetails> getDayDetails() {
    String date = DateFormat("yyyy-MM-dd").format(selectedDate);
    List<SlotModel> sList = slots.where((s) => s.date == date).toList();
    List<String> serviceIds = slots.where((s) => s.date == date).map((m) => m.serviceId).toList();
    List<Subscription> serviceList = sc.list.where((w) => serviceIds.contains(w.id)).toList();
    int bCount = sList.map((m) => m.bookingCount).fold(0, (a, b) => a + b);
    int maxCount = sc.list.where((w) => serviceIds.contains(w.id)).map((sc) => sc.maxBooking).fold(0, (a, b) => a + b);
    List<CalenderDayDetails> details = [];
    for (final s in serviceList) {
      details.add(
        CalenderDayDetails(
          booked: sList.where((w) => w.serviceId == s.id).map((m) => m.bookingCount).fold(0, (a, b) => a + b),
          maxBookingSlot: s.maxBooking * sList.where((w) => w.serviceId == s.id).toList().length,
          bookedPercentage: parseDoubleWithFixLength(data: bCount / maxCount * 100, defaultValue: 0, doubleLength: 0),
          serviceName: s.name,
          slots: sList
              .where((w) => w.serviceId == s.id)
              .map((m) => CalendarSlotDetails(slot: "${m.startTime} - ${m.endTime}", booked: m.bookingCount))
              .toList(),
        ),
      );
    }
    return details;
  }
}
