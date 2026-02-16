import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/Service/data/session_model.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:intl/intl.dart';

import '../../../core/utility/firebase_service.dart';
import '../../login/repository/authenticator.dart';

class MemberHomeController extends GetxController {
  List<SessionModel> bookings = [];
  SessionModel? selectedBooking;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? ss;
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  SessionModel? getTodaysBooking() {
    return bookings.firstWhereOrNull((b) => b.date == DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  List<SessionModel> getUpcomingBooking() {
    return bookings.where((b) => b.date != DateFormat('yyyy-MM-dd').format(DateTime.now())).toList();
  }

  Future<SessionModel> _modifyData(DocumentSnapshot<Map<String, dynamic>> f, FirebaseFirestore db) async {
    SessionModel session = SessionModel.fromFirestore(f);
    // List<String> slotIds = sessions.map((m) => m.slotId).toList();
    // List<String> trainerIds = sessions.map((m) => m.trainerId).toList();
    // List<String> servicesIds = sessions.map((m) => m.serviceId).toList();
    List<UserG> trainers = (await db.collection('User').where('id', isEqualTo: session.trainerId).get()).docs
        .map((m) => UserG.fromJSON(makeMapSerialize(m.data())))
        .toList();
    List<ServiceModel> services = (await db.collection('Subscription').where('id', isEqualTo: session.serviceId).get()).docs
        .map((m) => ServiceModel.fromJson(makeMapSerialize(m.data())))
        .toList();

    session = session.copyWith(
      trainerName: trainers.firstWhereOrNull((t) => t.id == session.trainerId)?.name ?? "",
      serviceName: services.firstWhereOrNull((t) => t.id == session.serviceId)?.name ?? "",
      serviceDetails: services.firstWhereOrNull((t) => t.id == session.serviceId)?.description ?? "",
    );
    return session;
  }

  Future<void> getBookings() async {
    if (auth.state == null) {
      return showAlert("No user found", AlertType.error);
    }
    final db = await fb.getDB();
    // if (ss != null) {
    //   await ss?.cancel();
    // }
    final resp = await db
        .collection('session')
        .where('memberId', isEqualTo: auth.state!.id)
        .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();
    bookings = [];
    for (var f in resp.docs) {
      final s = await _modifyData(f, db);
      bookings.add(s);
      if (selectedBooking != null && selectedBooking!.id == s.id) {
        selectedBooking = s;
      }
      EasyDebounce.debounce("updateBookings", const Duration(milliseconds: 600), () {
        update();
      });
    }
    update();
    // ss = db
    //     .collection('session')
    //     .where('memberId', isEqualTo: auth.state!.id)
    //     .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
    //     .snapshots()
    //     .listen((data) async {
    //       for (var f in data.docs) {
    //         final s = await _modifyData(f, db);
    //         int index = bookings.indexWhere((b) => b.id == s.id);
    //         if (index == -1) {
    //           bookings.add(s);
    //         } else {
    //           bookings.replaceRange(index, index + 1, [s]);
    //         }
    //         if (selectedBooking != null && selectedBooking!.id == s.id) {
    //           selectedBooking = s;
    //         }
    //         EasyDebounce.debounce("updateBookings", const Duration(milliseconds: 600), () {
    //           update();
    //         });
    //       }
    //     });
  }

  Future<void> markAttendance(SessionModel sm) async {
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      throw Exception("User not found!");
    }
    final db = await fb.getDB();
    try {
      await db.collection('session').doc(sm.id).update({'attendedAt': Timestamp.now(), 'hasAttend': true, 'attendanceGivenBy': auth.state!.id});
      await db.collection('slot').doc(sm.slotId).update({'totalAttend': FieldValue.increment(1)});
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<void> submitFeedback(SessionModel sm, String feedback) async {
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      throw Exception("User not found!");
    }
    final db = await fb.getDB();
    try {
      await db.collection('session').doc(sm.id).update({'feedback': feedback});
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("$e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ss?.pause();
    ss?.cancel();
    super.dispose();
  }
}
