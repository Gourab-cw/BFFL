import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:intl/intl.dart';

import '../../../core/utility/firebase_service.dart';
import '../../login/repository/authenticator.dart';

class AdminHomeController extends GetxController {
  final fb = Get.find<FB>();
  DateTimeRange dashboardDate = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 15)), end: DateTime.now());
  final auth = Get.find<Authenticator>();

  Future<int> getDashboardData() async {
    final db = await fb.getDB();
    final resp = await db.collection('User').where('userType', isEqualTo: userTypeMap2[UserType.member]).count().get();
    return resp.count ?? 0;
  }

  Future<int> getDashboardDataServiceCount() async {
    final db = await fb.getDB();
    final resp = await db.collection('Subscription').where('isActive', isEqualTo: true).count().get();
    return resp.count ?? 0;
  }

  Future<int> getDashboardDataBookingCount() async {
    final db = await fb.getDB();
    final resp = await db
        .collection('session')
        .where('isActive', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(dashboardDate.start))
        .where('date', isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(dashboardDate.end))
        .count()
        .get();
    return resp.count ?? 0;
  }

  Future<int> getDashboardDataActiveSubs() async {
    final db = await fb.getDB();
    final resp = await db
        .collection('userSubscription')
        .where('isActive', isEqualTo: true)
        .where('paidAt', isNull: false)
        .where('endDate', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .count()
        .get();
    return resp.count ?? 0;
  }

  Future<int> getDashboardDataTodaySession() async {
    final db = await fb.getDB();
    final resp = await db
        .collection('session')
        .where('isActive', isEqualTo: true)
        .where('date', isEqualTo: DateFormat('yyy-MM-dd').format(DateTime.now()))
        .count()
        .get();
    return resp.count ?? 0;
  }

  Future<List<ChartData>> getDashboardDataSessionGraph() async {
    final db = await fb.getDB();
    final now = DateTime.now();
    int daysCount = dashboardDate.duration.inDays;
    List<String> days = List.generate(daysCount, (index) => DateFormat('yyyy-MM-dd').format(dashboardDate.end.subtract(Duration(days: index))));
    int count = 0;
    List<ChartData> data = [];
    final allResp = await Future.wait(
      List.generate(daysCount, (index) {
        return db.collection('session').where('isActive', isEqualTo: true).where('date', isEqualTo: days[index]).count().get();
      }),
    );
    for (int i = 0; i < allResp.length; i++) {
      data.add(ChartData(days[i], parseDouble(data: allResp[i].count, defaultValue: 0)));
    }
    return data.reversed.toList();
  }
}
