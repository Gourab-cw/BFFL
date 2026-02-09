import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/session_model.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';

class SlotDetailsController extends GetxController {
  SlotModel? slot;
  List<SessionModel> sessions = [];

  SessionModel? selectedSession;

  TextEditingController remarks = TextEditingController();
  TextEditingController feedbackCtrl = TextEditingController();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? sessionListener;

  Future<void> giveFeedback(SessionModel sm) async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    if (feedbackCtrl.text.trim().isEmpty) {
      throw Exception("Enter proper feedback to continue!");
    }
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    try {
      await db.collection('session').doc(sm.id).update({'trainerFeedback': feedbackCtrl.text.trim()});
    } on FirebaseException catch (e) {
      throw Exception("${e.message}");
    } catch (e) {
      throw Exception("${e}");
    }
  }

  Future<void> getSlotDetails() async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    sessionListener = db.collection('session').where('slotId', isEqualTo: slot!.id).where('isActive', isEqualTo: true).snapshots().listen((data) async {
      for (var f in data.docChanges) {
        final ss = SessionModel.fromFirestore(f.doc);
        switch (f.type) {
          case DocumentChangeType.added:
            if (sessions.indexWhere((s) => s.id == ss.id) == -1) {
              sessions.add(ss);
              await updateSession(db, ss);
              EasyDebounce.debounce("sessionUpdate", const Duration(milliseconds: 600), () {
                update();
              });
            }
            break;

          case DocumentChangeType.modified:
            int index = sessions.indexWhere((s) => s.id == ss.id);
            sessions.replaceRange(index, index + 1, [ss]);
            await updateSession(db, ss);
            EasyDebounce.debounce("sessionUpdate", const Duration(milliseconds: 600), () {
              update();
            });
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      }
    });
  }

  Future<void> endSlot() async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    try {
      await db.collection('slots').doc(slot!.id).update({'completeAt': Timestamp.now(), 'hasComplete': true});
      final resp = await db.collection('slots').doc(slot!.id).get();
      if (resp.exists && resp.data() != null) {
        slot = SlotModel.fromFirestore(resp);
        update();
      }
    } on FirebaseException catch (e) {
      showAlert("${e.message}", AlertType.error);
    } catch (e) {
      showAlert("${e}", AlertType.error);
    }
  }

  Future<void> markAttendance(SessionModel sm) async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      throw Exception("User not found!");
    }
    final db = await fb.getDB();
    try {
      await db.collection('session').doc(sm.id).update({'attendedAt': Timestamp.now(), 'hasAttend': true, 'attendanceGivenBy': auth.state!.id});
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<void> updateSession(FirebaseFirestore db, SessionModel s) async {
    String userId = s.memberId;
    final resp1 = await db.collection("User").where('id', isEqualTo: userId).where('isActive', isEqualTo: true).get();
    Map<String, String> users = {};
    resp1.docs.forEach((f) {
      users[makeMapSerialize(f.data())['id'] ?? ""] = makeMapSerialize(f.data())['name'] ?? "";
    });
    sessions = sessions.map((m) => m.copyWith(memberName: users[m.memberId])).toList();
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    sessionListener?.pause();
    await sessionListener?.cancel();
    super.dispose();
  }
}
