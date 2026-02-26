import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:intl/intl.dart';

class SlotDetailsTrainerController extends GetxController {
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();
  List<SlotModel> slots = [];
  DateTimeRange date = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 7)));

  Future<void> getSlots() async {
    if (auth.state == null) {
      throw Exception('Not authenticated');
    }
    final user = auth.state!;
    final db = await fb.getDB();
    Query<Map<String, dynamic>> finalQuery = db
        .collection('slots')
        .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(date.start))
        .where('date', isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(date.end))
        .where('isActive', isEqualTo: true);
    if (user.userType == UserType.trainer) {
      finalQuery = finalQuery.where('trainerId', isEqualTo: auth.state!.id);
    }
    if (user.userType != UserType.admin) {
      finalQuery = finalQuery.where('branchId', isEqualTo: auth.state!.branchId);
    }
    final resp = await finalQuery.get();
    slots = resp.docs.map((m) => SlotModel.fromFirestore(m)).toList();
    slots.sort(
      (a, b) => parseInt(
        data: (a.date + a.endTime).replaceAll('-', '').replaceAll(':', ''),
        defaultInt: 0,
      ).compareTo(parseInt(data: (b.date + b.endTime).replaceAll('-', '').replaceAll(':', ''), defaultInt: 0)),
    );
    // Map<String, List<SlotModel>> max = {};
    // for (final s in slots) {
    //   if (max[s.date] == null) {
    //     max[s.date] = [s];
    //   } else {
    //     max[s.date]?.add(s);
    //   }
    // }
    update();
  }
}
