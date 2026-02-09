import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../data/attendance_model.dart';

class AttendanceController extends GetxController {
  DateTimeRange range = DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 7), end: DateTime.now());
  bool todayHaveAttendance = false;
  List<AttendanceModel> list = [];

  List<Map<String, dynamic>> getAttendanceDatasource() {
    return list.map((l) => l.toJson()).toList();
  }

  Future<void> haveAttendance() async {
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      return;
    }
    final db = await fb.getDB();
    final resp = await db
        .collection('attendance')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .where(
          'userId',
          isEqualTo: parseString(data: auth.state!.id, defaultValue: ""),
        )
        .get();
    if (resp.docs.isNotEmpty) {
      todayHaveAttendance = true;
    } else {
      todayHaveAttendance = false;
    }
    update();
  }

  Future<void> giveAttendance() async {
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      return;
    }
    final db = await fb.getDB();
    final pos = await getCurrentLocation();
    String id = Uuid().v4();
    final resp = await db
        .collection('attendance')
        .doc(id)
        .set(
          AttendanceModel(
            id: id,
            userId: auth.state!.id,
            userType: auth.state!.userType,
            userName: auth.state!.name,
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            branchId: auth.state!.branchId,
            branchName: "",
            companyId: auth.state!.companyId,
            createdById: auth.state!.id,
            createdAt: Timestamp.now(),
            lat: pos.latitude,
            long: pos.longitude,
          ).toJson(),
        );
    await getAttendanceList();
    await haveAttendance();
    update();
  }

  Future<void> getAttendanceList() async {
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      return;
    }
    final resp = await db
        .collection('attendance')
        .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(range.start))
        .where(
          'userId',
          isEqualTo: parseString(data: auth.state!.id, defaultValue: ""),
        )
        .where('date', isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(range.end))
        .get();

    list = resp.docs.map<AttendanceModel>((r) => AttendanceModel.fromJson(makeMapSerialize(r.data()))).toList();

    final branches = list.map((l) => l.branchId).toSet().toList();
    final branchResp = (await db.collection('Branch').where('isActive', isEqualTo: true).where('id', whereIn: branches).get());
    final branchData = branchResp.docs.map(((m) => makeMapSerialize(m.data()))).toList();
    list = list.map((m) => m.copyWith(branchName: branchData.firstWhereOrNull((b) => b['id'] == m.branchId)?['name'] ?? "")).toList();
    update();
  }
}
