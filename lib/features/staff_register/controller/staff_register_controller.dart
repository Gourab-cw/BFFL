import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';

import '../../login/data/user.dart';

class StaffRegisterController extends GetxController {
  List<SlotModel> register = [];
  List<String> selectedService = [];

  String searchTerm = "";

  DateTimeRange selectedDate = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  Future<void> fetchRegister() async {
    final db = await fb.getDB();
    if (auth.state == null) {
      throw Exception("No user found");
    }
    final UserG user = auth.state!;
    final finalQuery = db.collection('User');
    Query<Map<String, dynamic>> query = finalQuery;
    if (user.userType != UserType.admin) {
      query = query.where('branchId', isEqualTo: user.branchId);
    }
    query = query.where('isActive', isEqualTo: true);
    final resp = (await query.get()).docs.map((m) => SlotModel.fromFirestore(m)).toList();
    resp.sort(
      (a, b) => parseInt(
        data: (a.date + a.startTime).replaceAll(':', '').replaceAll('-', ''),
        defaultInt: 0,
      ).compareTo(parseInt(data: (b.date + b.startTime).replaceAll(':', '').replaceAll('-', ''), defaultInt: 0)),
    );
    final trainerIds = resp.map((m) => m.trainerId).where((t) => t != "").toSet().toList();
    if (trainerIds.isNotEmpty) {
      final trainers = (await db.collection('User').where('id', whereIn: trainerIds).get()).docs
          .map((m) => UserG.fromJSON(makeMapSerialize(m.data())))
          .toList();

      register = resp.map((m) {
        return m.copyWith(trainerName: trainers.firstWhereOrNull((t) => m.trainerId == t.id)?.name ?? "");
      }).toList();
    }
    update();
  }
}
