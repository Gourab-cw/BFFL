import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:intl/intl.dart';

import '../../../core/utility/firebase_service.dart';
import '../../login/repository/authenticator.dart';

class AdminHomeController extends GetxController {
  final fb = Get.find<FB>();
  DateTimeRange dashboardDate = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());
  DateTimeRange revenueDateRange = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());
  final auth = Get.find<Authenticator>();

  Future<int> getDashboardData() async {
    try {
      final db = await fb.getDB();
      final resp = await db.collection('User').where('userType', isEqualTo: userTypeMap2[UserType.member]).count().get();
      return resp.count ?? 0;
    } catch (e) {
      showAlert("$e", AlertType.error);
      return 0;
    }
  }

  Future<double> getDashboardDataRevenue() async {
    try {
      final db = await fb.getDB();

      final aggregateQuery = db
          .collection('payment')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(revenueDateRange.start))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(revenueDateRange.end))
          .aggregate(sum('paidAmount'));

      final AggregateQuerySnapshot resp = await aggregateQuery.get();
      return (resp.getSum('paidAmount') ?? 0).toDouble();
    } catch (e) {
      showAlert("$e", AlertType.error);
      return 0;
    }
  }

  Future<int> getDashboardDataServiceCount() async {
    try {
      final db = await fb.getDB();
      final resp = await db.collection('Subscription').where('isActive', isEqualTo: true).count().get();
      return resp.count ?? 0;
    } catch (e) {
      showAlert("$e", AlertType.error);
      return 0;
    }
  }

  Future<int> getDashboardDataBookingCount() async {
    try {
      final db = await fb.getDB();
      final resp = await db
          .collection('session')
          .where('isActive', isEqualTo: true)
          .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(dashboardDate.start))
          .where('date', isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(dashboardDate.end))
          .count()
          .get();
      return resp.count ?? 0;
    } catch (e) {
      showAlert("$e", AlertType.error);
      return 0;
    }
  }

  Future<int> getDashboardDataActiveSubs() async {
    try {
      final db = await fb.getDB();
      final resp = await db
          .collection('userSubscription')
          .where('isActive', isEqualTo: true)
          .where('endDate', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .count()
          .get();
      return resp.count ?? 0;
    } catch (e) {
      showAlert("$e", AlertType.error);
      return 0;
    }
  }

  Future<int> getDashboardDataTodaySession() async {
    try {
      final db = await fb.getDB();
      final resp = await db
          .collection('session')
          .where('isActive', isEqualTo: true)
          .where('date', isEqualTo: DateFormat('yyy-MM-dd').format(DateTime.now()))
          .count()
          .get();
      return resp.count ?? 0;
    } catch (e) {
      showAlert("$e", AlertType.error);
      return 0;
    }
  }

  Future<List<ChartData>> getDashboardDataSessionGraph() async {
    try {
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
    } catch (e) {
      showAlert("$e", AlertType.error);
      return [];
    }
  }

  Future<List<ChartData>> getDashboardDataRevenueGraph() async {
    try {
      final db = await fb.getDB();
      final now = DateTime.now();
      int daysCount = revenueDateRange.duration.inDays;
      List<DateTime> days = List.generate(daysCount, (index) => dashboardDate.end.subtract(Duration(days: index)));
      int count = 0;
      List<ChartData> data = [];
      final allResp = await Future.wait(
        List.generate(daysCount, (index) {
          return db
              .collection('payment')
              .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(days[index]))
              .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(days[index].add(const Duration(hours: 24))))
              .aggregate(sum('paidAmount'))
              .get();
        }),
      );
      for (int i = 0; i < allResp.length; i++) {
        data.add(ChartData(DateFormat('dd-MM-yyyy').format(days[i]), parseDouble(data: allResp[i].getSum('paidAmount'), defaultValue: 0)));
      }
      return data.reversed.toList();
    } catch (e) {
      showAlert("$e", AlertType.error);
      return [];
    }
  }
}
