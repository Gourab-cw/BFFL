import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/holiday/data/holiday.dart';

import '../../login/data/user.dart';
import '../../login/repository/authenticator.dart';

class HolidayController extends GetxController {
  List<HolidayModel> holidays = [];
  FB fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  Future<void> getHolidays() async {
    try {
      final db = await fb.getDB();
      if (auth.state == null) throw Exception('User not found');
      Query query = db.collection('holiday').where('companyId', isEqualTo: auth.state!.companyId);
      if (auth.state?.userType == UserType.branchManager) {
        query = query.where('branchId', isEqualTo: auth.state!.branchId);
      }
      final resp = await query.get();
      holidays = resp.docs.map((e) => HolidayModel.fromFirebase(makeMapSerialize(e.data()), e.id)).toList();
      update();
    } catch (e) {
      showAlert('$e', AlertType.error);
    }
  }

  Future<void> updateHoliday(HolidayModel holiday) async {
    try {
      final db = await fb.getDB();
      if (auth.state == null) throw Exception('User not found');
      Map<String, dynamic> data = holiday.toJson();
      data["updatedAt"] = Timestamp.now();
      data["updatedBy"] = auth.state!.id;
      await db.collection('holiday').doc(holiday.id).update(data);
      holidays = holidays.map((e) => e.id == holiday.id ? holiday : e).toList();
      update();
    } catch (e) {
      showAlert('$e', AlertType.error);
    }
  }

  Future<void> createHoliday(HolidayModel holiday) async {
    try {
      final db = await fb.getDB();
      if (auth.state == null) throw Exception('User not found');
      holiday = holiday.copyWith(companyId: auth.state!.companyId, branchId: auth.state!.branchId);
      if (auth.state?.userType == UserType.branchManager) {
        holiday = holiday.copyWith(branchId: auth.state!.branchId);
      }
      Map<String, dynamic> data = holiday.toJson();
      data["createdAt"] = Timestamp.now();
      data["updatedAt"] = Timestamp.now();
      data["updatedBy"] = auth.state!.id;
      final resp = await db.collection('holiday').add(data);
      holiday = holiday.copyWith(id: resp.id);
      holidays.add(holiday);
      update();
    } catch (e) {
      showAlert('$e', AlertType.error);
    }
  }
}
