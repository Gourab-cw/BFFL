import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:intl/intl.dart';

import '../../calendar_report/controller/calendar_report_controller.dart';

class TodayBookings {
  int id;
  String serviceName;
  int totalBooked;
  List<CalendarSlotDetails> slots;
  TodayBookings({required this.id, required this.serviceName, required this.totalBooked, required this.slots});
}

class HomeController extends GetxController {
  List<SlotModel> todayBooking = [];
  List<SlotModel> bookings = [];
  late final SubscriptionController subscriptionController;
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  RxInt selectedIndex = (-1).obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? ss;

  Future<void> fetchTodayBooking() async {
    if (auth.state == null) {
      return;
    }
    if (auth.state!.userType == UserType.receptionist) {
      final db = await fb.getDB();
      if (ss == null) {
        ss = db.collection('slots').where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now())).snapshots().listen((d) {
          for (var f in d.docChanges) {
            final slot = SlotModel.fromFirestore(f.doc);
            switch (f.type) {
              case DocumentChangeType.added:
                todayBooking.add(slot);
                break;

              case DocumentChangeType.modified:
                final index = todayBooking.indexWhere((e) => e.id == slot.id);
                if (index != -1) {
                  todayBooking[index] = slot;
                }
                break;

              case DocumentChangeType.removed:
                todayBooking.removeWhere((e) => e.id == slot.id);
                break;
            }
          }
          update();
        });
      } else if (ss != null && ss!.isPaused) {
        ss!.resume();
      }
    } else if (auth.state!.userType == UserType.trainer) {
      final db = await fb.getDB();
      if (ss == null) {
        ss = db
            .collection('slots')
            .where('trainerId', isEqualTo: auth.state!.id)
            .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
            .snapshots()
            .listen((d) {
              for (var f in d.docChanges) {
                final slot = SlotModel.fromFirestore(f.doc);
                switch (f.type) {
                  case DocumentChangeType.added:
                    todayBooking.add(slot);
                    break;

                  case DocumentChangeType.modified:
                    final index = todayBooking.indexWhere((e) => e.id == slot.id);
                    if (index != -1) {
                      todayBooking[index] = slot;
                    }
                    break;

                  case DocumentChangeType.removed:
                    todayBooking.removeWhere((e) => e.id == slot.id);
                    break;
                }
                getUpcomingBookings();
              }
              update();
            });
      } else if (ss != null && ss!.isPaused) {
        ss!.resume();
      }
    }
  }

  Future<void> getUpcomingBookings() async {
    try {
      if (auth.state == null) {
        showAlert("Error! No user found", AlertType.error);
      }
      final db = await fb.getDB();
      QuerySnapshot<Map<String, dynamic>> resp;
      if (auth.state!.userType == UserType.receptionist) {
        resp = await db
            .collection('slots')
            .where('branchId', isEqualTo: auth.state!.branchId)
            .where('isActive', isEqualTo: true)
            .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
            .limit(4)
            .get();
      } else if (auth.state!.userType == UserType.trainer) {
        resp = await db
            .collection('slots')
            .where('branchId', isEqualTo: auth.state!.branchId)
            .where('isActive', isEqualTo: true)
            .where("trainerId", isEqualTo: auth.state!.id)
            .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
            .limit(10)
            .get();
      } else {
        resp = await db
            .collection('slots')
            .where('branchId', isEqualTo: auth.state!.branchId)
            .where('isActive', isEqualTo: true)
            .where("memberId", isEqualTo: auth.state!.id)
            .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
            .limit(4)
            .get();
      }

      final sessions = resp.docs.map((m) => SlotModel.fromFirestore(m)).toList();
      sessions.sort((a, b) => parseInt(data: a.date.replaceAll("-", ""), defaultInt: 0).compareTo(parseInt(data: b.date.replaceAll("-", ""), defaultInt: 0)));
      // sessions.sort(
      //   (a, b) => (parseInt(data: a.date.replaceAll("-", ""), defaultInt: 0)+parseInt(data: a.endTime.replaceAll(":", ""), defaultInt: 0)).compareTo(parseInt(data: a.date.replaceAll("-", ""), defaultInt: 0) + parseInt(data: b.endTime.replaceAll(":", ""), defaultInt: 0)),
      // );
      bookings = sessions;
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  List<TodayBookings> getTodaysBooking() {
    List<String> services = todayBooking.map((m) => m.serviceId).toSet().toList();
    List<TodayBookings> list = [];
    int i = 0;
    for (final f in services) {
      final slots = todayBooking.where((w) => w.serviceId == f).toList();
      slots.sort(
        (a, b) => parseInt(data: a.endTime.replaceAll(":", ""), defaultInt: 0).compareTo(parseInt(data: b.endTime.replaceAll(":", ""), defaultInt: 0)),
      );
      list.add(
        TodayBookings(
          id: i,
          serviceName: subscriptionController.list.firstWhereOrNull((s) => s.id == f)?.name ?? "",
          totalBooked: slots.map((m) => m.bookingCount).fold(0, (a, b) => a + b),
          slots: slots.map((s) => CalendarSlotDetails(slot: "${s.startTime} - ${s.endTime}", booked: s.bookingCount)).toList(),
        ),
      );
      i++;
    }
    return list;
  }

  List<ChartData> getHourlyBooking() {
    List<SlotModel> bb = [...todayBooking];
    bb.sort((a, b) => parseInt(data: a.endTime.replaceAll(":", ""), defaultInt: 0).compareTo(parseInt(data: b.endTime.replaceAll(":", ""), defaultInt: 0)));
    Map<String, int> bookingMap = {};
    for (var f in bb) {
      bookingMap[f.startTime] = (bookingMap[f.startTime] ?? 0) + f.bookingCount;
    }
    List<ChartData> list = [];
    bookingMap.keys.forEach((f) {
      list.add(ChartData(f, parseDouble(data: bookingMap[f], defaultValue: 0.0)));
    });
    return list;
  }

  // Trainer =======

  // Future<void> fetchTodayBooking() async {
  //   final db = await fb.getDB();
  //   if (ss == null) {
  //     ss = db.collection('slots').where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now())).snapshots().listen((d) {
  //       for (var f in d.docChanges) {
  //         final slot = SlotModel.fromFirestore(f.doc);
  //         switch (f.type) {
  //           case DocumentChangeType.added:
  //             todayBooking.add(slot);
  //             break;
  //
  //           case DocumentChangeType.modified:
  //             final index = todayBooking.indexWhere((e) => e.id == slot.id);
  //             if (index != -1) {
  //               todayBooking[index] = slot;
  //             }
  //             break;
  //
  //           case DocumentChangeType.removed:
  //             todayBooking.removeWhere((e) => e.id == slot.id);
  //             break;
  //         }
  //       }
  //       update();
  //     });
  //   } else if (ss != null && ss!.isPaused) {
  //     ss!.resume();
  //   }
  // }

  // Future<List<TodayBookings>> getTodaysBookingTrainer() async {
  //   final db = await fb.getDB();
  //   final id = auth.state?.name;
  //   final resp = await db.collection('slots').where('trainerId', isEqualTo: id).get();
  //   todayBooking = resp.docs.map((m) => SlotModel.fromFirestore(m)).toList();
  //   List<String> services = todayBooking.map((m) => m.serviceId).toSet().toList();
  //   List<TodayBookings> list = [];
  //   int i = 0;
  //   for (final f in services) {
  //     final slots = todayBooking.where((w) => w.serviceId == f).toList();
  //     slots.sort(
  //       (a, b) => parseInt(data: a.endTime.replaceAll(":", ""), defaultInt: 0).compareTo(parseInt(data: b.endTime.replaceAll(":", ""), defaultInt: 0)),
  //     );
  //     list.add(
  //       TodayBookings(
  //         id: i,
  //         serviceName: subscriptionController.list.firstWhereOrNull((s) => s.id == f)?.name ?? "",
  //         totalBooked: slots.map((m) => m.bookingCount).fold(0, (a, b) => a + b),
  //         slots: slots.map((s) => CalendarSlotDetails(slot: "${s.startTime} - ${s.endTime}", booked: s.bookingCount)).toList(),
  //       ),
  //     );
  //     i++;
  //   }
  //   return list;
  // }

  // this is for session time date update
  // Future<void> init() async {
  //   final db = await fb.getDB();
  //   final r1 = await db.collection('Subscription').get();
  //   final services = r1.docs.map((m) => ServiceModel.fromJson(makeMapSerialize(m.data()))).toList();
  //   final slotIds = services.map((s) => s.id).toSet().toList();
  //   final r2 = await db.collection('slots').where('serviceId', whereIn: slotIds).get();
  //   List<SessionModel> slots = r2.docs.map((m) => SessionModel.fromFirestore(m)).toList();
  //   logG(slots);
  //   final batch = db.batch();
  //   for (var m in slots) {
  //     batch.update(db.collection('slots').doc(m.id), {'trainerId': services.firstWhereOrNull((w) => w.id == m.serviceId)?.trainerId?[0] ?? ""});
  //   }
  //   //
  //   // for (var s in services) {
  //   //   batch.update(db.collection('session').doc(s.id), {
  //   //     'trainerId': s
  //   //   });
  //   // }
  //   await batch.commit();
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    ss?.cancel();
    super.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    subscriptionController = Get.find<SubscriptionController>();
    super.onInit();
  }
}
