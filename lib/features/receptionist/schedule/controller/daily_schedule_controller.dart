import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/controller/service_controller.dart';
import 'package:healthandwellness/features/Service/data/session_model.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:intl/intl.dart';

import '../../../Service/data/service.dart';

class DailyScheduleController extends GetxController {
  DateTime selectedDate = DateTime.now();
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();
  final sc = Get.find<SubscriptionController>();
  final serviceController = Get.find<ServiceController>();
  List<DateTime> dateList = [];
  Map<String, List<SessionModel>> daysSessionList = {};

  Future<void> getSessions() async {
    if (auth.state == null) {
      throw Exception("User branch not found!");
    }
    final db = await fb.getDB();
    List<SessionModel> daysSessionList0 = [];
    final resp = await db
        .collection('session')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate))
        .where('branchId', isEqualTo: auth.state!.branchId)
        .where('isActive', isEqualTo: true)
        .get();
    daysSessionList0 = resp.docs.map((m) => SessionModel.fromFirestore(m)).toList();
    List<String> users = [];
    for (final f in daysSessionList0) {
      users.add(f.trainerId);
      users.add(f.memberId);
    }
    if (users.isNotEmpty) {
      users = users.toSet().toList();
      final resp2 = await db.collection('User').where('id', whereIn: users).get();
      List<UserG> userList = resp2.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data()))).toList();
      daysSessionList0.sort(
        (a, b) => parseInt(
          data: (a.date + a.startTime).replaceAll(':', '').replaceAll('-', ''),
          defaultInt: 0,
        ).compareTo(parseInt(data: (b.date + b.startTime).replaceAll(':', '').replaceAll('-', ''), defaultInt: 0)),
      );
      daysSessionList0 = daysSessionList0
          .map(
            (m) => m.copyWith(
              memberName: userList.firstWhereOrNull((u) => u.id == m.memberId)?.name ?? "",
              memberContact1: userList.firstWhereOrNull((u) => u.id == m.memberId)?.mobile ?? "",
              trainerName: userList.firstWhereOrNull((u) => u.id == m.trainerId)?.name ?? "",
              serviceName: sc.list.firstWhereOrNull((u) => u.id == m.serviceId)?.name ?? "",
            ),
          )
          .toList();
    }

    Map<String, List<SessionModel>> finalDaysSessionList = {};
    for (final f in daysSessionList0) {
      if (finalDaysSessionList[f.startTime] == null) {
        finalDaysSessionList[f.startTime] = [f];
      } else {
        finalDaysSessionList[f.startTime]!.add(f);
      }
    }
    daysSessionList = finalDaysSessionList;
    update();
  }

  void getPrevDate() {
    dateList = List.generate(5, (index) {
      int count = -2;
      DateTime d0 = dateList.isEmpty ? selectedDate : dateList[0];
      DateTime d1 = DateTime(d0.year, d0.month, d0.day + count + index);
      return d1;
    });
    update();
  }

  void getNextDate() {
    dateList = List.generate(5, (index) {
      int count = -2;
      DateTime d0 = dateList.isEmpty ? selectedDate : dateList[4];
      DateTime d1 = DateTime(d0.year, d0.month, d0.day + count + index);
      return d1;
    });
    update();
  }

  Future<void> goForReschedule(SessionModel booking) async {
    serviceController.selectedReschedule = booking;
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    serviceController.selectedMember = {"id": booking.memberId, "name": booking.memberName};
    await serviceController.getServiceDetails(booking.serviceId, auth.state!.branchId, isReschedule: true);

    ServiceModel sv = ServiceModel.fromJson(makeMapSerialize((await db.collection('Subscription').doc(booking.serviceId).get()).data()));
    serviceController.selectedService = sv;
    if (!serviceController.services.any((s) => s.id == sv.id)) {
      serviceController.services.add(sv);
    }
    List<String> trainers = serviceController.selectedService!.trainerId;
    final resp1 = await db.collection("User").where('id', whereIn: trainers).get();
    List<UserG> trainser_users = resp1.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data()))).toList();
    for (var f in trainser_users) {
      if (!serviceController.trainers.any((a) => a.id == f.id)) {
        serviceController.trainers.add(f);
      }
    }
    Get.toNamed('/servicedetailsview?isReschedule=1', arguments: getSessions);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    dateList = List.generate(5, (index) {
      int count = -2;
      DateTime d0 = selectedDate;
      DateTime d1 = DateTime(d0.year, d0.month, d0.day + count + index);
      return d1;
    });
    update();
    super.onInit();
  }
}
