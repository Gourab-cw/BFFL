import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:intl/intl.dart';

import '../../login/data/user.dart';

class SlotRegisterController extends GetxController {
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
    CollectionReference<Map<String, dynamic>> finalQuery = db.collection('slots');
    Query<Map<String, dynamic>> query = finalQuery;
    if (user.userType == UserType.receptionist || user.userType == UserType.branchManager) {
      query = query.where('branchId', isEqualTo: user.branchId);
    }
    if (user.userType == UserType.trainer) {
      query = query.where('trainerId', isEqualTo: user.id);
      query = query.where('branchId', isEqualTo: user.branchId);
    }
    query = query.where('isActive', isEqualTo: true);
    query = query.where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate.start));
    query = query.where('date', isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate.end));
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
